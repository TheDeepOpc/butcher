#!/bin/bash

backup_dir=~/telegram_backup
container_dir=~/Library/Containers
found_tdata=""

if [ -d "$container_dir" ]; then
    for bundle in "$container_dir"/*; do
        tdata_path="$bundle/Data/Library/Application Support/Telegram Desktop/tdata"
        if [ -d "$tdata_path" ]; then
            found_tdata="$tdata_path"
            echo "[INFO] Topildi: $tdata_path"
            break
        fi
    done
fi

if [ -z "$found_tdata" ]; then
    std_tdata="$HOME/Library/Application Support/Telegram Desktop/tdata"
    if [ -d "$std_tdata" ]; then
        found_tdata="$std_tdata"
        echo "[INFO] Standart path topildi: $found_tdata"
    fi
fi

if [ -n "$found_tdata" ]; then
    mkdir -p "$backup_dir"
    echo "[INFO] Nusxalanmoqda: $found_tdata → $backup_dir/tdata_backup"

    # rsync bilan progress bar
    rsync -a --info=progress2 "$found_tdata/" "$backup_dir/tdata_backup/"

    chflags hidden "$backup_dir/tdata_backup"
    echo "[SUCCESS] tdata nusxa olindi va yashirildi: $backup_dir/tdata_backup"
else
    echo "[ERROR] tdata papkasi topilmadi."
fi