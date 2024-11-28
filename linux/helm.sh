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

TOTAL_STEPS=6

log 1 $TOTAL_STEPS "🔑 Adding Helm GPG key"
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
if [ $? -eq 0 ]; then
  log 1 $TOTAL_STEPS "✅ Helm GPG key added successfully"
else
  log 1 $TOTAL_STEPS "❌ Failed to add Helm GPG key"
  exit 1
fi

log 2 $TOTAL_STEPS "📦 Installing apt-transport-https"
sudo apt-get install apt-transport-https --yes
if [ $? -eq 0 ]; then
  log 2 $TOTAL_STEPS "✅ apt-transport-https installed successfully"
else
  log 2 $TOTAL_STEPS "❌ Failed to install apt-transport-https"
  exit 1
fi

log 3 $TOTAL_STEPS "🌐 Adding Helm repository to APT sources"
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
if [ $? -eq 0 ]; then
  log 3 $TOTAL_STEPS "✅ Helm repository added successfully"
else
  log 3 $TOTAL_STEPS "❌ Failed to add Helm repository"
  exit 1
fi

log 4 $TOTAL_STEPS "🔄 Updating APT package index"
sudo apt-get update
if [ $? -eq 0 ]; then
  log 4 $TOTAL_STEPS "✅ APT package index updated successfully"
else
  log 4 $TOTAL_STEPS "❌ Failed to update APT package index"
  exit 1
fi

log 5 $TOTAL_STEPS "🚀 Installing Helm"
sudo apt-get install helm --yes
if [ $? -eq 0 ]; then
  log 5 $TOTAL_STEPS "✅ Helm installed successfully"
else
  log 5 $TOTAL_STEPS "❌ Failed to install Helm"
  exit 1
fi

log 6 $TOTAL_STEPS "🔍 Checking Helm version"
helm version --short
if [ $? -eq 0 ]; then
else
  log 6 $TOTAL_STEPS "❌ Failed to check Helm version"
  exit 1
fi

log $TOTAL_STEPS $TOTAL_STEPS "🎉 Helm setup completed successfully!"