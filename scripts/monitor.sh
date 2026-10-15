#!/usr/bin/env bash
set -uo pipefail

usage() {
  echo "Использование: $0 <имя-сервиса>" >&2
  exit 2
}

[[ $# -eq 1 ]] || usage
service="$1"

if ! command -v systemctl >/dev/null 2>&1; then
  echo "ОШИБКА: systemctl не найден. Скрипт предназначен для Linux с systemd." >&2
  exit 1
fi

if ! systemctl cat "$service" >/dev/null 2>&1; then
  echo "ОШИБКА: сервис '$service' не найден." >&2
  exit 1
fi

status="$(systemctl is-active "$service" 2>/dev/null || true)"
echo "Сервис: $service"
echo "Статус: $status"

if [[ "$status" != "active" ]]; then
  echo "Последние 10 строк журнала:"
  if command -v journalctl >/dev/null 2>&1; then
    journalctl -u "$service" -n 10 --no-pager 2>&1 || true
  else
    echo "journalctl не найден."
  fi
fi

syslog="/var/log/syslog"
if [[ -r "$syslog" ]]; then
  hour_now="$(date '+%b %e %H')"
  hour_prev="$(date -d '1 hour ago' '+%b %e %H' 2>/dev/null || true)"
  error_count="$(grep -i 'error' "$syslog" 2>/dev/null | awk -v h1="$hour_now" -v h2="$hour_prev" 'substr($0,1,12)==h1 || substr($0,1,12)==h2 {n++} END {print n+0}')"
else
  error_count="0 (файл /var/log/syslog недоступен)"
fi
echo "Ошибок в /var/log/syslog за последний час: $error_count"

[[ "$status" == "active" ]]

