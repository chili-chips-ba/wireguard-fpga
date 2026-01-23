#!/bin/bash

# SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba, 2024-2025
#
# SPDX-License-Identifier: BSD-3-Clause

# Define the absolute or relative path to the 1.hw folder
hw_folder="../1.hw"
results_folder="results"
filelist="$hw_folder/top.filelist"

# Define the HW_SRC variable directly in the script
HW_SRC="$hw_folder"

# Check if the folder exists
if [ ! -d "$hw_folder" ]; then
    echo "The folder $hw_folder does not exist. Please check the path."
    exit 1
fi

# Create the results folder if it does not exist
mkdir -p "$results_folder"

# Function to lint files
lint_file() {
    local file="$1"
    local base_name=$(basename "$file")
    local result_name="${base_name//./_}"
    local result_file="results/${result_name}.txt"

    echo "Linting file: $file"
    echo "Results will be saved in: $result_file"
    touch "$result_file"
    # Run Verible linter and save output to the result file

    verible-verilog-lint "$file" \
    --rules=-no-trailing-spaces,+line-length=length:120 \
    > "$result_file" 2>&1
    
    # Check if the result file was created and display it in the console
    if [ -f "$result_file" ]; then
        echo "Linting results for $file saved in $result_file"
    else
        echo "Error: Linting results for $file were not saved."
    fi
}
rm -f "results"/*
export -f lint_file

# Read the top.filelist and extract .sv and .v files
files_to_lint=()
while IFS= read -r line; do
    # Skip comments and empty lines
    [[ "$line" =~ ^#.*$ ]] && continue
    [[ -z "$line" ]] && continue

	
    # Replace ${HW_SRC} with actual path
    line="${line//\$\{HW_SRC\}/$HW_SRC}"
	
	if [[ "$line" =~ ".sv" ]]; then
		files_to_lint+=("$line")
	fi
done < "$filelist"

# Check if files_to_lint array is empty
if [ ${#files_to_lint[@]} -eq 0 ]; then
    echo "No .sv or .v files found in $filelist"
    exit 1
fi

# Lint each file
for file in "${files_to_lint[@]}"; do
	echo "$file"
    lint_file "$file"
done

echo "All linting results are saved in the $results_folder folder"
