# Workstation setup automation

Automated, idempotent [Ansible](https://www.ansible.com/) provisioning for my personal workstation. Targets **Fedora Sway Edition** on Linux and **macOS** on Apple hardware from a single playbook.

Run the command below to quickly setup my personal workstation:

```bash

curl -sL https://robmeijerink.nl/workstation-setup | bash

```

The bootstrap script installs Ansible (via `dnf` on Fedora, Homebrew on macOS), clones this repository, and runs `local.yml`.

## What it does

Tasks are ordered and tagged so they can be run selectively (e.g. `ansible-playbook local.yml --tags cli`):

- **Base system** — Fedora (`dnf`, `dnf-automatic` security updates, SSH hardening, firewalld) or macOS (Homebrew, defaults).
- **Runtimes** — Node.js via `fnm`, Rust via `rustup`, and Go/PHP/Python/kubectl via `asdf`.
- **Security** — Bitwarden desktop + CLI, SSH agent integration, GPG agent.
- **Terminal & shell** — Alacritty, Zsh + Zap, tmux + TPM, Nerd Fonts.
- **Dev tooling** — Docker, database clients, a curated set of CLI tools, and Neovim with LSP/Mason.
- **Desktop** — browsers and office suite. On Fedora the Sway compositor, bars and daemons ship with the Sway spin, so they are not managed here.
- **Backup** — Timeshift in Btrfs snapshot mode (Fedora).
- **Dotfiles** — cloned and stowed from my [dotfiles](https://github.com/robmeijerink/dotfiles) repository.

> [!NOTE]
> Timeshift's Btrfs mode expects the `@` / `@home` subvolume layout. Fedora's installer names its subvolumes `root` and `home` by default, so verify (or adjust) your subvolume layout before relying on Btrfs snapshots.

> [!WARNING]
> **Warning / Disclaimer**
> This repository contains the automated setup for my personal workstation. It is highly opinionated and strictly tailored to my own workflow.
>
> You are free to use, fork, or learn from this code, but it is provided **"as is" without any warranty**. Running these scripts will modify your system configurations, install packages, and overwrite existing dotfiles.
>
> **Do not blindly execute this on your host machine.** Running `workstation-setup.sh` will alter system settings and overwrite configurations. Please read the source code before executing it, or test it in a Virtual Machine if you are just experimenting.
