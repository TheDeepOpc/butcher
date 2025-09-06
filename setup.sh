#!/bin/bash

# ================= COLORS =================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# ================= LANG STRINGS =================
declare -A STRINGS_EN=(
    [welcome]="Welcome to Penetration Testing Toolkit"
    [select_lang]="Select Language:"
    [english]="English"
    [russian]="Russian"
    [uzbek]="Uzbek"
    [main_menu]="Main Menu - Penetration Testing Tools"
    [web_pentest]="Web Pentest"
    [subdomain_enum]="Subdomain Enumeration"
    [port_scan]="Port Scanning"
    [vuln_scan]="Vulnerability Scanning"
    [exit]="Exit"
    [invalid_choice]="Invalid choice. Please try again."
    [enter_target]="Enter target domain (example.com):"
    [subdomain_results]="Subdomain Enumeration Results"
    [scan_complete]="Scan completed!"
    [target_ip]="Target IP Address:"
)

declare -A STRINGS_RU=(
    [welcome]="Добро пожаловать в набор инструментов для пентестинга"
    [select_lang]="Выберите язык:"
    [english]="Английский"
    [russian]="Русский"
    [uzbek]="Узбекский"
    [main_menu]="Главное меню - Инструменты для пентестинга"
    [web_pentest]="Веб Пентест"
    [subdomain_enum]="Анализ субдоменов"
    [port_scan]="Сканирование портов"
    [vuln_scan]="Поиск уязвимостей"
    [exit]="Выход"
    [invalid_choice]="Неверный выбор. Попробуйте снова."
    [enter_target]="Введите целевой домен (example.com):"
    [subdomain_results]="Результаты анализа субдоменов"
    [scan_complete]="Сканирование завершено!"
    [target_ip]="IP адрес цели:"
)

declare -A STRINGS_UZ=(
    [welcome]="Penetration Testing vositalar to'plamiga xush kelibsiz"
    [select_lang]="Tilni tanlang:"
    [english]="Inglizcha"
    [russian]="Ruscha"
    [uzbek]="O'zbekcha"
    [main_menu]="Asosiy menyu - Penetration Testing vositalari"
    [web_pentest]="Web Pentest"
    [subdomain_enum]="Subdomain aniqlash"
    [port_scan]="Port skanerlash"
    [vuln_scan]="Zaifliklarni aniqlash"
    [exit]="Chiqish"
    [invalid_choice]="Noto'g'ri tanlov. Qaytadan urining."
    [enter_target]="Maqsadli domenni kiriting (example.com):"
    [subdomain_results]="Subdomain aniqlash natijalari"
    [scan_complete]="Skanerlash tugadi!"
    [target_ip]="Maqsadning IP manzili:"
)

# ================= GLOBAL LANG =================
LANG_CHOICE="EN"

# ================= FUNC: GET STRING =================
get_string() {
    local key=$1
    case $LANG_CHOICE in
        EN) echo "${STRINGS_EN[$key]}" ;;
        RU) echo "${STRINGS_RU[$key]}" ;;
        UZ) echo "${STRINGS_UZ[$key]}" ;;
        *) echo "${STRINGS_EN[$key]}" ;;
    esac
}



                                                                                            
                                                                                                                   
                     



                                  
                                                                      

# ================= FUNC: BANNER =================
show_banner() {
    clear
    echo -e "${RED}"
    echo "╔═  ══ ══ ══ ══ ══ ══ ══ ══ ══ ══ ══ ══ ══ ══ ══ ══ ══ ══ ══ ═"
    echo "                                                              "
    echo "║   ▗▄▄▖ ▗▖ ▗▖▗▄▄▄▖▗▄▄▖▗▖ ▗▖▗▄▄▄▖▗▄▄▖                        ║"
    echo "    ▐▌ ▐▌▐▌ ▐▌  █ ▐▌   ▐▌ ▐▌▐▌   ▐▌ ▐▌                        "
    echo "║   ▐▛▀▚▖▐▌ ▐▌  █ ▐▌   ▐▛▀▜▌▐▛▀▀▘▐▛▀▚▖                       ║"
    echo "    ▐▙▄▞▘▝▚▄▞▘  █ ▝▚▄▄▖▐▌ ▐▌▐▙▄▄▖▐▌ ▐▌                        "
    echo "║                                                            ║"
 echo -e "    ${WHITE}Butcher${NC}${RED} by ${CYAN}TheDeep${NC}${RED}                                        "
    echo "╚═  ══ ══ ══ ══ ══ ══ ══ ══ ══ ══ ══ ══ ══ ══ ══ ══ ══ ══ ══ ╝"
    echo -e "${NC}"
}



# ================= FUNC: SELECT LANGUAGE =================
select_language() {
    while true; do
        show_banner
        echo -e "${CYAN}$(get_string "select_lang")${NC}"
        echo -e "${WHITE}1)${NC} English"
        echo -e "${WHITE}2)${NC} Русский"
        echo -e "${WHITE}3)${NC} O'zbekcha"
        read -e -p "$(whoami)>_ " choice

        case $choice in
            1) LANG_CHOICE="EN"; break ;;
            2) LANG_CHOICE="RU"; break ;;
            3) LANG_CHOICE="UZ"; break ;;
            *) echo -e "${RED}$(get_string "invalid_choice")${NC}"; sleep 2 ;;
        esac
    done
}

# ================= FUNC: SUBDOMAIN ENUMERATION =================
subdomain_enumeration() {
    clear; show_banner
    echo -e "${CYAN}$(get_string "subdomain_enum")${NC}\n"

    read -e -p "$(whoami)>_ $(get_string "enter_target") " target_domain
    [[ -z "$target_domain" ]] && echo -e "${RED}$(get_string invalid_choice)${NC}" && sleep 2 && return

    wordlist_path="./tools/sublist.txt"
    [[ ! -f "$wordlist_path" ]] && echo -e "${RED}sublist.txt not found!${NC}" && sleep 2 && return

    result_dir="WebPentest/SubdomainResult"
    mkdir -p "$result_dir"

    base_file="$result_dir/${target_domain}.txt"
    results_file=$base_file; i=1
    while [[ -f "$results_file" ]]; do
        results_file="${base_file%.txt}_$i.txt"; ((i++))
    done

    echo -e "${GREEN}$(get_string subdomain_results)${NC}\n"

    while IFS= read -r sub; do
        full_domain="${sub}.${target_domain}"
        ip=$(dig +short "$full_domain" | head -n 1)
        if [[ -n "$ip" ]]; then
            status=$(curl -o /dev/null -s -L --max-time 5 "http://$full_domain" -w "%{http_code}")
            if [[ "$status" == "200" || "$status" == "301" || "$status" == "302" ]]; then
                echo -e "${GREEN}[OK]${NC} $full_domain -> $ip (Status: $status) ✅"
                echo "$full_domain -> $ip (Status: $status) [ACTIVE]" >> "$results_file"
            else
                echo -e "${YELLOW}[DNS ONLY]${NC} $full_domain -> $ip (Status: $status) ❌"
                echo "$full_domain -> $ip (Status: $status) [DNS ONLY]" >> "$results_file"
            fi
        fi
    done < "$wordlist_path"

    echo -e "\n${BLUE}Results saved to: $results_file${NC}\n"
    echo -e "${GREEN}$(get_string scan_complete)${NC}"
    read -e -p "$(whoami)>_ Press Enter to continue... " dummy
}

# ================= FUNC: PORT SCANNING =================
port_scanning() {
    clear; show_banner
    echo -e "${CYAN}$(get_string "port_scan")${NC}\n"
    read -e -p "$(whoami)>_ Enter target IP/domain: " target
    [[ -z "$target" ]] && echo -e "${RED}Invalid target!${NC}" && sleep 2 && return

    result_dir="WebPentest/PortScanResult"
    mkdir -p "$result_dir"

    base_file="$result_dir/${target}.txt"
    results_file=$base_file; i=1
    while [[ -f "$results_file" ]]; do
        results_file="${base_file%.txt}_$i.txt"; ((i++))
    done

    echo -e "${GREEN}Scanning ports on $target...${NC}"
    nmap -F "$target" | tee "$results_file"

    echo -e "\n${BLUE}Results saved to: $results_file${NC}"
    read -e -p "$(whoami)>_ Press Enter to continue... " dummy
}

# ================= FUNC: VULNERABILITY SCAN =================
vuln_scan() {
    clear; show_banner
    echo -e "${CYAN}$(get_string "vuln_scan")${NC}\n"

    # Tool selection
    echo -e "${WHITE}1)${NC} Nikto"
    echo -e "${WHITE}2)${NC} Nmap (Vuln scripts)"
    echo -e "${WHITE}3)${NC} WhatWeb"
    echo -e "${WHITE}4)${NC} WPScan"
    read -e -p "$(whoami)>_ Select tool: " tool_choice

    read -e -p "$(whoami)>_ Enter target domain (example.com): " target
    [[ -z "$target" ]] && echo -e "${RED}Invalid target!${NC}" && sleep 2 && return

    result_dir="WebPentest/VulnerabilityScanResult"
    mkdir -p "$result_dir"
    timestamp=$(date +%Y%m%d_%H%M%S)
    results_file="$result_dir/${target}_$timestamp.txt"

    case $tool_choice in
        1)
            echo -e "${GREEN}Running Nikto on $target...${NC}"
            nikto -h "$target" | tee "$results_file"
            ;;
        2)
            echo -e "${GREEN}Running Nmap vulnerability scripts on $target...${NC}"
            nmap --script vuln "$target" | tee "$results_file"
            ;;
        3)
            echo -e "${GREEN}Running WhatWeb on $target...${NC}"
            whatweb "$target" | tee "$results_file"
            ;;
        4)
            echo -e "${GREEN}Running WPScan on $target...${NC}"
            wpscan --url "$target" | tee "$results_file"
            ;;
        *)
            echo -e "${RED}Invalid choice!${NC}"
            return
            ;;
    esac

    echo -e "\n${BLUE}Results saved to: $results_file${NC}"
    read -e -p "$(whoami)>_ Press Enter to continue... " dummy
}

# ================= FUNC: WEB PENTEST MENU =================
web_pentest_menu() {
    while true; do
        clear; show_banner
        echo -e "${CYAN}$(get_string "web_pentest")${NC}\n"
        echo -e "${WHITE}1)${NC} $(get_string "subdomain_enum")"
        echo -e "${WHITE}2)${NC} $(get_string "port_scan")"
        echo -e "${WHITE}3)${NC} $(get_string "vuln_scan")"
        echo -e "${WHITE}4)${NC} Back"
        read -e -p "$(whoami)>_ Enter choice [1-4]: " choice

        case $choice in
            1) subdomain_enumeration ;;
            2) port_scanning ;;
            3) vuln_scan ;;
            4) break ;;
            *) echo -e "${RED}$(get_string invalid_choice)${NC}"; sleep 2 ;;
        esac
    done
}

# ================= FUNC: MAIN MENU =================
main_menu() {
    while true; do
        clear; show_banner
        echo -e "${CYAN}$(get_string "main_menu")${NC}\n"
        echo -e "${WHITE}1)${NC} $(get_string "web_pentest")"
        echo -e "${WHITE}2)${NC} $(get_string "exit")"
        read -e -p "$(whoami)>_ Enter choice [1-2]: " choice

        case $choice in
            1) web_pentest_menu ;;
            2) echo -e "${GREEN}Exiting...${NC}"; exit 0 ;;
            *) echo -e "${RED}$(get_string invalid_choice)${NC}"; sleep 2 ;;
        esac
    done
}

# ================= FUNC: CHECK PERMISSIONS =================
check_permissions() {
    if [[ $EUID -eq 0 ]]; then
        echo -e "${GREEN}Running with root privileges${NC}"
    else
        echo -e "${YELLOW}Running without root privileges${NC}"
    fi
    sleep 1
}

# ================= MAIN EXECUTION =================
main() {
    check_permissions
    select_language
    main_menu
}

main
