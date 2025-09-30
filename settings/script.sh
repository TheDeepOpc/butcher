#!/bin/bash
set -euo pipefail

# === RANGLAR ===
GREEN="\e[32m"
RED="\e[31m"
WHITE="\e[97m"
BOLD="\e[1m"
RESET="\e[0m"

# === Matnni sekin chiqarish funksiyasi ===
type_text() {
    local text="$1"
    local delay="${2:-0.01}"
    for (( i=0; i<${#text}; i++ )); do
        echo -ne "${GREEN}${text:$i:1}${RESET}"
        sleep "$delay"
    done
    echo
}

# === Kerakli paketlar ro'yxati ===
tools=(
    git nikto ffuf nmap whatweb wpscan
    aircrack-ng bc awk curl cowpatty dhcpd 7zr hostapd lighttpd
    iwconfig macchanger mdk4 dsniff mdk3 openssl php-cgi xterm
    rfkill unzip route fuser killall
)

clear
echo -e "${BOLD}${GREEN}[*] Ishga kerakli paketlarni yuklayabman Mr/Miss Butcher ${RESET}"
echo

# Jadval sarlavhasi
printf "${BOLD}${WHITE}%-15s${RESET} | ${BOLD}${WHITE}%-20s${RESET}\n" "PAKET" "STATUS"
printf "${WHITE}%-15s-+-%-20s${RESET}\n" "---------------" "--------------------"

# === Paketlarni tekshirish va o‘rnatish ===
for tool in "${tools[@]}"; do
    if command -v "$tool" &> /dev/null; then
        printf "${GREEN}%-15s${RESET} | ${GREEN}OK${RESET}\n" "$tool"
    else
        printf "${WHITE}%-15s${RESET} | ${RED}O‘rnatilmoqda...${RESET}\n" "$tool"
        if sudo apt install -y "$tool" &>/dev/null; then
            printf "${GREEN}%-15s${RESET} | ${GREEN}OK (o‘rnatildi)${RESET}\n" "$tool"
        else
            printf "${RED}%-15s${RESET} | ${RED}❌ Xatolik${RESET}\n" "$tool"
        fi
    fi
done

# === Git clone qismi ===
REPO_URL="https://github.com/TheDeepOpc/fluxtionButcher"
TARGET_DIR="fluxtionButcher"

echo
if [ ! -d "$TARGET_DIR" ]; then
    echo -e "${WHITE}[*]${RESET} ${GREEN}$TARGET_DIR${RESET} katalogi topilmadi. ${RED}Fluxion Modified version Butcher Klon qilinmoqda...${RESET}"
    git clone "$REPO_URL" "$TARGET_DIR"
    echo -e "${GREEN}[+]${RESET} Repozitoriya muvaffaqiyatli klon qilindi: ${WHITE}$TARGET_DIR${RESET}"
else
    echo -e "${GREEN}[+]${RESET} $TARGET_DIR allaqachon mavjud, qaytadan yuklash shart emas MR/Miss.Butcher"
fi

# === Tanlangan skriptlarga bajarish huquqi berish ===
scripts_to_make_exec=(
    "../setup.sh"
    "../physical.sh"
    "../physical/About malwares/run.sh"
)

echo
echo -e "${WHITE}[*]${RESET} ${GREEN}Tanlangan skriptlarga +x huquqi berilmoqda...${RESET}"

for scr in "${scripts_to_make_exec[@]}"; do
    if [ -f "$scr" ]; then
        chmod +x "$scr"
        echo -e "${GREEN}[+]${RESET} $scr ga +x berildi"
    else
        echo -e "${RED}[!]${RESET} $scr topilmadi"
    fi
done

echo
echo -e "${BOLD}${GREEN}[✅] Barcha paketlar tekshirildi, fluxtionButcher tayyor va ko‘rsatilgan skriptlarga +x berildi!${RESET}"
