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

log 1 $TOTAL_STEPS "⚙️ Updating apt and installing required packages"
sudo apt update -y
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common -y

log 2 $TOTAL_STEPS "🔑 Adding Docker GPG key and repository"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository --yes \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

log 3 $TOTAL_STEPS "🐳 Installing Docker Engine"
sudo apt-get install docker-ce docker-ce-cli containerd.io -y

log 4 $TOTAL_STEPS "🛠️ Verifying Docker installation and setting up user permissions"
docker -v
sudo usermod -aG docker $USER
sudo service docker restart

log 5 $TOTAL_STEPS "🔁 Please re-login to apply Docker group changes"