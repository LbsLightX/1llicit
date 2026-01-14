#!/usr/bin/env bash

# 1llicit Installer
# Pro-Minimalist Edition

# Colors & Styles
B="\033[1m"
DIM="\033[2m"
GREEN="\033[32m"
RED="\033[31m"
CYAN="\033[36m"
WHITE="\033[97m"
RESET="\033[0m"

# Utility: Print status line
# Usage: status "Message" "STATUS"
status() {
    local msg="$1"
    local stat="$2"
    local color="${GREEN}"
    [[ "$stat" == "FAIL" ]] && color="${RED}"
    [[ "$stat" == "SKIP" ]] && color="${CYAN}"
    
    # Reduced padding for tighter layout
    local width=35
    local pad=$((width - ${#msg}))
    # Ensure pad is not negative
    [[ $pad -lt 0 ]] && pad=1
    
    printf "║ • %s%*s [ ${color}${stat}${RESET} ]\n" "$msg" "$pad" ""
}

# Turn off cursor.
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
echo -e "${WHITE}${B}   !-1llicit-!-1llicit-!-1llicit-!${RESET}"
echo ""
echo -e "${WHITE}${B}╔══ SETUP SEQUENCE ═════════════════════════════════════${RESET}"
echo "║"

# 1. Mirrors
printf "║ • Syncing mirrors...\r"
(echo 'n' | pkg update 2>/dev/null) | while read -r line; do :; done
printf "\r\033[K" # Clear line
status "Syncing mirrors" "OK"

# 2. Update
printf "║ • Updating system...\r"
pkg upgrade -y -o Dpkg::Options::='--force-confnew' >/dev/null 2>&1
printf "\r\033[K"
status "Updating system" "OK"

# 3. Packages
printf "║ • Installing packages...\r"
pkg install -y curl git zsh man jq perl fzf fastfetch termux-api >/dev/null 2>&1
printf "\r\033[K"
status "Installing packages" "OK"

# 4. BSUDO
printf "║ • Installing bSUDO...\r"
curl -fsSL 'https://github.com/agnostic-apollo/sudo/releases/latest/download/sudo' -o $PREFIX/bin/bsudo >/dev/null 2>&1
chmod 700 "$PREFIX/bin/bsudo"
printf "\r\033[K"
status "Installing bSUDO" "OK"

# 5. Storage
if [ ! -d ~/storage ]; then
    printf "║ • Requesting storage...\r"
    termux-setup-storage
    sleep 2
    printf "\r\033[K"
    status "Storage access" "OK"
fi

# 6. Backup
BACKUP_PATH="$HOME/storage/shared/1llicit/backup/$(date +%Y_%m_%d_%H_%M)"
mkdir -p "$BACKUP_PATH"
printf "║ • Backing up configs...\r"
for i in "$HOME/.zshrc" "$HOME/.termux/font.ttf" "$HOME/.termux/colors.properties" "$HOME/.termux/termux.properties"
do
    if [ -f $i ]; then
        mv -f "$i" "$BACKUP_PATH/$(basename $i)"
    fi
done
printf "\r\033[K"
status "Backup configurations" "OK"

# Clean slate
rm -f "$HOME/.zshrc"

# 7. Shell
if [[ "$SHELL" != *"zsh"* ]]; then
   chsh -s zsh
   status "Default shell -> Zsh" "OK"
fi

# 8. Core Download
mkdir -p "$HOME/.1llicit"
printf "║ • Downloading Core...\r"
if curl -fsSL https://raw.githubusercontent.com/LbsLightX/1llicit/main/core.zsh > "$HOME/.1llicit/core.zsh"; then
    printf "\r\033[K"
    status "Downloading Core" "OK"
else
    printf "\r\033[K"
    status "Downloading Core" "FAIL"
    exit 1
fi

# 9. Generate Config
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
status "Generating .zshrc" "OK"

# 10. Assets
if [ ! -f ~/.termux/font.ttf ]; then
    curl -fsSL -o ~/.termux/font.ttf 'https://github.com/romkatv/dotfiles-public/raw/master/.local/share/fonts/NerdFonts/MesloLGS%20NF%20Regular.ttf' >/dev/null 2>&1
    status "Installing Default Font" "OK"
fi

if [ ! -f ~/.termux/colors.properties ]; then
    curl -fsSL -o ~/.termux/colors.properties 'https://raw.githubusercontent.com/LbsLightX/1llicit-colors/main/themes/3024-night.properties' >/dev/null 2>&1
    status "Setting Default Theme" "OK"
fi

if [ ! -f ~/.termux/termux.properties ]; then
    curl -fsSL -o ~/.termux/termux.properties 'https://raw.githubusercontent.com/LbsLightX/1llicit/main/.termux/termux.properties' >/dev/null 2>&1
    status "Configuring Keys" "OK"
fi

# Reload
termux-reload-settings
zsh -ic "fast-theme zdharma" > /dev/null 2>&1

echo "║"
echo -e "╚══ ${GREEN}${B}INSTALLATION COMPLETE${RESET} ═════════════════════════════"
echo ""
sleep 2

# Restore cursor.
setterm -cursor on

# Enable the fetch alias immediately for this session
alias fetch='fastfetch'

# Unconditional reload
clear
exec zsh -l
exit
