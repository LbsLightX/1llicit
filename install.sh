#!/usr/bin/env bash

# 1llicit One-line Installer

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


# turn off cursor.
setterm -cursor off

clear
echo -e "\033[1;34m"
echo "   ⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⣿⣦⠀⠀⠀⠀⠀⠀⠀⠀ "
echo "  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣿⣿⠂⠀⠀⠀⠀⠀⠀⠀⠀ "
echo "  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⣀⠀⠀⠀⠀⠀⠀⠀⠀ "
echo "  ⠀⠀⠀⠀⠀⠀⠀⢠⣾⣿⣿⣿⣿⣿⣿⣦⠀ "
echo "  ⠀⠀⠀⠀⠀⠀⣴⣿⢿⣷⠒⠲⣾⣾⣿⣿ "
echo "  ⠀⠀⠀⠀⣴⣿⠟⠁⠀⢿⣿⠁⣿⣿⣿⠻⣿⣄⠀⠀⠀⠀ "
echo "  ⠀⠀⣠⡾⠟⠁⠀⠀⠀⢸⣿⣸⣿⣿⣿⣆⠙⢿⣷⡀⠀⠀ "
echo "  ⣰⡿⠋⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⠀⠀⠉⠻⣿⡀ "
echo "  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⣿⣿⣿⣿⣿⣿⣆⠂⠀ "
echo "  ⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⣿⣿⡿⣿⣿⣿⣿⡄⠀⠀⠀⠀ "
echo "  ⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⠿⠟⠀⠀⠻⣿⣿⡇⠀⠀⠀⠀ "
echo "  ⠀⠀⠀⠀⠀⠀⢀⣾⡿⠃⠀⠀⠀⠀⠀⠘⢿⣿⡀⠀⠀⠀ "
echo "  ⠀⠀⠀⠀⠀⣰⣿⡟⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣷⡀⠀⠀ "
echo "  ⠀⠀⠀⠀⢠⣿⠟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠻⣿⣧⠀⠀ "
echo "  ⠀⠀⠀⢀⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⣆⠀ "
echo "  ⠀⠀⠠⢾⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣷⡤"
echo -e "\033[0m"
echo -e "${WHITE}${BOLD}!-1llicit-!-1llicit-!-1llicit-!${RESET}"
echo ""
echo -e "╔═══════════════ ${WHITE}${BOLD}${UNDER}INSTALLER${RESET} ════════════════ ✧"
echo "╬"


# mirrors
printf "╬ ${CYAN}${BOLD}[*]${RESET} Syncing mirrors...\r"
(echo 'n' | pkg update 2>/dev/null) | while read -r line; do :; done
printf "\r\033[K" 
echo -e "╬ ${GREEN}${BOLD}[+]${RESET} Mirrors synced."


# update
printf "╬ ${CYAN}${BOLD}[*]${RESET} Updating system...\r"
pkg upgrade -y -o Dpkg::Options::='--force-confnew' >/dev/null 2>&1
printf "\r\033[K"
echo -e "╬ ${GREEN}${BOLD}[+]${RESET} System updated."


# packages
printf "╬ ${CYAN}${BOLD}[*]${RESET} Installing packages...\r"
pkg install -y curl git zsh man jq perl fzf fastfetch termux-api >/dev/null 2>&1
printf "\r\033[K"
echo -e "╬ ${GREEN}${BOLD}[+]${RESET} Core packages installed."


# bsudo
printf "╬ ${CYAN}${BOLD}[*]${RESET} Installing bSUDO...\r"
curl -fsSL 'https://github.com/agnostic-apollo/sudo/releases/latest/download/sudo' -o $PREFIX/bin/bsudo >/dev/null 2>&1
chmod 700 "$PREFIX/bin/bsudo"
printf "\r\033[K"
echo -e "╬ ${GREEN}${BOLD}[+]${RESET} bSUDO installed."


# storage
if [ ! -d ~/storage ]; then
    printf "╬ ${CYAN}${BOLD}[*]${RESET} Requesting storage...\r"
    termux-setup-storage
    sleep 2
    printf "\r\033[K"
    echo -e "╬ ${GREEN}${BOLD}[+]${RESET} Storage access granted."
fi


# backup
BACKUP_PATH="$HOME/storage/shared/1llicit/backup/$(date +%Y_%m_%d_%H_%M)"
mkdir -p "$BACKUP_PATH"
printf "╬ ${CYAN}${BOLD}[*]${RESET} Backing up configs...\r"
for i in "$HOME/.zshrc" "$HOME/.termux/font.ttf" "$HOME/.termux/colors.properties" "$HOME/.termux/termux.properties"
do
    if [ -f $i ]; then
        mv -f "$i" "$BACKUP_PATH/$(basename $i)"
    fi
done
printf "\r\033[K"
echo -e "╬ ${GREEN}${BOLD}[+]${RESET} Configuration backed up."


# clean slate
rm -f "$HOME/.zshrc"


# shell
if [[ "$SHELL" != *"zsh"* ]]; then
   chsh -s zsh
   echo -e "╬ ${GREEN}${BOLD}[+]${RESET} Default shell set to Zsh."
fi


# core download
mkdir -p "$HOME/.1llicit"
printf "╬ ${CYAN}${BOLD}[*]${RESET} Downloading Core...\r"
if curl -fsSL https://raw.githubusercontent.com/LbsLightX/1llicit/main/core.zsh > "$HOME/.1llicit/core.zsh"; then
    printf "\r\033[K"
    echo -e "╬ ${GREEN}${BOLD}[+]${RESET} Core logic installed."
else
    printf "\r\033[K"
    echo -e "╬ ${RED}${BOLD}[!]${RESET} Failed to download Core."
    exit 1
fi


# generate config
cat <<'EOF' > $HOME/.zshrc
# Enable Powerlevel10k instant prompt.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# --- LOAD 1LLICIT CORE ---
if [[ -f "$HOME/.1llicit/core.zsh" ]]; then
    source "$HOME/.1llicit/core.zsh"
fi
EOF
echo -e "╬ ${GREEN}${BOLD}[+]${RESET} .zshrc generated."


# assets
REPO_URL="https://raw.githubusercontent.com/LbsLightX/1llicit/main/defaults"
      
if [ ! -f ~/.termux/font.ttf ]; then
    curl -fsSL -o ~/.termux/font.ttf "$REPO_URL/font.ttf" >/dev/null 2>&1
    echo -e "╬ ${GREEN}${BOLD}[+]${RESET} Default font installed."
fi

if [ ! -f ~/.termux/colors.properties ]; then
    curl -fsSL -o ~/.termux/colors.properties "$REPO_URL/colors.properties" >/dev/null 2>&1
    echo -e "╬ ${GREEN}${BOLD}[+]${RESET} Default theme set."
fi

if [ ! -f ~/.termux/termux.properties ]; then
    curl -fsSL -o ~/.termux/termux.properties "$REPO_URL/termux.properties" >/dev/null 2>&1
    echo -e "╬ ${GREEN}${BOLD}[+]${RESET} Custom keys configured."
fi


# reload
termux-reload-settings

# Pre-compile Zinit
printf "╬ ${CYAN}${BOLD}[*]${RESET} Optimizing ZSH environment (Wait, it may take 1-2 minutes.)\r"
zsh -ic "source $HOME/.zshrc; zinit compile --all" >/dev/null 2>&1
printf "\r\033[K"
echo -e "╬ ${GREEN}${BOLD}[+]${RESET} Environment optimized."

echo "╬"
echo -e "╚═══════════════ ${GREEN}${BOLD}COMPLETE${RESET} ════════════════ ✧"
echo ""
sleep 2

# restore cursor
setterm -cursor on

# unconditional reload
clear
exec zsh -l
exit


# LbsLightX