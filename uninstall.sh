#!/usr/bin/env bash

# 1llicit One-line Uninstaller

# colors & styles
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
echo -e "╬ ${RED}${BOLD}[!] WARNING:${RESET} This will remove 1llicit config."
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
        
        # safety check 
        rm -f "$HOME/.zshrc"
        echo -e "╬ ${GREEN}${BOLD}[+]${RESET} Deleted .zshrc to prevent errors."
    fi
else
    echo -e "╬ ${RED}${BOLD}[!]${RESET} No backup directory found."
    rm -f "$HOME/.zshrc"
    echo -e "╬ ${GREEN}${BOLD}[+]${RESET} Deleted .zshrc to prevent errors."
fi

# deep clean (merged storage + plugins)
echo "╬"
echo -e "╬ ${RED}${BOLD}[!]${RESET} Perform Deep Clean"
echo -ne "╬ ${YELLOW}${BOLD}[?]${RESET} Delete (Plugins/Cache/Backups) (y/N) "
read -n 1 -r REPLY
[[ -n "$REPLY" ]] && echo ""

# always remove core
rm -rf "$HOME/.1llicit"

if [[ $REPLY =~ ^[Yy]$ ]]; then
    rm -rf "$HOME/.local/share/zinit"
    rm -rf "$HOME/.cache/p10k"*
    rm -f "$PREFIX/bin/bsudo"
    rm -rf "$HOME/storage/shared/1llicit"
    echo -e "╬ ${GREEN}${BOLD}[+]${RESET} Deep cleanup complete."
else
    echo -e "╬ ${GREEN}${BOLD}[+]${RESET} Removed core files only."
fi

# auto-reset shell
chsh -s bash
echo -e "╬ ${GREEN}${BOLD}[+]${RESET} Shell reset to Bash."

echo "╬"
echo -e "╚═══════════ ${GREEN}${BOLD}UNINSTALL COMPLETE${RESET} ═══════════ ◈"
echo
echo -e " - - - ${RED}${BOLD}${UNDER}PLEASE RESTART TERMUX TO FINISH.${RESET} - - -\n"


# LbsLightX