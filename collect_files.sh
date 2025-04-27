#!/bin/bash

if [ "$#" -ne 2 ]; then
    exit 1
fi

in_dir="$1"
out_dir="$2"

mkdir -p "$out_dir"
for f in $(find "$in_dir" -maxdepth 2 -type f); do
    cp "$f" "$out_dir/"
done
# 2 готово!