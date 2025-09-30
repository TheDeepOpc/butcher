#!/usr/bin/env bash
set -euo pipefail

DEFAULT_WORDLIST="/usr/share/wordlists/seclists/Discovery/Web-Content/directory-list-2.3-medium.txt"
TMP_OUT="/tmp/ffuf_butch_out_$$.json"

# Use readline so arrow keys don't spit ^[[D
read -e -r -p "Domen (masalan example.com/{BUTCH} : " DOMAIN_INPUT
read -e -r -p "Status code — bo'sh qoldirsangiz hammasini ko'rsatadi: " STATUS_FILTER
read -e -r -p "Wordlist (enter = default: ${DEFAULT_WORDLIST}): " WORDLIST
read -e -r -p "file type kerak bolsa html,css,php: " EXT_INPUT

WORDLIST="${WORDLIST:-$DEFAULT_WORDLIST}"

# Check wordlist exists
if [ ! -f "$WORDLIST" ]; then
  echo "Xato: Wordlist topilmadi: $WORDLIST" >&2
  exit 2
fi

# Ensure protocol present (default http if not)
if [[ "$DOMAIN_INPUT" =~ ^https?:// ]]; then
  TARGET="$DOMAIN_INPUT"
else
  TARGET="http://$DOMAIN_INPUT"
fi

# Count occurrences of {BUTCH}
COUNT=$(grep -o "{BUTCH}" <<< "$TARGET" | wc -l | tr -d ' ')

if [ "$COUNT" -eq 0 ]; then
  echo "Ogohlantirish: Kiritingan domen matnida {BUTCH} topilmadi. Hech qanday butch qilinmaydi." >&2
  echo "URL misoli: example.com/{BUTCH} yoki example.com/{BUTCH}/{BUTCH}" >&2
  exit 3
fi

# Replace each {BUTCH} with FUZZ, FUZZ2, FUZZ3...
FFUF_URL="$TARGET"
W_ARGS=()
for i in $(seq 1 "$COUNT"); do
  if [ "$i" -eq 1 ]; then
    KEYWORD="FUZZ"
  else
    KEYWORD="FUZZ${i}"
  fi
  FFUF_URL="${FFUF_URL/\{BUTCH\}/$KEYWORD}"
  W_ARGS+=("-w" "$WORDLIST")
done

# Build ffuf command (output to JSON file)
CMD=(ffuf -u "$FFUF_URL" -o "$TMP_OUT" -of json)
for ((j=0; j<${#W_ARGS[@]}; j+=2)); do
  CMD+=("${W_ARGS[j]}" "${W_ARGS[j+1]}")
done

# If status filter provided, use -mc (match codes)
if [ -n "${STATUS_FILTER// }" ]; then
  CMD+=("-mc" "$STATUS_FILTER")
fi

echo
echo "Yaratilayotgan ffuf buyruq:"
printf " %q" "${CMD[@]}"
echo
echo "ffuf ishga tushmoqda... (natijalar $TMP_OUT ga yoziladi)"
echo

# Run ffuf
"${CMD[@]}"

# Prepare extension regex if provided
if [ -n "${EXT_INPUT// }" ]; then
  # normalize: remove spaces, split by comma, build (ext1|ext2)
  IFS=',' read -r -a EXTS <<< "$(echo "$EXT_INPUT" | tr -d ' ' )"
  # Build pattern like: \.(html|php|js)(?:$|\?)
  PATTERN="\\.(?:$(IFS='|'; echo "${EXTS[*]}"))(?:$|\\?)"
else
  PATTERN=""
fi

# Function: pretty print using jq if present, else fallback with grep/perl
print_filtered() {
  if command -v jq >/dev/null 2>&1; then
    if [ -z "$PATTERN" ]; then
      jq -r '.results[] | "\(.url) [Status: \(.status), Size: \(.length)]"' "$TMP_OUT"
    else
      jq -r --arg re "$PATTERN" '.results[] | select(.url | test($re; "i")) | "\(.url) [Status: \(.status), Size: \(.length)]"' "$TMP_OUT"
    fi
  else
    if [ -z "$PATTERN" ]; then
      grep -Po '"url":\s*"\K[^"]+' "$TMP_OUT" | nl -ba -w1 -s'. ' -v0 \
        | while read -r idx url; do
            block=$(perl -0777 -ne 'while(/(\{[^}]*"url"\s*:\s*"' . quotemeta("$url") . '"[^}]*\})/g){print "$1\n---\n"}' "$TMP_OUT" 2>/dev/null || true)
            st=$(echo "$block" | grep -Po '"status":\s*\K[0-9]+' | head -n1 || echo "?")
            ln=$(echo "$block" | grep -Po '"length":\s*\K[0-9]+' | head -n1 || echo "?")
            echo "$url [Status: $st, Size: $ln]"
          done
    else
      grep -Po '"url":\s*"\K[^"]+' "$TMP_OUT" | grep -Pi "$PATTERN" | while read -r url; do
        block=$(perl -0777 -ne 'while(/(\{[^}]*"url"\s*:\s*"' . quotemeta("$url") . '"[^}]*\})/g){print "$1\n---\n"}' "$TMP_OUT" 2>/dev/null || true)
        st=$(echo "$block" | grep -Po '"status":\s*\K[0-9]+' | head -n1 || echo "?")
        ln=$(echo "$block" | grep -Po '"length":\s*\K[0-9]+' | head -n1 || echo "?")
        echo "$url [Status: $st, Size: $ln]"
      done
    fi
  fi
}

echo
echo "---- Filtrlash natijalari ----"
if [ -s "$TMP_OUT" ]; then
  print_filtered
else
  echo "Hech qanday natija topilmadi yoki ffuf JSON fayli bo'sh: $TMP_OUT" >&2
fi

echo
echo "Tugadi. JSON natija fayli: $TMP_OUT"
