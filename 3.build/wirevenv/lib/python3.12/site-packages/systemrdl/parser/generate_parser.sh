#!/bin/bash
cd "$( dirname "${BASH_SOURCE[0]}" )"

antlr4="java -Xmx500M -cp /usr/local/lib/antlr-4.13.2-complete.jar org.antlr.v4.Tool"

# Generate Python target
$antlr4 -Dlanguage=Python3 -visitor -no-listener SystemRDL.g4

# Generate C++ parse accelerator extension
$antlr4 -Dlanguage=Cpp -visitor -no-listener -o ext SystemRDL.g4
python3 <<EOF
from speedy_antlr_tool import generate

generate(
    py_parser_path="SystemRDLParser.py",
    cpp_output_dir="ext",
    entry_rule_names=["root", "eval_expr_root"],
)
EOF

# Create stub file for mypy
stubgen  SystemRDLParser.py -o ../../
