#!/bin/bash

log() {
  local step=$1
  local total_steps=$2
  local message=$3
  echo "($step/$total_steps) [$(date +"%Y-%m-%d %H:%M:%S")] $message"
}

# 전체 작업 수 설정
TOTAL_STEPS=4

log 1 $TOTAL_STEPS "📦 Install K8S Binary"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

log 2 $TOTAL_STEPS "✅ Check K8S Binary"
curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check

log 3 $TOTAL_STEPS "📦 Install K8S"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

log 4 $TOTAL_STEPS "✅ Check K8S"
kubectl version --client --output=yaml