#!/bin/bash
#--1--
if [ "$#" -ne 2 ]; then
    exit 1
fi
#--2--
in_dir="$1"
out_dir="$2"
max_depth=""
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

#--4-- 
# За этот тест уже 2 балла стоит без написанной части
find "$input_dir" -type f | while read -r input_file; do

    filename=$(basename "$input_file") 
    file_extension="${filename##*.}" #ссылка на сай где взял строки 26-28 https://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html
    file_name_no_ext="${filename%.*}"

    counter=1
    new_filename="$filename"
    output_path="$output_dir/$new_filename"

    while [[ -e "$output_path" ]]; do #проверка файла на exist https://www.gnu.org/software/bash/manual/html_node/Bash-Conditional-Expressions.html
        new_filename="${file_name_no_ext}_${counter}.${file_extension}"
        output_path="$output_dir/$new_filename"
        ((counter++)) #забыл добавить ссылку на корректное увеличение varaible https://askubuntu.com/questions/385528/how-to-increment-a-variable-in-bash
    done

    cp "$input_file" "$output_path"

done
#--5--


#!/bin/bash

# Параметры по умолчанию
in_dir="input_dir"
out_dir="output_dir"
max_depth=""  # По умолчанию без ограничения глубины

while [[ $# -gt 0 ]]; do # В этой версии хочу убедиться в правильночти получения max depth в омандной строке
    case "$1" in
        --max_depth)
            max_depth="$2"
            shift 2
            ;;
        *)
            echo "Неизвестный параметр: $1"
            exit 1
            ;;
            
    esac
done
depth_arg=("$in_dir" -type f)
if [[ -n "$max_depth" ]]; then
    depth_arg+=(-maxdepth "$max_depth")
fi
find "${depth_arg[@]}" | while read -r file; do
    relative_path="${file#$in_dir/}"
    
    dir_path=$(dirname -- "$relative_path")
    filename=$(basename -- "$relative_path")
    mkdir -p "$out_dir/$dir_path"
    
    dest="$out_dir/$dir_path/$filename"
    
    cp -- "$file" "$dest"

done