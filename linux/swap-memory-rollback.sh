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

TOTAL_STEPS=4

log 1 $TOTAL_STEPS "🔄 Deactivating Swap File"
if sudo swapoff /swapfile; then
  log 1 $TOTAL_STEPS "✔️ Swap file deactivated successfully."
else
  log 1 $TOTAL_STEPS "⚠️ Swap file is not active or already deactivated."
fi

log 2 $TOTAL_STEPS "🗑️ Removing Swap File"
if sudo rm -f /swapfile; then
  log 2 $TOTAL_STEPS "✔️ Swap file removed successfully."
else
  log 2 $TOTAL_STEPS "⚠️ No swap file found to remove."
fi

log 3 $TOTAL_STEPS "📝 Updating /etc/fstab"
if grep -q '/swapfile swap swap defaults 0 0' /etc/fstab; then
  sudo sed -i '/\/swapfile swap swap defaults 0 0/d' /etc/fstab
  log 3 $TOTAL_STEPS "✔️ Swap configuration removed from /etc/fstab."
else
  log 3 $TOTAL_STEPS "⚠️ No swap configuration found in /etc/fstab."
fi

log 4 $TOTAL_STEPS "✅ Rollback Complete"
free -h