#!/bin/bash

# Source CSV file
source_file="../files/a1.csv"

# Destination directory
destination_dir="../files/"

# Create the destination directory if it doesn't exist
mkdir -p "$destination_dir"

# Make 100 copies
for ((i = 1; i <= 10; i++)); do
    cp "$source_file" "$destination_dir/copy_$i.csv"
done

echo "100 copies of $source_file created in $destination_dir."
