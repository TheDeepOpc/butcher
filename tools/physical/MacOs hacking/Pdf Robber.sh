#!/bin/bash

# Morpheus: Use with proper authorization only

set -euo pipefail

# Script directory and backup destination
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
backup_dir="$script_dir/personal_document_backup"
mkdir -p "$backup_dir"

# Where to search (user home)
search_dir="$HOME"

# Document and image formats
extensions="png pdf rtf md PNG PDF RTF MD"

echo "[INFO] Qidirilmoqda: $search_dir ichidagi barcha papkalar va subfolderlar"

# Build file list
tmp_file_list=$(mktemp)

for ext in $extensions; do
    find "$search_dir" -type f -iname "*.$ext" >> "$tmp_file_list"
done

# Exclude system, application, and library folders
grep -Ev "^/Library/|^/System/Library/|^/Applications/" "$tmp_file_list" > "${tmp_file_list}_filtered"
mv "${tmp_file_list}_filtered" "$tmp_file_list"

total_files=$(wc -l < "$tmp_file_list")
echo "[INFO] Topildi: $total_files ta fayl (.png, .pdf, .rtf, .md)"

if [ "$total_files" -eq 0 ]; then
    echo "[ERROR] Fayllar topilmadi."
    rm "$tmp_file_list"
    exit 1
fi

echo "[INFO] Nusxalanmoqda (progress bar):"

# Progress bar and unique naming
if command -v pv >/dev/null 2>&1; then
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

echo "[SUCCESS] Barcha shaxsiy .png, .pdf, .rtf, .md fayllar nusxa olindi: $backup_dir"

rm "$tmp_file_list"
