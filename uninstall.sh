#!/usr/bin/env bash

# 1llicit One-line Uninstaller

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

# Header
echo -e "\n╔═══════════════ ${WHITE}${BOLD}${UNDER}UNINSTALLER${RESET} ══════════════ ◈"
echo "╬"

# Verification
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

# Find Backup
BACKUP_DIR="$HOME/storage/shared/1llicit/backup"
if [ -d "$BACKUP_DIR" ]; then
  # Find the newest directory inside backup folder
  LATEST_BACKUP=$(ls -td "$BACKUP_DIR"/*/ 2>/dev/null | head -1)

  # Check if a .zshrc exists inside that newest backup folder
  if [ -n "$LATEST_BACKUP" ] && [ -f "${LATEST_BACKUP}.zshrc" ]; then
    echo -e "╬ ${CYAN}[*]${RESET} Found backup: ${BOLD}$(basename "$LATEST_BACKUP")${RESET}"
    sleep 0.5
    cp -f "${LATEST_BACKUP}.zshrc" "$HOME/.zshrc"
    [ -f "${LATEST_BACKUP}/font.ttf" ] && cp -f "${LATEST_BACKUP}/font.ttf" "$HOME/.termux/font.ttf"
    [ -f "${LATEST_BACKUP}/colors.properties" ] && cp -f "${LATEST_BACKUP}/colors.properties" "$HOME/.termux/colors.properties"
    [ -f "${LATEST_BACKUP}/termux.properties" ] && cp -f "${LATEST_BACKUP}/termux.properties" "$HOME/.termux/termux.properties"

    # Apply Changes
    termux-reload-settings
    echo -e "╬ ${GREEN}${BOLD}[+]${RESET} Restored shell configuration."
  else
    echo -e "╬ ${RED}${BOLD}[!]${RESET} No .zshrc backup found."
    echo -e "╬     Hint: Check ${BOLD}${BACKUP_DIR/$HOME/\~}${RESET} manually."

    # Safety Check
    rm -f "$HOME/.zshrc"
    echo "# Default .zshrc (Restored by 1llicit)" >"$HOME/.zshrc"
    echo -e "╬ ${GREEN}${BOLD}[+]${RESET} Reset .zshrc to defaults."
  fi
else
  echo -e "╬ ${RED}${BOLD}[!]${RESET} No backup directory found."
  rm -f "$HOME/.zshrc"
  echo "# Default .zshrc (Restored by 1llicit)" >"$HOME/.zshrc"
  echo -e "╬ ${GREEN}${BOLD}[+]${RESET} Reset .zshrc to defaults."
fi

# Deep Clean (Merged Storage + Plugins)
echo "╬"
echo -e "╬ ${RED}${BOLD}[!]${RESET} Perform Deep Clean"
echo -ne "╬ ${YELLOW}${BOLD}[?]${RESET} Full Environment Reset? (Plugins/UI/Backups) (y/N) "
read -n 1 -r REPLY
[[ -n "$REPLY" ]] && echo ""

# Always Remove Core
rm -rf "$HOME/.1llicit"

if [[ $REPLY =~ ^[Yy]$ ]]; then
  # Remove Plugin Data
  rm -rf "$HOME/.local/share/zinit"
  rm -rf "$HOME/.cache/p10k"*

  # Remove Binaries
  rm -f "$PREFIX/bin/bsudo"
  rm -f "$PREFIX/bin/1llicit"

  # Remove Storage Data (Only if exists)
  if [ -d "$HOME/storage/shared/1llicit" ]; then
    rm -rf "$HOME/storage/shared/1llicit"
  fi

  # Remove Termux Styling Configs
  rm -f "$HOME/.termux/colors.properties"
  rm -f "$HOME/.termux/font.ttf"
  rm -f "$HOME/.termux/termux.properties"

  echo -e "╬ ${GREEN}${BOLD}[+]${RESET} Deep cleanup complete."
else
  echo -e "╬ ${GREEN}${BOLD}[+]${RESET} Removed core files only."
fi

# Auto-Reset Shell
chsh -s bash
echo -e "╬ ${GREEN}${BOLD}[+]${RESET} Shell reset to Bash."

echo "╬"
echo -e "╚═══════════ ${GREEN}${BOLD}UNINSTALL COMPLETE${RESET} ═══════════ ◈"
echo
echo -e " - - - ${RED}${BOLD}${UNDER}PLEASE RESTART TERMUX TO FINISH.${RESET} - - -\n"

# LbsLightX
