#!/usr/bin/env bash

# 1llicit one-line Uninstaller

# Colors & Styles
BOLD="\033[1m"
DIM="\033[2m"
UNDER="\033[4m"
CYAN="\033[1;36m"
GREEN="\033[1;32m"
RED="\033[1;31m"
WHITE="\033[1;97m"
YELLOW="\033[1;33m"
RESET="\033[0m"


# header
echo -e "\n╔═══════════════ ${WHITE}${BOLD}${UNDER}UNINSTALLER${RESET} ══════════════ ◈"
echo "╬"

# verification
echo -e "╬ ${RED}${BOLD}[!] WARNING:${RESET} This will remove 1llicit configuration."
echo -e "╬     Your original ${RED}${BOLD}.zshrc${RESET} will be restored."
echo "╬"
echo -ne "╬ ${YELLOW}${BOLD}[?]${RESET} Are you sure? (y/N) "
read -n 1 -r REPLY
[[ -n "$REPLY" ]] && echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "╬ ${RED}${BOLD}[-]${RESET} Aborted."
    echo -e "╚══════════════════════════════════════════ ◈"
    exit 1
fi

echo "╬"


# find backup
BACKUP_DIR="$HOME/storage/shared/1llicit/backup"
if [ -d "$BACKUP_DIR" ]; then
    LATEST_BACKUP=$(ls -td "$BACKUP_DIR"/*/ 2>/dev/null | head -1)
    
    if [ -n "$LATEST_BACKUP" ] && [ -f "${LATEST_BACKUP}.zshrc" ]; then
        echo -e "╬ ${CYAN}[*]${RESET} Found backup: ${BOLD}$(basename $LATEST_BACKUP)${RESET}"
        sleep 0.5
        cp -f "${LATEST_BACKUP}.zshrc" "$HOME/.zshrc"
        echo -e "╬ ${GREEN}${BOLD}[+]${RESET} Restored shell configuration."
    else
        echo -e "╬ ${RED}${BOLD}[!]${RESET} No .zshrc backup found."
        echo -e "╬     Hint: Check ${BOLD}${BACKUP_DIR/$HOME/\~}${RESET} manually."
    fi
else
    echo -e "╬ ${RED}${BOLD}[!]${RESET} No backup directory found."
    echo "╬     Skipping restore."
fi

# cleanup core
if [ -d "$HOME/.1llicit" ]; then
    rm -rf "$HOME/.1llicit"
    echo -e "╬ ${GREEN}${BOLD}[+]${RESET} Removed core files."
fi


# optional cleanup (storage)
echo "╬"
echo -ne "╬ ${YELLOW}${BOLD}[?]${RESET} Remove backup folder? (y/N) "
read -n 1 -r REPLY
[[ -n "$REPLY" ]] && echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    rm -rf "$HOME/storage/shared/1llicit"
    echo -e "╬ ${GREEN}${BOLD}[+]${RESET} Backups removed."
else
    echo -e "╬ ${CYAN}[-]${RESET} Backups retained."
fi


# shell reset
echo "╬"
echo -ne "╬ ${YELLOW}${BOLD}[?]${RESET} Switch default shell back to Bash? (y/N) "
read -n 1 -r REPLY
[[ -n "$REPLY" ]] && echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    chsh -s bash
    echo -e "╬ ${GREEN}${BOLD}[+]${RESET} Shell switched to Bash."
else
    echo -e "╬ ${RED}${BOLD}[-]${RESET} Aborted."
fi

echo "╬"
echo -e "╚═══════════ ${GREEN}${BOLD}UNINSTALL COMPLETE${RESET} ═══════════ ◈"


# LbsLightX