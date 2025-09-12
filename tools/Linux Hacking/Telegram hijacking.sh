#!/bin/bash

backup_dir="$HOME/.telegram_backup"
mkdir -p "$backup_dir"

found_tdata=""

std_tdata="$HOME/.local/share/TelegramDesktop/tdata"
if [ -d "$std_tdata" ]; then
    found_tdata="$std_tdata"
    echo "[INFO] Topildi: $found_tdata"
fi

if [ -z "$found_tdata" ]; then
    flatpak_tdata="$HOME/.var/app/org.telegram.desktop/data/TelegramDesktop/tdata"
    if [ -d "$flatpak_tdata" ]; then
        found_tdata="$flatpak_tdata"
        echo "[INFO] Flatpak path topildi: $found_tdata"
    fi
fi

if [ -n "$found_tdata" ]; then
    echo "[INFO] Nusxalanmoqda: $found_tdata → $backup_dir/tdata_backup"

    rsync -a --info=progress2 "$found_tdata/" "$backup_dir/tdata_backup/"

    echo "[SUCCESS] tdata maxfiy papkaga nusxa olindi: $backup_dir/tdata_backup"
else
    echo "[ERROR] tdata papkasi topilmadi."
fi