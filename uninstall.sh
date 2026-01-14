#!/usr/bin/env bash
#
# 1llicit Uninstaller
# True Gold Edition
#

# ─────────────────────────────
# UI STYLES
# ─────────────────────────────
BOLD="\033[1m"
UNDER="\033[4m"
DIM="\033[2m"

GREEN="\033[1;32m"
RED="\033[1;31m"
YELLOW="\033[1;33m"
CYAN="\033[1;36m"
WHITE="\033[1;97m"

RESET="\033[0m"

# ─────────────────────────────
# HEADER
# ─────────────────────────────
echo
echo -e "╔═════════ ${WHITE}${BOLD}${UNDER}UNINSTALL 1LLICIT${RESET} ═════════ ◈"
echo "╬"
echo -e "╬ ${RED}${BOLD}[!] WARNING${RESET}"
echo -e "╬     ${DIM}Removes all 1llicit configuration files.${RESET}"
echo -e "╬     ${DIM}Restores shell config from backup, if available.${RESET}"
echo "╬"

# ─────────────────────────────
# PRIMARY CONFIRMATION
# ─────────────────────────────
echo -ne "╬ ${CYAN}${BOLD}[?]${RESET} Continue with uninstall? (y/N) "
read -r REPLY
REPLY=${REPLY:0:1}
echo "╬"

if [[ ! "$REPLY" =~ ^[Yy]$ ]]; then
    echo -e "╬ ${RED}${BOLD}[!] Aborted${RESET}"
    echo "╚════════════════════════════════════ ◈"
    exit 1
fi

echo "╬"

# ─────────────────────────────
# RESTORE BACKUP (.zshrc)
# ─────────────────────────────
BACKUP_DIR="$HOME/storage/shared/1llicit/backup"

if [ -d "$BACKUP_DIR" ]; then
    LATEST_BACKUP=$(ls -td "$BACKUP_DIR"/*/ 2>/dev/null | head -1)

    if [ -n "$LATEST_BACKUP" ] && [ -f "${LATEST_BACKUP}.zshrc" ]; then
        echo -e "╬ ${GREEN}${BOLD}[+] Found:${RESET} Backup $(basename "$LATEST_BACKUP")"
        cp -f "${LATEST_BACKUP}.zshrc" "$HOME/.zshrc"
        echo -e "╬ ${GREEN}${BOLD}[+] Restored:${RESET} Shell configuration"
    else
        echo -e "╬ ${RED}${BOLD}[!] Missing:${RESET} Valid .zshrc backup"
        echo -e "╬     ${DIM}Manual review recommended:${RESET}"
        echo -e "╬     ${DIM}$BACKUP_DIR${RESET}"
    fi
else
    echo -e "╬ ${RED}${BOLD}[!] Missing:${RESET} Backup directory"
    echo -e "╬     ${DIM}Skipping restore step.${RESET}"
fi

# ─────────────────────────────
# REMOVE CORE FILES
# ─────────────────────────────
if [ -d "$HOME/.1llicit" ]; then
    rm -rf "$HOME/.1llicit"
    echo -e "╬ ${GREEN}${BOLD}[+] Removed:${RESET} Core files"
else
    echo -e "╬ ${RED}${BOLD}[-] Skipped:${RESET} No core files found"
fi

# ─────────────────────────────
# OPTIONAL: REMOVE BACKUPS
# ─────────────────────────────
echo "╬"
echo -ne "╬ ${CYAN}${BOLD}[?]${RESET} Remove backup folder from shared storage? (y/N) "
read -r REPLY
REPLY=${REPLY:0:1}
echo "╬"

if [[ "$REPLY" =~ ^[Yy]$ ]]; then
    rm -rf "$HOME/storage/shared/1llicit"
    echo -e "╬ ${GREEN}${BOLD}[+] Removed:${RESET} Backup folder"
else
    echo -e "╬ ${RED}${BOLD}[-] Skipped:${RESET} Backup folder retained"
fi

# ─────────────────────────────
# OPTIONAL: RESET SHELL
# ─────────────────────────────
echo "╬"
echo -ne "╬ ${CYAN}${BOLD}[?]${RESET} Reset default shell to Bash? (y/N) "
read -r REPLY
REPLY=${REPLY:0:1}
echo "╬"

if [[ "$REPLY" =~ ^[Yy]$ ]]; then
    chsh -s bash
    echo -e "╬ ${GREEN}${BOLD}[+] Applied:${RESET} Default shell set to Bash"
else
    echo -e "╬ ${RED}${BOLD}[-] Skipped:${RESET} Shell unchanged"
fi

# ─────────────────────────────
# COMPLETION
# ─────────────────────────────
echo "╬"
echo -e "╬ ${WHITE}${BOLD}${UNDER}Please restart Termux for all changes to take effect.${RESET}"
echo "╬"
echo "╚════════════════════════════════════ ◈"