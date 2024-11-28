#!/bin/bash

RESET="\033[0m"
BOLD="\033[1m"
BLUE="\033[34m"
GREEN="\033[32m"
RED="\033[31m"

log() {
  local message=$1
  echo -n "${BOLD}${BLUE}[$(date +"%Y-%m-%d %H:%M:%S")]${RESET} ${BOLD}${GREEN}$message${RESET}"
}

echo "📊 Gathering system usage information..."

# CPU Usage
log "🔄 CPU Usage: "
top -bn1 | grep "Cpu(s)" | awk '{printf "%.1f%%\n", 100 - $8}'

# Memory Usage
log "💾 Memory Usage: "
free -h | awk '/^Mem:/ {printf "%s/%s (%.1f%%)\n", $3, $2, $3/$2 * 100}'

# Disk Usage
log "📂 Disk Usage: "
df -h --total | grep "total" | awk '{printf "%s/%s (%s)\n", $3, $2, $5}'

echo "✅ System usage information collected successfully!"