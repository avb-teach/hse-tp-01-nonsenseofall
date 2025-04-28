#!/bin/bash
#полностью перепишу код, мне кажется ошибка в том что на каком -то из шагов создается директория out и она ломает все тесты после pull request
#!!! все ссылки на сайты откуда я беру информацию для кодирования на bash находятся в версии  commit final(1) @ 2450add28efb711fdb1e1848dcf2b71d0a44f995  @
max_depth=""
pos=()
while [ $# -gt 0 ]; do #https://www.gnu.org/software/bash/manual/html_node/Conditional-Constructs.html#index-regexp-matching
  case "$1" in
    --max_depth)
      if [[ "$2" =~ ^[0-9]+$ ]]; then # по-новому поиск значения при запросе max-depth, по идее так как предыдущий код прошел тесты, то значит покрываются случаи описанные в заданиях 2-3
        max_depth="$2"
        shift 2 # https://www.gnu.org/software/bash/manual/html_node/Bourne-Shell-Builtins.html#index-shift(мотод удаления(пропускания данных))
      else

        exit 1
      fi
      ;;
    *)
      pos+=("$1")
      shift
      ;;
  esac
done
if [ "${#pos[@]}" -ne 2 ]; then #поддтяжка из старого кода перовго задания, @ для того чтобы взять все из массива(все элемнты в переданных значениях при тестах)
  exit 1                        #еще из ветки solution tp тянем проверку на два элемента за собой
fi

input_dir="${pos[0]}"
output_dir="${pos[1]}"

if [ ! -d "$input_dir" ]; then
  exit 1
fi
mkdir -p "$output_dir"
find "$input_dir" -type f | while IFS= read -r file; do # чтение строк с пробелами iFS, чтобы максимально корректно выполнить обход https://mywiki.wooledge.org/IFS
  rel="${file#"$input_dir"/}" # ссылки откуда я прочитал про такие методы обрезания в более ранних committ  ветки solution_tp
  if [ -n "$max_depth" ]; then
    tmp="$rel"
    slash_count=0
    while [ "${tmp#*/}" != "$tmp" ]; do
      slash_count=$((slash_count + 1)) ##забыл добавить ссылку на корректное увеличение varaible https://askubuntu.com/questions/385528/how-to-increment-a-variable-in-bash
      tmp="${tmp#*/}"
    done
    comps=$((slash_count + 1))
    while [ "$comps" -gt "$max_depth" ]; do
      rel="${rel#*/}"
      comps=$((comps - 1))
    done
  fi
  dest="$output_dir/$rel"
  dir="${dest%/*}"
  base="${dest##*/}"
  mkdir -p "$dir"
  name="${base%.*}"
  ext="${base##*.}"
  new_base="$base"
  count=1
  while [ -e "$dir/$new_base" ]; do #ссылки в предыдущих версиях
    if [ "$ext" != "$base" ]; then
      new_base="${name}_${count}.${ext}"
    else
      new_base="${name}_${count}"
    fi
    count=$((count + 1))
  done
  cp "$file" "$dir/$new_base"
done