#!/bin/bash

RESET="\033[0m"      
BOLD="\033[1m"       
BLUE="\033[34m"      
GREEN="\033[32m"      
RED="\033[31m"

log() {
  local step=$1
  local total_steps=$2
  local message=$3
  echo "${BOLD}${BLUE}($step/$total_steps)${RESET} ${BOLD}${GREEN}[$(date +"%Y-%m-%d %H:%M:%S")]${RESET} $message"
}

TOTAL_STEPS=5

log 1 $TOTAL_STEPS "📝 Selecting Java version for installation"
echo "Available Java versions for Amazon Corretto:"
echo "1) Java 8"
echo "2) Java 11"
echo "3) Java 17"
echo "4) Java 21"
read -p "Enter the number corresponding to the version you want to install: " version_choice

case $version_choice in
  1) JAVA_VERSION="java-1.8.0-amazon-corretto";;
  2) JAVA_VERSION="java-11-amazon-corretto";;
  3) JAVA_VERSION="java-17-amazon-corretto";;
  4) JAVA_VERSION="java-21-amazon-corretto";;
  *)
    log 1 $TOTAL_STEPS "❌ Invalid selection. Exiting." $RED
    exit 1
    ;;
esac
log 1 $TOTAL_STEPS "✅ Selected Java version: $JAVA_VERSION"

log 2 $TOTAL_STEPS "📦 Updating package index"
sudo apt-get update
if [ $? -ne 0 ]; then
  log 2 $TOTAL_STEPS "❌ Failed to update package index. Please check your internet connection." $RED
  exit 1
fi

log 3 $TOTAL_STEPS "🚀 Installing $JAVA_VERSION"
sudo apt-get install -y $JAVA_VERSION
if [ $? -ne 0 ]; then
  log 3 $TOTAL_STEPS "❌ Failed to install $JAVA_VERSION. Please check your repository settings." $RED
  exit 1
fi
log 3 $TOTAL_STEPS "✅ Successfully installed $JAVA_VERSION"

log 4 $TOTAL_STEPS "🔍 Verifying Java installation"
java -version
if [ $? -ne 0 ]; then
  log 4 $TOTAL_STEPS "❌ Java installation verification failed. Please troubleshoot." $RED
  exit 1
fi
log 4 $TOTAL_STEPS "✅ Java installation verified successfully"

log 5 $TOTAL_STEPS "⚙️ Setting default Java version"
sudo update-alternatives --config java
log 5 $TOTAL_STEPS "✅ Default Java version set successfully"

log $TOTAL_STEPS $TOTAL_STEPS "🎉 Java setup completed successfully!"