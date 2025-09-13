#!/usr/bin/env bash
set -euo pipefail

SCRIPT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LANG_FILE="$SCRIPT_ROOT/languages.txt"

# ================= LANG CHOICE =================
# Setup.sh dan kelgan argumentni oling, default EN
LANG_CHOICE="${1:-EN}"

# ================= FUNC: GET STRING =================
msg() {
    local key="$1"
    local col
    case "$LANG_CHOICE" in
        EN) col=2 ;;
        UZ) col=3 ;;
        RU) col=4 ;;
        *)  col=2 ;;
    esac
    awk -F'|' -v k="$key" -v c="$col" '$1==k {print $c}' "$LANG_FILE"
}

choose_path() {
    local current_dir="$1"
    while true; do
        local entries=()
        for item in "$current_dir"/*; do
            [[ -d "$item" ]] && entries+=("📁 $(basename "$item")")
            [[ -f "$item" ]] && entries+=("📄 $(basename "$item")")
        done

        if [[ ${#entries[@]} -eq 0 ]]; then
            echo "❌ $(msg empty): $current_dir"
            return
        fi

        echo -e "\n📂 $(msg current): $current_dir"
        echo "0) $(msg back)"
        local i=1
        for e in "${entries[@]}"; do
            echo "$i) $e"
            ((i++))
        done

        read -rp "> $(msg choose): " num
        [[ "$num" =~ ^[0-9]+$ ]] || { echo "$(msg number_err)"; continue; }

        if (( num == 0 )); then
            return
        elif (( num >= 1 && num <= ${#entries[@]} )); then
            local selected="${entries[$((num-1))]}"
            local name
            name=$(echo "$selected" | sed -E 's/^[^ ]+ //' )

            local full="$current_dir/$name"

            if [[ -d "$full" ]]; then
                # Agar About Malwares papkasi tanlansa
                if [[ "$name" == "About malwares" ]]; then
                    local run_file="$full/run.sh"
                    if [[ -f "$run_file" ]]; then
                        bash "$run_file"
                        return
                    else
                        echo "❌ run.sh not found in $full"
                        return
                    fi
                else
                    # Boshqa papkaga kirish
                    choose_path "$full"
                    continue
                fi
            elif [[ -f "$full" ]]; then
                local target="$SCRIPT_ROOT/malwares"
                mkdir -p "$target"
                cp "$full" "$target/"
                echo "✅ '$name' $(msg copied) $target/"
                return
            fi
        else
            echo "$(msg number_err)"
        fi
    done
}

# --- Boshlanish ---

START_DIR="$SCRIPT_ROOT/tools/physical"
if [[ ! -d "$START_DIR" ]]; then
    echo "❌ $(msg start_notfound): $START_DIR"
    exit 1
fi

choose_path "$START_DIR"
