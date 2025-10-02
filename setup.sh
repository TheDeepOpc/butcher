#!/bin/bash
export AUTHORIZED_BY_SETUP="yes"

STORED_HASH="254d2a5da661ebef81377a11705dca335ceb72322ca0767af332af38535c4b8e"

read -s -p "Welcome Mr/Miss.Butcher type your Password >_" input
echo

input_hash=$(echo -n "$input" | sha256sum | awk '{print $1}')

if [[ "$input_hash" != "$STORED_HASH" ]]; then
    echo "Xato parol! Kirish taqiqlangan."
    exit 1
fi

sudo bash "$(dirname "$0")/settings/script.sh"
echo "[*] Config yuklandi Butcher ishga tushayabdi Miss/Mr.Butcher"
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m' 
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

declare -A STRINGS_EN=(
    [welcome]="Welcome to Penetration Testing Toolkit"
       [endinstalled]="All is complite Butcher is runnning!!!!"
    [select_lang]="Select Language:"
    [english]="English"
     [web_copier]="WebCopier"
    [enter_domain]="Enter target domain (example.com):"
    [webcopier_start]="Starting WebCopier for"
    [webcopier_saved]="Website saved to"
    [wget_missing]="Error: wget not found. Please install wget."
    [invalid_domain]="Invalid domain format!"
    [russian]="Russian"
    [uzbek]="Uzbek"
    [main_menu]="Main Menu - Penetration Testing Tools"
    [web_pentest]="Web Hacking"
    [physical_pentest]="Physical Hacking"
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
           [endinstalled]="Finished running Butcher"
    [web_copier]="WebCopier"
    [enter_domain]="Введите целевой домен (example.com):"
    [webcopier_start]="Запуск WebCopier для"
    [webcopier_saved]="Сайт сохранён в"
    [wget_missing]="Ошибка: wget не найден. Установите wget."
    [invalid_domain]="Неверный формат домена!"

    [english]="Английский"
    [russian]="Русский"
    [uzbek]="Узбекский"
    [main_menu]="Главное меню - Инструменты для пентестинга"
    [web_pentest]="Веб Hacking"
    [subdomain_enum]="Анализ субдоменов"
            [physical_pentest]="Physical Hacking"
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
           [endinstalled]="kerakli config yuklandi butcher ishga tushirilmoqda"
    [web_copier]="WebCopier"
    [enter_domain]="Maqsadli domenni kiriting (example.com):"
    [webcopier_start]="WebCopier ishga tushyapti:"
    [webcopier_saved]="Sayt saqlandi:"
    [wget_missing]="Xato: wget topilmadi. Iltimos wget ni o'rnating."
    [invalid_domain]="Noto'g'ri domen formati!"

    [english]="Inglizcha"
    [russian]="Ruscha"
    [uzbek]="O'zbekcha"
    [main_menu]="Asosiy menyu - Penetration Testing vositalari"
    [web_pentest]="Web Hacking"
    [subdomain_enum]="Subdomain aniqlash"
    [port_scan]="Port skanerlash"
    [vuln_scan]="Zaifliklarni aniqlash"
    [physical_pentest]="Physical Hacking"

    [exit]="Chiqish"
    [invalid_choice]="Noto'g'ri tanlov. Qaytadan urining."
    [enter_target]="Maqsadli domenni kiriting (example.com):"
    [subdomain_results]="Subdomain aniqlash natijalari"
    [scan_complete]="Skanerlash tugadi!"
    [target_ip]="Maqsadning IP manzili:"
)

LANG_CHOICE="EN"

get_string() {
    local key=$1
    case $LANG_CHOICE in
        EN) echo "${STRINGS_EN[$key]}" ;;
        RU) echo "${STRINGS_RU[$key]}" ;;
        UZ) echo "${STRINGS_UZ[$key]}" ;;
        *) echo "${STRINGS_EN[$key]}" ;;
    esac
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RIPB_FLAG_FILE="$SCRIPT_DIR/.ripb_used"
RIPB_USED=0

if [[ -f "$RIPB_FLAG_FILE" ]]; then
    RIPB_USED=1
fi

run_cmd() {
    if [[ "${RIPB_USED:-0}" -eq 1 && "${NMAP_FORCE_NO_TORSOCKS:-0}" -eq 0 ]]; then
        if command -v torsocks >/dev/null 2>&1; then
            torsocks "$@"
            return $?
        else
            echo -e "${YELLOW}torsocks not installed; running command without torsocks.${NC}"
            "$@"
            return $?
        fi
    else
        # Either RIPB not used or we've disabled torsocks for nmap due to incompatibility
        "$@"
        return $?
    fi
}

show_banner() {
    clear
    echo -e "${RED}"

cat << "EOF"
                                                                             
                                                                             
                           =@@@=                                      
                          .@@##@*=.-:                               
                          @@@*%@@@@%@                               
                         @@@@@@@@@@@%                               
                         @@@@@@@@@@@%                               
                        -@@@@@@@@@@@@                               
                       =#@@@@@@@@@@@@+                              
                    : %+@@@@@@@@@@@@@#                              
                 @@@@@@@@@@@@@@@@@@@@@@                             
              @@@@@@@@@@@@@@@@@@@@@@@@@@@%**                        
             @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                       
             @@@@-=-*@@@@@@@@@@@@@@@@@@@@@%@@@                      
             @@* =#-    :#%@@@@@@@*=  .#+%%@@:=                     
            %@@@@@@#*.       =#-      :%@@@@@@*                     
             @%-.=@@@%#=     =-=    -#@@@@@@%                       
             @*: %@@@@@@@@%@%* **%%@@@@@@@@@@                       
            =@*:*@@@@@@@@*-   .   :-#@@@@@@@@                       
           #@@##@@@@@@@@@#=  .-  :+*%@@@@@@@@@=                     
           : @@@@@  #@@@@@@%#++=++*%@@@@@@@@%=                      
            +@@@@@ @@@@@@@@@@@@@@@@@@@@@ @@@@@#=                    
          :@@@@@@@   @@@@@@@@@@@@@@@@@@@@@@@@@@@+           :@      
         :@@@@@@@@@ #@@@@@@@@@@@@@@@@@@@  *@@@@%@@+ %+ -@@@@@@      
         @@@@@@@@@  *@@@@@@@@@@@@@@@@@@@   @@@@@ :-@@@@@ @@+=#@     
          @@@@@@@@   @@@@@@@@@@@@@@@@@@%@@@@@@@@@@@@@@@   @@@@@     
          @@@@@@@@  %@@@@@@@@@@@@@@@@@@@@     =@@@@@@     @@@@@@    
           %%%#+%@. @@@@@@@@@@@@@@@@@@@@@         @     @@@@@@@@@   
           ##%##@@@@@@@@@@@@@@@@@@@@@@@@@*     @@@@@@@@@@%@%*@@@@@  
          :+%#@@@@@@@@@@@@@@@@@@@@@@@@@@@@       @@@@@@@@@@@@@@@@   
   @##@@@@@@@@@@@  .@@@@@@@@@@%@@@@@@@@@@@                          
 @@@@@       @  @  @@@@@@@@@@@@@@@%@@@@@@@#*                        
               @*  @@@@@@@@@@@@%%@@@@@@@@@@-@@                      
                @@@@@@@@@@@@@@%%@@@@@@@@@@@ @@@                     
                  @@@@@@@@@@%@@%@@@@@@@@@@@                         
                 :@@@@@@@@@@%%%%@@@@@@@@@@@                         
                 @@@@@@@@@@@@%%%@@@@@@@@@@@                         
                 @@@@@@@@@@@@@%#@@@@@@@@@@@                         
EOF

    echo -e "${NC}${RED}"
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



select_language() {
    while true; do
        show_banner
        echo -e "${CYAN}$(get_string "select_lang")${NC}"
        echo -e "${WHITE}1)${NC} English"
        echo -e "${WHITE}2)${NC} Русский"
        echo -e "${WHITE}3)${NC} O'zbekcha"
        read -e -p "$(whoami)-Butcher>_ " choice

        case $choice in
            1) LANG_CHOICE="EN"; break ;;
            2) LANG_CHOICE="RU"; break ;;
            3) LANG_CHOICE="UZ"; break ;;
            *) echo -e "${RED}$(get_string "invalid_choice")${NC}"; sleep 2 ;;
        esac
    done
}

subdomain_enumeration() {
    clear; show_banner
    echo -e "${CYAN}$(get_string "subdomain_enum")${NC}\n"

    read -e -p "$(whoami)-Butcher>_ $(get_string "enter_target") " target_domain
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
    read -e -p "$(whoami)-Butcher>_ Press Enter to continue... " dummy
}

nmap_wrapper() {
    local args=("$@")
    local nmap_bin
    nmap_bin="$(which nmap 2>/dev/null || echo /usr/bin/nmap)"

    if [[ "${RIPB_USED:-0}" -eq 1 ]]; then
        args=( "-sT" "-Pn" "${args[@]}" )
    fi

    if [[ "${RIPB_USED:-0}" -eq 0 ]]; then
        "${nmap_bin}" "${args[@]}"
        return $?
    fi

 
    if command -v getcap >/dev/null 2>&1; then
        if getcap "$nmap_bin" 2>/dev/null | grep -q "cap_net"; then
            echo -e "${YELLOW}Notice: nmap has network capabilities (cap_net_raw). torsocks may be incompatible.${NC}"
            # prefer to run nmap without torsocks but with safe -sT -Pn
            NMAP_FORCE_NO_TORSOCKS=1
            "${nmap_bin}" "${args[@]}"
            return $?
        fi
    fi

    if command -v torsocks >/dev/null 2>&1; then
        # First do a quick test: run 'torsocks --version' or a harmless call to ensure LD_PRELOAD works
        # Some torsocks versions support `torsocks --version`; if not, fallback to trying a small curl call
        if torsocks true >/dev/null 2>&1; then
            # try running nmap; capture stderr to detect "Operation not permitted"
            # Use a subshell to capture stderr output
            local stderr tmpfile
            tmpfile="$(mktemp)"
            torsocks "${nmap_bin}" "${args[@]}" 2> "$tmpfile"
            local status=$?
            stderr="$(cat "$tmpfile")"
            rm -f "$tmpfile"

            if [[ $status -eq 0 ]]; then
                return 0
            else
                if echo "$stderr" | grep -qi -e "Operation not permitted" -e "not permitted" -e "missing architecture"; then
                    echo -e "${YELLOW}torsocks -> nmap failed: ${stderr%%$'\n'*}${NC}"
                    echo -e "${YELLOW}Falling back: running nmap without torsocks in TCP-connect mode (-sT -Pn).${NC}"
                    NMAP_FORCE_NO_TORSOCKS=1
                    "${nmap_bin}" "${args[@]}"
                    return $?
                else
                    echo -e "${RED}nmap via torsocks failed:${NC}"
                    echo "$stderr"
                    return $status
                fi
            fi
        else
            echo -e "${YELLOW}torsocks seems unable to preload for this process. Running nmap without torsocks.${NC}"
            NMAP_FORCE_NO_TORSOCKS=1
            "${nmap_bin}" "${args[@]}"
            return $?
        fi
    else
        echo -e "${YELLOW}torsocks not installed; running nmap without torsocks.${NC}"
        "${nmap_bin}" "${args[@]}"
        return $?
    fi
}



port_scanning() {
    clear; show_banner
    echo -e "${CYAN}$(get_string "port_scan")${NC}\n"
    read -e -p "$(whoami)-Butcher>_ Enter target IP/domain: " target
    [[ -z "$target" ]] && echo -e "${RED}Invalid target!${NC}" && sleep 2 && return

    result_dir="WebPentest/PortScanResult"
    mkdir -p "$result_dir"

    base_file="$result_dir/${target}.txt"
    results_file=$base_file; i=1
    while [[ -f "$results_file" ]]; do
        results_file="${base_file%.txt}_$i.txt"; ((i++))
    done

    echo -e "${GREEN}Scanning ports on $target...${NC}"
    nmap_wrapper -F "$target" | tee "$results_file"

    echo -e "\n${BLUE}Results saved to: $results_file${NC}"
    read -e -p "$(whoami)-Butcher>_ Press Enter to continue... " dummy
}

vuln_scan() {
    clear; show_banner
    echo -e "${CYAN}$(get_string "vuln_scan")${NC}\n"

    echo -e "${WHITE}1)${NC} Nikto"
    echo -e "${WHITE}2)${NC} Nmap (Vuln scripts)"
    echo -e "${WHITE}3)${NC} WhatWeb"
    echo -e "${WHITE}4)${NC} WPScan"
    read -e -p "$(whoami)-Butcher>_ Select tool: " tool_choice

    read -e -p "$(whoami)-Butcher>_ Enter target domain (example.com): " target
    [[ -z "$target" ]] && echo -e "${RED}Invalid target!${NC}" && sleep 2 && return

    result_dir="WebPentest/VulnerabilityScanResult"
    mkdir -p "$result_dir"
    timestamp=$(date +%Y%m%d_%H%M%S)
    results_file="$result_dir/${target}_$timestamp.txt"

    case $tool_choice in
        1)
            echo -e "${GREEN}Running Nikto on $target...${NC}"
            run_cmd nikto -h "$target" | tee "$results_file"
            ;;
        2)
            echo -e "${GREEN}Running Nmap vulnerability scripts on $target...${NC}"
            run_cmd nmap --script vuln "$target" | tee "$results_file"
            ;;
        3)
            echo -e "${GREEN}Running WhatWeb on $target...${NC}"
            run_cmd whatweb "$target" | tee "$results_file"
            ;;
        4)
            echo -e "${GREEN}Running WPScan on $target...${NC}"
            run_cmd wpscan --url "$target" | tee "$results_file"
            ;;
        *)
            echo -e "${RED}Invalid choice!${NC}"
            return
            ;;
    esac

    echo -e "\n${BLUE}Results saved to: $results_file${NC}"
    read -e -p "$(whoami)-Butcher>_ Press Enter to continue... " dummy
}

web_pentest_menu() {
    while true; do
        clear; show_banner
        echo -e "${CYAN}$(get_string "web_pentest")${NC}\n"
        echo -e "${WHITE}1)${NC} $(get_string "subdomain_enum")"
        echo -e "${WHITE}2)${NC} $(get_string "port_scan")"
        echo -e "${WHITE}3)${NC} $(get_string "vuln_scan")"
        echo -e "${WHITE}4)${NC} Back"
        read -e -p "$(whoami)-Butcher>_ Enter choice [1-4]: " choice

        case $choice in
            1) subdomain_enumeration ;;
            2) port_scanning ;;
            3) vuln_scan ;;
            4) break ;;
            *) echo -e "${RED}$(get_string invalid_choice)${NC}"; sleep 2 ;;
        esac
    done
}
physical_pentest() {
   clear; show_banner
    echo -e "${CYAN}$(get_string "physical_pentest")${NC}\n"

    # Faqat root orqali ishga tushishini tekshirish
    if [[ $EUID -ne 0 ]]; then
        echo -e "${RED}Error: physical.sh can only be run as root!${NC}"
        read -e -p "$(whoami)-Butcher>_ Press Enter to continue... " dummy
        return
    fi

    # Faqat setup.sh orqali ishga tushirishni tekshirish
    if [[ "$AUTHORIZED_BY_SETUP" != "yes" ]]; then
        echo -e "${RED}Error: physical.sh can only be run via setup.sh!${NC}"
        read -e -p "$(whoami)-Butcher>_ Press Enter to continue... " dummy
        return
    fi

    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    phys_script="${script_dir}/physical.sh"

    if [[ -x "$phys_script" ]]; then
        bash "$phys_script" "$AUTHORIZED_BY_SETUP" "$LANG_CHOICE"
    else
        echo -e "${RED}Physical Pentest script not found or not executable:${NC} $phys_script"
    fi

    read -e -p "$(whoami)-Butcher>_ Press Enter to continue... " dummy
}
web_copier() {
    clear; show_banner
    echo -e "${CYAN}$(get_string "web_copier")${NC}\n"

    # check wget exists
    if ! command -v wget >/dev/null 2>&1; then
        echo -e "${RED}$(get_string "wget_missing")${NC}"
        read -e -p "$(whoami)-Butcher>_ Press Enter to continue... " dummy
        return
    fi

    read -r -e -p "$(whoami)-Butcher>_ $(get_string "enter_domain") " target_domain
    target_domain="$(echo -n "$target_domain" | tr -d '[:space:]')"

    if [[ -z "$target_domain" ]]; then
        echo -e "${RED}$(get_string "invalid_domain")${NC}"
        sleep 1
        return
    fi

    is_valid_domain() {
        local d="$1"
        if [[ "$d" =~ ^([a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?\.)+[A-Za-z]{2,}$ ]]; then
            return 0
        fi
        return 1
    }

    if ! is_valid_domain "$target_domain"; then
        echo -e "${RED}$(get_string "invalid_domain")${NC}"
        sleep 1
        return
    fi

    safe_target=$(echo "$target_domain" | sed 's/[^A-Za-z0-9._-]/_/g')
    timestamp=$(date +%Y%m%d_%H%M%S)
    dest_dir="WebClones/${safe_target}_${timestamp}"

    # create directory with sudo if needed
    if [[ $EUID -ne 0 ]]; then
        sudo mkdir -p -- "$dest_dir"
    else
        mkdir -p -- "$dest_dir"
    fi

    echo -e "${GREEN}$(get_string "webcopier_start") $target_domain${NC}"
    echo -e "${BLUE}Downloading frontend and assets into:${NC} $dest_dir${NC}"

    try_https() {
        if [[ $EUID -ne 0 ]]; then
            sudo wget --mirror --convert-links --adjust-extension --page-requisites --no-parent \
                --wait=0.2 --random-wait --limit-rate=200k --retry-connrefused --tries=3 \
                --timeout=20 --restrict-file-names=windows -e robots=off "https://$target_domain" -P "$dest_dir"
        else
            wget --mirror --convert-links --adjust-extension --page-requisites --no-parent \
                --wait=0.2 --random-wait --limit-rate=200k --retry-connrefused --tries=3 \
                --timeout=20 --restrict-file-names=windows -e robots=off "https://$target_domain" -P "$dest_dir"
        fi
    }

    try_http() {
        if [[ $EUID -ne 0 ]]; then
            sudo wget --mirror --convert-links --adjust-extension --page-requisites --no-parent \
                --wait=0.2 --random-wait --limit-rate=200k --retry-connrefused --tries=3 \
                --timeout=20 --restrict-file-names=windows -e robots=off "http://$target_domain" -P "$dest_dir"
        else
            wget --mirror --convert-links --adjust-extension --page-requisites --no-parent \
                --wait=0.2 --random-wait --limit-rate=200k --retry-connrefused --tries=3 \
                --timeout=20 --restrict-file-names=windows -e robots=off "http://$target_domain" -P "$dest_dir"
        fi
    }

    if try_https; then
        echo -e "${GREEN}HTTPS download finished.${NC}"
    else
        echo -e "${YELLOW}HTTPS failed, trying HTTP...${NC}"
        if try_http; then
            echo -e "${GREEN}HTTP download finished.${NC}"
        else
            echo -e "${RED}Both HTTPS and HTTP downloads failed for $target_domain${NC}"
            read -e -p "$(whoami)-Butcher>_ Press Enter to continue... " dummy
            return
        fi
    fi

    echo -e "\n${BLUE}$(get_string "webcopier_saved") $dest_dir${NC}\n"
    read -e -p "$(whoami)-Butcher>_ Press Enter to continue... " dummy
}


main_menu() {
    while true; do
        clear; show_banner
        echo -e "${CYAN}$(get_string "main_menu")${NC}\n"
        echo -e "${WHITE}1)${NC} $(get_string "web_pentest")"
        echo -e "${WHITE}2)${NC} $(get_string "physical_pentest")"
        echo -e "${WHITE}3)${NC} WI-FI hacking"
        echo -e "${WHITE}4)${NC} MITM (BITM)"
        echo -e "${WHITE}5)${NC} $(get_string "web_copier")"
        echo -e "${WHITE}6)${NC} R.I.P.B"
        echo -e "${WHITE}7)${NC} Spidey Websint"
        echo -e "${WHITE}8)${NC} $(get_string "exit")"
        read -e -p "$(whoami)-Butcher>_ : " choice

        case $choice in
            1) web_pentest_menu ;;
            2) physical_pentest ;;
            3)
                sudo bash -c '(
                    cd "$(dirname "$0")/fluxtionButcher" || exit 1
                    ./fluxion.sh
                )'
                ;;
            4)
                echo -e "${GREEN}Starting MITM...${NC}"
                bash "$(dirname "$0")/tools/dns.sh"
                read -e -p "$(whoami)-Butcher>_ Press Enter to continue... " dummy
                ;;
            5) web_copier ;;
            6)
                RIPB_PATH="$(cd "$(dirname "$0")" && pwd)/tools/RIPB.sh"
                echo -e "${PURPLE}Starting R.I.P.B...${NC}"

                if [[ ! -f "$RIPB_PATH" ]]; then
                    echo -e "${RED}Error: $RIPB_PATH topilmadi.${NC}"
                    read -e -p "$(whoami)-Butcher>_ Press Enter to continue... " dummy
                    continue
                fi

                if [[ ! -x "$RIPB_PATH" ]]; then
                    chmod +x "$RIPB_PATH"
                fi

                inner_cmd="sudo bash '$RIPB_PATH'; echo; read -p \"Press Enter to close this window...\" -r"

                terminals=(gnome-terminal xfce4-terminal konsole xterm mate-terminal lxterminal x-terminal-emulator)
                terminal_launched=0

                for t in "${terminals[@]}"; do
                    if command -v "$t" >/dev/null 2>&1; then
                        case "$t" in
                            gnome-terminal|mate-terminal)
                                "$t" -- bash -c "$inner_cmd" &
                                ;;
                            xfce4-terminal)
                                "$t" --command="bash -c \"$inner_cmd\"" &
                                ;;
                            konsole)
                                konsole -e bash -c "$inner_cmd" &
                                ;;
                            xterm)
                                xterm -hold -e bash -c "$inner_cmd" &
                                ;;
                            lxterminal|x-terminal-emulator)
                                "$t" -e bash -c "$inner_cmd" &
                                ;;
                            *)
                                "$t" -e bash -c "$inner_cmd" &
                                ;;
                        esac
                        terminal_launched=1
                        break
                    fi
                done

                if [[ $terminal_launched -eq 1 ]]; then
                    echo -e "${GREEN}R.I.P.B started in a new terminal.${NC}"
                else
                    echo -e "${YELLOW}No graphical terminal detected — running R.I.P.B in the current terminal.${NC}"
                    sudo bash "$RIPB_PATH"
                fi

                sleep 1
                ;;
            7)
                BUTCH_PATH="$(cd "$(dirname "$0")" && pwd)/tools/BITF.sh"
                echo -e "${PURPLE}BUTF${NC}"

                if [[ ! -f "$BUTCH_PATH" ]]; then
                    echo -e "${RED}Error: $BUTCH_PATH topilmadi.${NC}"
                    read -e -p "$(whoami)-Butcher>_ Press Enter to continue... " dummy
                    continue
                fi

                if [[ ! -x "$BUTCH_PATH" ]]; then
                    chmod +x "$BUTCH_PATH"
                fi

                inner_cmd="sudo bash '$BUTCH_PATH'; echo; read -p \"Press Enter to close this window...\" -r"

                terminals=(gnome-terminal xfce4-terminal konsole xterm mate-terminal lxterminal x-terminal-emulator)
                terminal_launched=0

                for t in "${terminals[@]}"; do
                    if command -v "$t" >/dev/null 2>&1; then
                        case "$t" in
                            gnome-terminal|mate-terminal)
                                "$t" -- bash -c "$inner_cmd" &
                                ;;
                            xfce4-terminal)
                                "$t" --command="bash -c \"$inner_cmd\"" &
                                ;;
                            konsole)
                                konsole -e bash -c "$inner_cmd" &
                                ;;
                            xterm)
                                xterm -hold -e bash -c "$inner_cmd" &
                                ;;
                            lxterminal|x-terminal-emulator)
                                "$t" -e bash -c "$inner_cmd" &
                                ;;
                            *)
                                "$t" -e bash -c "$inner_cmd" &
                                ;;
                        esac
                        terminal_launched=1
                        break
                    fi
                done

                if [[ $terminal_launched -eq 1 ]]; then
                    echo -e "${GREEN}BUTCH started in a new terminal.${NC}"
                else
                    echo -e "${YELLOW}No graphical terminal detected — running BUTCH in the current terminal.${NC}"
                    sudo bash "$BUTCH_PATH"
                fi

                sleep 1
                ;;
            8)
                echo -e "${GREEN}Exiting...${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}$(get_string invalid_choice)${NC}"
                sleep 2
                ;;
        esac
    done
}






main() {
    
    select_language
    main_menu
}

main
