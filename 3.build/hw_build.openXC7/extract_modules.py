#!/usr/bin/env python3
"""
Module Extractor for sv2v Flattened Output
==========================================

When sv2v converts SystemVerilog with interfaces to Verilog, it often
inlines modules that use interfaces into the top-level module. This script
extracts those modules back into standalone files.

Usage:
    python3 extract_modules.py all_converted.v [output_dir]

Author: Generated for WireGuard FPGA project
"""

import re
import os
import sys
from pathlib import Path
from dataclasses import dataclass, field
from typing import List, Dict, Set, Optional, Tuple
from enum import Enum

class ModuleType(Enum):
    REGULAR = "regular"
    INLINED = "inlined"
    STUB = "stub"

@dataclass
class Module:
    """Represents a Verilog module."""
    name: str
    content: str
    start_line: int
    end_line: int
    module_type: ModuleType = ModuleType.REGULAR
    original_source: str = ""

@dataclass
class ExtractionResult:
    """Results of module extraction."""
    modules: List[Module] = field(default_factory=list)
    inlined_instances: Dict[str, str] = field(default_factory=dict)
    missing_expected: List[str] = field(default_factory=list)
    warnings: List[str] = field(default_factory=list)

# Expected modules based on WireGuard FPGA project structure
EXPECTED_MODULES = {
    # Packages (will be eliminated/inlined by sv2v)
    'dpe_pkg': 'package',
    'soc_pkg': 'package', 
    'csr_pkg': 'package',
    
    # Interfaces (will be eliminated/inlined by sv2v)
    'dpe_if': 'interface',
    'soc_if': 'interface',
    'gmii_if': 'interface',
    
    # Infrastructure modules
    'ethernet_mac': 'module',
    'ethernet_phy': 'module',
    'cpu_fifo': 'module',
    'soc_fabric': 'module',
    'soc_ram': 'module',
    'soc_csr': 'module',
    'uart': 'module',
    'dpe_if_skid_buffer': 'module',
    'sync_fifo_ram': 'module',
    'clk_rst_gen': 'module',
    
    # DPE modules
    'dpe': 'module',
    'dpe_demultiplexer': 'module',
    'dpe_multiplexer': 'module',
    'dpe_dummy_switch': 'module',
    
    # CPU modules
    'picorv32': 'module',
    'picorv32_pcpi_mul': 'module',
    'picorv32_pcpi_fast_mul': 'module',
    'picorv32_pcpi_div': 'module',
    'imem': 'module',
    'soc_cpu': 'module',
    
    # PLL modules
    'fpga_pll_125M': 'module',
    'fpga_pll_80M': 'module',
    
    # Top-level
    'csr': 'module',
    'top': 'module',
}

def parse_top_level_modules(content: str) -> List[Module]:
    """
    Parse top-level module definitions from Verilog content.
    
    A top-level module starts with 'module' at the beginning of a line
    (possibly with leading whitespace removed by sv2v).
    """
    modules = []
    lines = content.split('\n')
    
    i = 0
    while i < len(lines):
        line = lines[i]
        
        # Match module declaration at start of line (no significant indentation)
        match = re.match(r'^module\s+(\w+)\s*', line)
        if match:
            module_name = match.group(1)
            start_line = i
            
            # Collect lines until endmodule
            module_lines = [line]
            i += 1
            depth = 1  # Track nested module/endmodule (shouldn't happen, but safety)
            
            while i < len(lines):
                curr_line = lines[i]
                module_lines.append(curr_line)
                
                # Check for nested module (unlikely but possible)
                if re.match(r'^module\s+\w+', curr_line):
                    depth += 1
                
                if re.match(r'^endmodule', curr_line):
                    depth -= 1
                    if depth == 0:
                        break
                
                i += 1
            
            modules.append(Module(
                name=module_name,
                content='\n'.join(module_lines),
                start_line=start_line,
                end_line=i,
                module_type=ModuleType.REGULAR
            ))
        
        i += 1
    
    return modules

def find_inlined_instances(content: str) -> Dict[str, Tuple[int, int, str]]:
    """
    Find generate blocks that contain inlined module content.
    
    sv2v converts interface-using modules to:
    
        generate
            if (1) begin : u_instance_name
                wire [7:0] signal;
                ...
            end
        endgenerate
    
    Returns dict of instance_name -> (start_line, end_line, content)
    """
    instances = {}
    lines = content.split('\n')
    
    i = 0
    while i < len(lines):
        line = lines[i]
        
        # Look for generate block start
        if re.match(r'\s*generate\s*$', line):
            gen_start = i
            i += 1
            
            # Look for "if (1) begin : name" pattern
            while i < len(lines):
                if_match = re.match(r'\s*if\s*\(1\)\s*begin\s*:\s*(\w+)', lines[i])
                if if_match:
                    instance_name = if_match.group(1)
                    block_start = i
                    
                    # Find matching end
                    depth = 1
                    block_lines = [lines[i]]
                    i += 1
                    
                    while i < len(lines) and depth > 0:
                        block_lines.append(lines[i])
                        
                        # Track begin/end depth
                        if re.search(r'\bbegin\b', lines[i]):
                            depth += lines[i].count('begin')
                        if re.search(r'\bend\b', lines[i]):
                            depth -= lines[i].count('end')
                        
                        i += 1
                    
                    # Check if this looks like a substantial module
                    block_content = '\n'.join(block_lines)
                    if is_substantial_block(block_content):
                        instances[instance_name] = (block_start, i, block_content)
                    
                    break
                elif re.match(r'\s*endgenerate', lines[i]):
                    break
                i += 1
        
        i += 1
    
    return instances

def is_substantial_block(content: str) -> bool:
    """
    Determine if a generate block contains substantial module-like content.
    """
    # Must have actual logic, not just wire pass-through
    has_logic = bool(re.search(r'\b(always|assign|reg\s+\[|wire\s+\[)', content))
    has_multiple_statements = content.count(';') > 3
    has_instance = bool(re.search(r'\w+\s+#?\s*\([^)]+\)\s*\w+\s*\(', content))
    
    return has_logic or has_multiple_statements or has_instance

def create_stub_module(name: str, original_type: str) -> Module:
    """
    Create a stub module for packages/interfaces that were inlined.
    """
    comment = f"// Stub for {original_type} '{name}'"
    if original_type == 'package':
        comment += "\n// Package contents were inlined into modules that import it"
    elif original_type == 'interface':
        comment += "\n// Interface signals were flattened into port lists"
    
    content = f"""{comment}
// This empty module satisfies Yosys module resolution
module {name} ();
endmodule
"""
    
    return Module(
        name=name,
        content=content,
        start_line=0,
        end_line=0,
        module_type=ModuleType.STUB,
        original_source=original_type
    )

def extract_modules(input_file: str) -> ExtractionResult:
    """
    Main extraction function.
    """
    result = ExtractionResult()
    
    print(f"Reading {input_file}...")
    with open(input_file, 'r') as f:
        content = f.read()
    
    total_lines = content.count('\n')
    print(f"  Total lines: {total_lines}")
    
    # Step 1: Parse top-level modules
    print("\nParsing top-level modules...")
    result.modules = parse_top_level_modules(content)
    print(f"  Found {len(result.modules)} top-level modules:")
    for m in result.modules:
        print(f"    - {m.name}")
    
    found_names = {m.name for m in result.modules}
    
    # Step 2: Find inlined instances in generate blocks
    print("\nSearching for inlined modules in generate blocks...")
    result.inlined_instances = find_inlined_instances(content)
    if result.inlined_instances:
        print(f"  Found {len(result.inlined_instances)} inlined instances:")
        for name in result.inlined_instances:
            print(f"    - {name}")
    else:
        print("  No inlined instances found in generate blocks")
    
    # Step 3: Check for missing expected modules
    print("\nChecking expected modules...")
    for name, mod_type in EXPECTED_MODULES.items():
        if name not in found_names:
            result.missing_expected.append(name)
            
            # Packages and interfaces are expected to be missing
            if mod_type in ('package', 'interface'):
                print(f"  {name}: Expected (was {mod_type}, inlined by sv2v)")
            else:
                # Check if it's in inlined instances
                matching_instances = [inst for inst in result.inlined_instances 
                                     if name in inst.lower() or inst.lower().endswith(name)]
                if matching_instances:
                    print(f"  {name}: Inlined as generate block ({matching_instances})")
                else:
                    print(f"  {name}: MISSING - may be inlined in top.v")
                    result.warnings.append(f"Module '{name}' not found as standalone")
    
    return result

def write_modules(result: ExtractionResult, output_dir: str):
    """
    Write extracted modules to individual files.
    """
    os.makedirs(output_dir, exist_ok=True)
    
    written_count = 0
    
    # Write regular modules
    print(f"\nWriting modules to {output_dir}/...")
    for module in result.modules:
        filename = os.path.join(output_dir, f"{module.name}.v")
        with open(filename, 'w') as f:
            f.write(module.content)
        print(f"  -> {module.name}.v ({module.content.count(chr(10))} lines)")
        written_count += 1
    
    # Create stubs for packages and interfaces (they don't need actual content)
    print("\nCreating stubs for inlined packages/interfaces...")
    for name in result.missing_expected:
        if name in EXPECTED_MODULES:
            mod_type = EXPECTED_MODULES[name]
            if mod_type in ('package', 'interface'):
                stub = create_stub_module(name, mod_type)
                filename = os.path.join(output_dir, f"{name}.v")
                
                # Don't overwrite if already exists
                if not os.path.exists(filename):
                    with open(filename, 'w') as f:
                        f.write(stub.content)
                    print(f"  -> {name}.v (stub for {mod_type})")
                    written_count += 1
    
    return written_count

def analyze_top_module(result: ExtractionResult, output_dir: str):
    """
    Analyze top module for embedded content and generate report.
    """
    top_module = next((m for m in result.modules if m.name == 'top'), None)
    if not top_module:
        return
    
    print("\nAnalyzing top module structure...")
    
    # Count generate blocks
    generate_count = top_module.content.count('generate')
    print(f"  Generate blocks: {generate_count}")
    
    # Count module instantiations
    inst_pattern = re.compile(r'(\w+)\s+(?:#\s*\([^)]*\))?\s*(\w+)\s*\(')
    instances = inst_pattern.findall(top_module.content)
    unique_types = set(inst[0] for inst in instances if inst[0] not in ('if', 'for', 'case', 'begin'))
    print(f"  Module types instantiated: {len(unique_types)}")
    
    # Write analysis report
    report_path = os.path.join(output_dir, "EXTRACTION_REPORT.txt")
    with open(report_path, 'w') as f:
        f.write("=" * 60 + "\n")
        f.write("SV2V Module Extraction Report\n")
        f.write("=" * 60 + "\n\n")
        
        f.write("EXTRACTED MODULES:\n")
        for m in result.modules:
            f.write(f"  - {m.name} ({m.content.count(chr(10))} lines)\n")
        
        f.write(f"\nMISSING EXPECTED MODULES:\n")
        for name in result.missing_expected:
            mod_type = EXPECTED_MODULES.get(name, 'unknown')
            f.write(f"  - {name} ({mod_type})\n")
        
        if result.inlined_instances:
            f.write(f"\nINLINED INSTANCES (in generate blocks):\n")
            for name in result.inlined_instances:
                f.write(f"  - {name}\n")
        
        if result.warnings:
            f.write(f"\nWARNINGS:\n")
            for warning in result.warnings:
                f.write(f"  ! {warning}\n")
        
        f.write("\n" + "=" * 60 + "\n")
        f.write("END OF REPORT\n")
    
    print(f"\n  Report written to: {report_path}")

def main():
    if len(sys.argv) < 2:
        print("Usage: extract_modules.py <all_converted.v> [output_dir]")
        print()
        print("Extracts modules from sv2v flattened output.")
        print("Creates stub modules for packages/interfaces that were inlined.")
        sys.exit(1)
    
    input_file = sys.argv[1]
    output_dir = sys.argv[2] if len(sys.argv) > 2 else "extracted"
    
    if not os.path.exists(input_file):
        print(f"ERROR: Input file not found: {input_file}")
        sys.exit(1)
    
    # Extract modules
    result = extract_modules(input_file)
    
    # Write to files
    written = write_modules(result, output_dir)
    
    # Analyze top module
    analyze_top_module(result, output_dir)
    
    # Summary
    print("\n" + "=" * 60)
    print("EXTRACTION COMPLETE")
    print("=" * 60)
    print(f"  Output directory: {output_dir}/")
    print(f"  Total files written: {written}")
    print(f"  Regular modules: {len(result.modules)}")
    print(f"  Stub modules: {written - len(result.modules)}")
    
    if result.warnings:
        print(f"\n  ⚠ Warnings: {len(result.warnings)}")
        print("    Check EXTRACTION_REPORT.txt for details")
    
    # Final file count
    v_files = list(Path(output_dir).glob('*.v'))
    print(f"\n  .v files in output: {len(v_files)}")

if __name__ == '__main__':
    main()
