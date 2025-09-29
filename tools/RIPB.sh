#!/usr/bin/env bash

set -euo pipefail

CONTROL_HOST="127.0.0.1"
CONTROL_PORT=9051
COOKIE_PATHS=("/var/run/tor/control.authcookie" "/run/tor/control.authcookie" "/var/lib/tor/control_auth_cookie")
INTERVAL=6   # sekund 
TIMEOUT_CURL=8

require_root() {
  if [ "$EUID" -ne 0 ]; then
    echo "Iltimos scriptni root sifatida ishga tushiring: sudo $0"
    exit 1
  fi
}

build_auth_cmd() {
  if [ -n "${TOR_CONTROL_PASS-}" ]; then
    printf 'AUTHENTICATE "%s"\n' "$TOR_CONTROL_PASS"
    return
  fi
  for p in "${COOKIE_PATHS[@]}"; do
    if [ -r "$p" ]; then
      cookie_hex=$(xxd -p "$p" 2>/dev/null | tr -d '\n')
      printf 'AUTHENTICATE %s\n' "$cookie_hex"
      return
    fi
  done
  printf 'AUTHENTICATE ""\n'
}

tor_newnym() {
  local auth_cmd="$1"
  printf '%s\nSIGNAL NEWNYM\nQUIT\n' "$auth_cmd" | nc "$CONTROL_HOST" "$CONTROL_PORT" 2>/dev/null || true
}

get_tor_ip() {
  if command -v torsocks >/dev/null 2>&1; then
    torsocks curl -s --max-time "$TIMEOUT_CURL" ifconfig.me 2>/dev/null || echo "unknown"
  else
    curl -s --max-time "$TIMEOUT_CURL" ifconfig.me 2>/dev/null || echo "unknown"
  fi
}

silent_restart_tor() {
  if command -v systemctl >/dev/null 2>&1; then
    systemctl restart tor.service 2>/dev/null || systemctl restart tor 2>/dev/null || true
  else
    if command -v service >/dev/null 2>&1; then
      service tor restart 2>/dev/null || true
    fi
  fi
  sleep 1
}

require_root

silent_restart_tor

AUTH_CMD=$(build_auth_cmd)

initial_ip=$(get_tor_ip)
echo "Sening IP'ing: ${initial_ip}"

trap 'echo; echo "To'\''xtatildi."; exit 0' SIGINT SIGTERM

prev_ip="$initial_ip"

while true; do
  tor_newnym "$AUTH_CMD"
  sleep 5   # yangi circuit uchun kichik kutish
  new_ip=$(get_tor_ip)
  if [ -n "$new_ip" ] && [ "$new_ip" != "unknown" ] && [ "$new_ip" != "$prev_ip" ]; then
    echo "Sening IP'ing: ${new_ip}"
    prev_ip="$new_ip"
  fi
  sleep "$INTERVAL"
done
