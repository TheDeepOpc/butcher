#!/bin/bash

backup_dir="$HOME/.media_backup"
mkdir -p "$backup_dir"

search_dir="$HOME"

extensions="mp4 mov m4a mp3 MP4 MOV M4A MP3"

echo "[INFO] Qidirilmoqda: $search_dir ichidagi barcha papkalar va subfolderlar"

tmp_file_list=$(mktemp)

for ext in $extensions; do
    find "$search_dir" -type f -iname "*.$ext" >> "$tmp_file_list"
done

total_files=$(wc -l < "$tmp_file_list")
echo "[INFO] Topildi: $total_files ta media fayli"

if [ $total_files -eq 0 ]; then
    echo "[ERROR] Media fayllari topilmadi."
    rm "$tmp_file_list"
    exit 1
fi

echo "[INFO] Nusxalanmoqda (progress bar):"

if command -v pv > /dev/null 2>&1; then
    cat "$tmp_file_list" | pv -ptb -s $total_files | while read -r file; do
        base=$(basename "$file")
        dest="$backup_dir/$base"
        i=1
        while [ -e "$dest" ]; do
            dest="$backup_dir/${base%.*}_$i.${base##*.}"
            ((i++))
        done
        rsync -a "$file" "$dest"
    done
else
    n=0
    while read -r file; do
        n=$((n+1))
        base=$(basename "$file")
        dest="$backup_dir/$base"
        i=1
        while [ -e "$dest" ]; do
            dest="$backup_dir/${base%.*}_$i.${base##*.}"
            ((i++))
        done
        rsync -a "$file" "$dest"
        echo -ne "[$n/$total_files] Nusxalanmoqda: $(basename "$file")\r"
    done < "$tmp_file_list"
    echo
fi

echo "[SUCCESS] Barcha media fayllar nusxa olindi: $backup_dir"
rm "$tmp_file_list"