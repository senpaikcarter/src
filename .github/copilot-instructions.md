# Copilot Instructions

This is a personal workstation automation repository. It provisions and configures Linux development environments across multiple distros using Ansible, shell scripts, and dotfiles.

## Running Playbooks

```bash
# Run a specific playbook against the local machine
ansible-playbook playbooks/<name>.yml

# Run against the inventory workstation (192.168.10.13)
ansible-playbook -i inventory playbooks/<name>.yml

# Run a specific task by tag (if tagged)
ansible-playbook playbooks/<name>.yml --tags <tag>
```

Shell scripts in `scripts/` are run directly:
```bash
bash scripts/<name>.sh
```

There is no test suite, build system, or linter.

## Architecture

The repo is organized by **package manager / platform**:

| Playbook | Purpose |
|---|---|
| `playbooks/pacman.yml` | Arch Linux base packages |
| `playbooks/brew.yml` | Homebrew tools (LSPs, linters, k8s tools) |
| `playbooks/dnf.yml` | Fedora/RHEL packages |
| `apt-playbooks/apt.yml` | Debian/Ubuntu packages |
| `playbooks/arch-wsl2.yml` | Master playbook that imports pacman + brew + dotfiles + neovim |
| `playbooks/dotfiles.yml` | Oh-My-Zsh, TPM, zshrc, tmux.conf |
| `playbooks/neovim.yml` | Neovim config, Lazy.nvim plugins |
| `playbooks/vim.yml` | Vim config, Vundle plugins |

`scripts/` contains one-off or distro-specific installers (Docker, Homebrew, AWS CLI, Terraform, etc.) that don't fit cleanly into Ansible modules.

Dotfiles live in `dotfiles/` and are deployed by Ansible `copy` tasks — they are not symlinked.

## Conventions

### Ansible Playbooks
- All playbooks target `hosts: localhost` with `connection: local`
- Use `become: false` at the play level; escalate only in individual tasks when needed
- Derive paths via `ansible_facts['env']['HOME']` and store as `home_dir` / `repo_root` vars:
  ```yaml
  vars:
    home_dir: "{{ ansible_facts['env']['HOME'] }}"
    repo_root: "{{ ansible_facts['env']['HOME'] }}/src"
  ```
- Use `register` + `changed_when: false` + `failed_when: false` when probing tool availability (e.g., `brew --prefix`)
- Gate Homebrew tasks with `when: brew_prefix.rc == 0`
- File naming: lowercase, hyphenated, `.yml` (exception: `flatpack.yaml`)

### Shell Scripts
- Shebang: `#!/usr/bin/env bash`
- Always include `set -euo pipefail` at the top
- Detect distro via `/etc/arch-release`, `command -v dnf`, `command -v apt-get` in that order
- File naming: lowercase, hyphenated, `.sh`

### Dotfiles
- **Neovim**: Lua config at `dotfiles/init.lua` + `dotfiles/lua/config/`; uses Lazy.nvim
- **Vim**: `dotfiles/vimrc`; uses Vundle
- **Zsh**: `dotfiles/zshrc`; uses Oh-My-Zsh with `half-life` theme
- **Tmux**: `dotfiles/tmux.conf`; uses TPM with dracula theme

### Inventory
- Single host group `[workstation]` pointing to `192.168.10.13` with `ansible_ssh_private_key_file=/home/kenny/.ssh/id_ed25519`
