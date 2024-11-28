#!/bin/bash

RESET="\033[0m"      
BOLD="\033[1m"       
BLUE="\033[34m"      
GREEN="\033[32m" 

log() {
  local step=$1
  local total_steps=$2
  local message=$3
  echo "${BOLD}${BLUE}($step/$total_steps)${RESET} ${BOLD}${GREEN}[$(date +"%Y-%m-%d %H:%M:%S")]${RESET} $message"
}

TOTAL_STEPS=5

free -h

log 1 $TOTAL_STEPS "📝 Enter Swap Memory Size"
read -p "Enter swap memory size in GB (e.g., 2 for 2GB): " SWAP_SIZE_GB
SWAP_SIZE_MB=$((SWAP_SIZE_GB * 1024))  # GB를 MB로 변환

log 2 $TOTAL_STEPS "⚙️ Generating Swap Memory File"
cd / &&
sudo dd if=/dev/zero of=/swapfile bs=1M count=$SWAP_SIZE_MB

log 3 $TOTAL_STEPS "🔒 Configuring Swap File"
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo swapon -s

log 4 $TOTAL_STEPS "📂 Updating Configuration"
if ! grep -q '/swapfile swap swap defaults 0 0' /etc/fstab; then
  echo '/swapfile swap swap defaults 0 0' | sudo tee -a /etc/fstab
  log 4 $TOTAL_STEPS "Configuration added to /etc/fstab"
else
  log 4 $TOTAL_STEPS "Configuration already exists in /etc/fstab"
fi

log 5 $TOTAL_STEPS "✅ Swap Memory Setup Complete"
free -h