#!/usr/bin/env bash
set -e

REPO_URL="https://github.com/robmeijerink/workstation-setup.git"
TMP_DIR="/tmp/my-ansible-worksetup"

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Ubuntu / Debian
    # 1. Install prerequisites for adding repositories
    sudo apt-get update && sudo apt-get install -y software-properties-common curl git build-essential procps file

    # 2. Add official Ansible PPA for modern playbook compatibility
    sudo apt-add-repository --yes --update ppa:ansible/ansible
    sudo apt-get install -y ansible

    # 3. Bootstrap Homebrew
    if ! command -v brew &> /dev/null; then
        echo "Installing Homebrew for Linux"
        NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi

elif [[ "$OSTYPE" == "darwin"* ]]; then
    # MacOS
    if ! command -v brew &> /dev/null; then
        echo "Installing Homebrew"
        xcode-select --install
        NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        eval "$(/usr/local/bin/brew shellenv 2>/dev/null || /opt/homebrew/bin/brew shellenv 2>/dev/null)"
    fi
    brew install git curl ansible
fi

# Clean existing and clone
rm -rf "$TMP_DIR"
git clone "$REPO_URL" "$TMP_DIR"

# Execute Ansible playbook
cd "$TMP_DIR"
ansible-playbook local.yml --ask-become-pass

# Cleanup
cd ~
rm -rf "$TMP_DIR"

echo "Workstation setup has finished securely!"