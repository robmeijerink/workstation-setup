#!/usr/bin/env bash
# ==============================================================================
# Rob Meijerink - Workstation Bootstrap Script
# ==============================================================================
set -e

REPO_URL="https://github.com/robmeijerink/workstation-setup.git"
TMP_DIR="/tmp/my-ansible-worksetup"

# --- 1. Bootstrap Ansible & Dependencies ---
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Ubuntu / Debian logic (O(1) execution check)
    if ! command -v ansible &> /dev/null; then
        echo "Installing Ansible via APT..."
        sudo apt-get update
        sudo apt-get install -y software-properties-common curl git build-essential procps file
        sudo apt-add-repository --yes --update ppa:ansible/ansible
        sudo apt-get install -y ansible
    fi

elif [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS logic
    if ! command -v brew &> /dev/null; then
        echo "Installing Homebrew..."
        # Note: Do not run xcode-select manually. The brew script handles it synchronously.
        NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        eval "$(/usr/local/bin/brew shellenv 2>/dev/null || /opt/homebrew/bin/brew shellenv 2>/dev/null)"
    fi

    if ! command -v ansible &> /dev/null; then
        echo "Installing Ansible via Homebrew..."
        brew install git curl ansible
    fi
fi

# --- 2. Install Required Ansible Collections ---
echo "Ensuring required Ansible Galaxy collections are present..."
ansible-galaxy collection install community.general

# --- 3. Repository Preparation ---
echo "Cloning setup repository..."
rm -rf "$TMP_DIR"
git clone "$REPO_URL" "$TMP_DIR"

# --- 4. Execute Playbook ---
echo "Executing Ansible playbook..."
cd "$TMP_DIR"
ansible-playbook local.yml --ask-become-pass

# --- 5. Cleanup ---
echo "Cleaning up temporary files..."
cd ~
rm -rf "$TMP_DIR"

echo "Workstation setup has finished securely!"