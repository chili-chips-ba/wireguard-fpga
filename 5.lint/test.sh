#!/bin/bash

# Define the absolute or relative path to the 1.hw folder
hw_folder="../1.hw"

# Check if the folder exists
if [ ! -d "$hw_folder" ]; then
    echo "The folder $hw_folder does not exist. Please check the path."
    exit 1
fi

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

# Find all .sv and .v files in the 1.hw folder and subfolders, and run the lint function for each file
#find "$hw_folder" -type f \( -name "*.sv" -o -name "*.v" \) -exec bash -c 'lint_file "$0"' {} \;
find "$hw_folder" -type f \( -name "*.sv" -o -name "*.v" \) ;

echo "All linting results are saved in the $results_folder folder"