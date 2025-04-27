#!/bin/bash
#--1--
if [ "$#" -ne 2 ]; then
    exit 1
fi
#--2--
in_dir="$1"
out_dir="$2"

mkdir -p "$out_dir"
for f in $(find "$in_dir" -maxdepth 2 -type f); do
    cp "$f" "$out_dir/"
done

#--3--
#пробую отдельно для рекурсивного задания переписать, потому что не уверен, 
#что если уберу для глубины 2, то тест 2 будет пройден корректно
find "$in_dir" -type f | while read -r file; do #семинар+ https://habr.com/ru/companies/alexhost/articles/525394/ про find 
    cp "$file" "$out_dir/"
done
