#!/usr/bin/env python3

import os
import sys
import subprocess
from pathlib import Path
from typing import Dict, List, Tuple
from concurrent.futures import Future, ProcessPoolExecutor
import shlex

class PipelineExecutor:
    def __init__(self, max_loop_iterations: int = 1000):
        self.max_loop_iterations = max_loop_iterations
    
    def parse_control_file(self, filepath: Path) -> Dict[str, str]:
        """Parse a control file into a dictionary."""
        config: Dict[str, str] = {}
        
        if not filepath.exists():
            return config
            
        with open(filepath, 'r') as f:
            for line in f:
                line = line.strip()
                if not line or line.startswith('#'):
                    continue
                if '=' in line:
                    key, value = line.split('=', 1)
                    config[key.strip()] = value.strip()
        return config
    
    def get_directory_items(self, directory: Path) -> List[str]:
        """Get sorted list of non-hidden files/dirs using native Python for consistency."""
        try:
            items: List[str] = []
            for item in sorted(directory.iterdir()):
                name = item.name
                # Include non-hidden files/dirs and control files
                if not name.startswith('.') or name.endswith('.control'):
                    items.append(name)
            return items
        except (OSError, PermissionError):
            return []
    
    def should_continue_loop(self, loop_type: str, condition: str, 
                           iteration: int, count: int, data: bytes) -> bool:
        """Evaluate loop condition based on type."""
        if loop_type == 'for':
            try:
                max_count = int(count)
            except (ValueError, TypeError):
                print(f"Error: Invalid count '{count}' in loop configuration", file=sys.stderr)
                return False
            return iteration < max_count
        
        elif loop_type == 'while':
            # While loops check condition with current data
            if not condition:
                return False
            try:
                # Split condition for safer execution
                cmd_args = shlex.split(condition)
                result = subprocess.run(
                    cmd_args,
                    input=data,
                    capture_output=True
                )
                return result.returncode == 0
            except (subprocess.SubprocessError, ValueError, OSError):
                return False
        
        elif loop_type == 'until':
            # Until loops run at least once, then check condition
            if iteration == 0:
                return True
            if not condition:
                return False
            try:
                # Split condition for safer execution
                cmd_args = shlex.split(condition)
                result = subprocess.run(
                    cmd_args,
                    input=data,
                    capture_output=True
                )
                return result.returncode != 0  # Continue until condition is true
            except (subprocess.SubprocessError, ValueError, OSError):
                return False
        
        elif loop_type == 'do-while':
            # Do-while runs at least once
            if iteration == 0:
                return True
            if not condition:
                return False
            try:
                # Split condition for safer execution
                cmd_args = shlex.split(condition)
                result = subprocess.run(
                    cmd_args,
                    input=data,
                    capture_output=True
                )
                return result.returncode == 0
            except (subprocess.SubprocessError, ValueError, OSError):
                return False
        
        return False
    
    def execute_file(self, filepath: Path, input_data: bytes) -> bytes:
        """Execute a file with input data and return output."""
        try:
            result = subprocess.run(
                [str(filepath)],
                input=input_data,
                capture_output=True,
                check=True
            )
            return result.stdout
        except subprocess.CalledProcessError as e:
            # Propagate non-zero exit codes
            sys.exit(e.returncode)
    
    def process_directory_sequential(self, directory: Path, input_data: bytes,
                                   items: List[str]) -> bytes:
        """Process directory items sequentially."""
        current_data = input_data
        for item in items:
            filepath = directory / item
            # Skip symlinks and control files
            if filepath.is_symlink():
                continue
            if item in ['loop.control', 'parallel.control']:
                continue
            if filepath.is_dir():
                # Process subdirectory (which may have its own loop)
                current_data = self.process_directory_with_loop(filepath, current_data)
            elif filepath.is_file() and os.access(filepath, os.X_OK):
                # Execute file
                current_data = self.execute_file(filepath, current_data)
        return current_data
    
    def process_directory_parallel(self, directory: Path, input_data: bytes,
                                 items: List[str], combine: str, 
                                 workers: int) -> bytes:
        """Process directory items in parallel."""
        # Prepare list of tasks
        tasks: List[Tuple[str, Path]] = []
        for item in items:
            filepath = directory / item
            # Skip symlinks and control files
            if filepath.is_symlink():
                continue
            if item in ['loop.control', 'parallel.control']:
                continue
            if filepath.is_dir():
                tasks.append(('dir', filepath))
            elif filepath.is_file() and os.access(filepath, os.X_OK):
                tasks.append(('file', filepath))
        if not tasks:
            return input_data
        # Execute tasks in parallel
        max_workers = None if workers == 0 else workers
        results: List[bytes] = []

        with ProcessPoolExecutor(max_workers=max_workers) as executor:
            futures: List[Future[bytes]] = []
            for task_type, filepath in tasks:
                if task_type == 'dir':
                    future = executor.submit(
                        self.process_directory_with_loop, filepath, input_data
                    )
                else:
                    future = executor.submit(self.execute_file, filepath, input_data)
                futures.append(future)
            # Collect results in order
            for future in futures:
                try:
                    results.append(future.result())
                except (subprocess.CalledProcessError, OSError, Exception) as e:
                    print(f"Error in parallel execution: {e}", file=sys.stderr)
                    sys.exit(1)
        
        # Combine results based on strategy
        if combine == 'first' and results:
            return results[0]
        elif combine == 'last' and results:
            return results[-1]
        elif combine == 'merge':
            # Line-by-line round-robin merge
            lines: List[str] = []
            line_iterators = [r.decode('utf-8', errors='replace').splitlines() 
                            for r in results]
            while any(line_iterators):
                for iterator in line_iterators:
                    if iterator:
                        lines.append(iterator.pop(0))
            return '\n'.join(lines).encode('utf-8')
        else:  # concatenate (default)
            return b''.join(results)
    
    def process_directory_contents(self, directory: Path, input_data: bytes) -> bytes:
        """Process directory contents, checking for parallel configuration."""
        items = self.get_directory_items(directory)
        if not items:
            return input_data
        # Check for parallel configuration
        parallel_file = directory / 'parallel.control'
        if parallel_file.exists() and not parallel_file.is_symlink():
            config = self.parse_control_file(parallel_file)
            combine = config.get('combine', 'concatenate')
            try:
                workers = int(config.get('workers', '0'))
            except (ValueError, TypeError):
                print(f"Error: Invalid workers '{config.get('workers', '0')}' in parallel configuration", file=sys.stderr)
                workers = 0
            return self.process_directory_parallel(
                directory, input_data, items, combine, workers
            )
        else:
            return self.process_directory_sequential(directory, input_data, items)
    
    def process_directory_with_loop(self, directory: Path, input_data: bytes) -> bytes:
        """Process directory with potential loop configuration."""
        loop_file = directory / 'loop.control'
        if loop_file.exists() and not loop_file.is_symlink():
            # Parse loop configuration
            config = self.parse_control_file(loop_file)
            loop_type = config.get('type')
            condition = config.get('condition', '')
            count = config.get('count', '1')
            if not loop_type:
                print(f"Error: loop.control file in {directory} missing 'type' field", 
                      file=sys.stderr)
                sys.exit(1)
            # Execute with loop
            iteration = 0
            current_data = input_data
            while iteration < self.max_loop_iterations:
                try:
                    count_int = int(count) if loop_type == 'for' else 0
                except (ValueError, TypeError):
                    count_int = 0
                if not self.should_continue_loop(
                    loop_type, condition, iteration, count_int, current_data
                ):
                    break
                # Process directory contents (may be parallel if parallel.control exists)
                current_data = self.process_directory_contents(directory, current_data)
                iteration += 1
            if iteration >= self.max_loop_iterations:
                print(f"Warning: Maximum loop iterations ({self.max_loop_iterations}) "
                      f"reached in {directory}", file=sys.stderr)
            return current_data
        else:
            # No loop, process normally
            return self.process_directory_contents(directory, input_data)
    
    def run(self, target_dir: str = '.'):
        """Main execution entry point."""
        directory = Path(target_dir)
        
        if not directory.is_dir():
            print(f"Error: Directory '{target_dir}' does not exist", file=sys.stderr)
            sys.exit(1)
        
        # Read initial input
        if sys.stdin.isatty():
            initial_input = b''
        else:
            initial_input = sys.stdin.buffer.read()
        
        # Process directory tree
        output = self.process_directory_with_loop(directory, initial_input)
        
        # Write output
        sys.stdout.buffer.write(output)


def main():
    """Main entry point."""
    import argparse
    
    parser = argparse.ArgumentParser(
        description='Execute files in directory tree with pipeline flow'
    )

    parser.add_argument('directory', nargs='?', default='.',
                       help='Target directory (default: current directory)')
    
    parser.add_argument('--max-loops', type=int, default=1000,
                       help='Maximum loop iterations (default: 1000)')
    
    args = parser.parse_args()
    
    executor = PipelineExecutor(max_loop_iterations=args.max_loops)
    
    executor.run(args.directory)


if __name__ == '__main__':
    main()