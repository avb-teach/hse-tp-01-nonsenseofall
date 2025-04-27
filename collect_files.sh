#!/bin/bash

if [ "$#" -ne 2 ]; then
    exit 1
fi

# 1 задание выполняется наконец-то верно!
in_dir="$1"
out_dir="$2"

mkdir -p "$out_dir"
for f in $(find "$in_dir" -maxdepth 2 -type f); do
    cp "$f" "@$out_dir/"
done