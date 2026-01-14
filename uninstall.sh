#!/usr/bin/env bash

# 1llicit Uninstaller
# Heavy Box Edition (Fixed Colors & Length)

# Colors & Styles
B="\033[1m"
DIM="\033[2m"
GREEN="\033[1;32m"
RED="\033[1;31m"
YELLOW="\033[1;33m"
CYAN="\033[1;36m"
WHITE="\033[1;97m"
RESET="\033[0m"

# Header: Border is default/reset, Title is Bold White
echo -e "\n╔═══════════════ ${WHITE}${B}UNINSTALLER${RESET} ══════════════ ◈"
echo "╬"

# 1. Verification
echo -e "╬ ${RED}${B}[!] WARNING:${RESET} This will remove 1llicit configuration."
echo -e "╬     Your original ${RED}${B}.zshrc${RESET} will be restored."
echo "╬"
echo -ne "╬ ${YELLOW}${B}[?]${RESET} Are you sure? (y/N) "
read -n 1 -r REPLY
[[ -n "$REPLY" ]] && echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "╬ ${RED}${B}[-]${RESET} Aborted."
    echo -e "╚══════════════════════════════════════════ ◈"
    exit 1
fi

echo "╬"

# 2. Find Backup
BACKUP_DIR="$HOME/storage/shared/1llicit/backup"
if [ -d "$BACKUP_DIR" ]; then
    LATEST_BACKUP=$(ls -td "$BACKUP_DIR"/*/ 2>/dev/null | head -1)
    
    if [ -n "$LATEST_BACKUP" ] && [ -f "${LATEST_BACKUP}.zshrc" ]; then
        echo -e "╬ ${CYAN}[*]${RESET} Found backup: ${B}$(basename $LATEST_BACKUP)${RESET}"
        sleep 0.5
        cp -f "${LATEST_BACKUP}.zshrc" "$HOME/.zshrc"
        echo -e "╬ ${GREEN}${B}[+]${RESET} Restored shell configuration."
    else
        echo -e "╬ ${RED}${B}[!]${RESET} No .zshrc backup found."
        echo -e "╬     Hint: Check ${B}${BACKUP_DIR/$HOME/\~}${RESET} manually."
    fi
else
    echo -e "╬ ${RED}${B}[!]${RESET} No backup directory found."
    echo "╬     Skipping restore."
fi

# 3. Cleanup Core
if [ -d "$HOME/.1llicit" ]; then
    rm -rf "$HOME/.1llicit"
    echo -e "╬ ${GREEN}${B}[+]${RESET} Removed core files."
fi

# 4. Optional Cleanup (Storage)
echo "╬"
echo -ne "╬ ${YELLOW}${B}[?]${RESET} Remove backup folder? (y/N) "
read -n 1 -r REPLY
[[ -n "$REPLY" ]] && echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    rm -rf "$HOME/storage/shared/1llicit"
    echo -e "╬ ${GREEN}${B}[+]${RESET} Backups removed."
else
    echo -e "╬ ${CYAN}[-]${RESET} Backups retained."
fi

# 5. Shell Reset
echo "╬"
echo -ne "╬ ${YELLOW}${B}[?]${RESET} Switch default shell back to Bash? (y/N) "
read -n 1 -r REPLY
[[ -n "$REPLY" ]] && echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    chsh -s bash
    echo -e "╬ ${GREEN}${B}[+]${RESET} Shell switched to Bash."
fi

echo "╬"
echo -e "╚═══════════ ${GREEN}${B}UNINSTALL COMPLETE${RESET} ═══════════ ◈"
