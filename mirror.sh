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

log 1 $TOTAL_STEPS "🗂️  Creating backup of the sources list"
SOURCE_LIST="/etc/apt/sources.list"
cp $SOURCE_LIST $SOURCE_LIST.bak

log 2 $TOTAL_STEPS "🌐 Updating mirror site to ftp.kaist.ac.kr"
sed -i 's|http://[a-zA-Z0-9.-]*/ubuntu|http://ftp.kaist.ac.kr/ubuntu|g' $SOURCE_LIST

log 3 $TOTAL_STEPS "🔄 Verifying updated sources list"
echo "미러 사이트가 ftp.kaist.ac.kr로 변경되었습니다. 다음은 변경된 내용입니다:"
grep "ftp.kaist.ac.kr" $SOURCE_LIST

log 4 $TOTAL_STEPS "⚙️  Running apt-get update to refresh package index"
sudo apt update -y

log 5 $TOTAL_STEPS "✅ Mirror update process completed successfully"