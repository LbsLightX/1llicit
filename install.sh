#!/usr/bin/env bash

# Turn off cursor.
setterm -cursor off

banner () {
clear
echo -e "\033[1;34m" # Make it Blue
echo "   ⠀⠀⠀⠀⠀  ⠀⠀⠀⠀⣴⣿⣦⠀⠀⠀⠀⠀⠀⠀  ⠀ "
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
echo -e "\033[0m" # Reset color
echo "      Fast, beautiful, 1llicit!       "
echo ""
}
banner

# Handy function to silence stuff.
shutt () {
    { "$@" || return $?; } | while read -r line; do
        :
    done
}

# Get fastest mirrors.
echo -n -e "Syncing with fastest mirrors. \033[0K\r"
(echo 'n' | pkg update 2>/dev/null) | while read -r line; do
    :
done
sleep 2

# Upgrade packages.
echo -n -e "Updating system. \033[0K\r"
shutt pkg upgrade -y -o Dpkg::Options::='--force-confnew' 2>/dev/null
sleep 2

# Installing required packages.
echo -n -e "Installing required packages. \033[0K\r"
shutt pkg install -y curl git zsh man jq perl fzf fastfetch termux-api 2>/dev/null
sleep 2

# Installing BetterSUDO.
echo -n -e "Installing agnostic-apollo's SUDO wrapper (as bsudo). \033[0K\r"
curl -fsSL 'https://github.com/agnostic-apollo/sudo/releases/latest/download/sudo' -o $PREFIX/bin/bsudo
chmod 700 "$PREFIX/bin/bsudo"
sleep 2

# Giving Storage permision to Termux App.
if [ ! -d ~/storage ]; then
    echo -n -e "Setting up storage access for Termux. \033[0K\r"
    termux-setup-storage
    sleep 2
fi


# 1. Define the specific backup folder with the current date/time
BACKUP_PATH="$HOME/storage/shared/1llicit/backup/$(date +%Y_%m_%d_%H_%M)"

# 2. Create that specific folder
mkdir -p "$BACKUP_PATH"

# 3. Run the loop
for i in "$HOME/.zshrc" "$HOME/.termux/font.ttf" "$HOME/.termux/colors.properties" "$HOME/.termux/termux.properties"
do
    if [ -f $i ]; then
        echo -n -e "Backing up current $i file. \033[0K\r"
        mv -f "$i" "$BACKUP_PATH/$(basename $i)"
        sleep 1
    fi
done

# Clean slate
rm -f "$HOME/.zshrc"
sleep 2

# Changing default shell to ZSH (if needed).
if [[ "$SHELL" != *"zsh"* ]]; then
   echo -n -e "Changing default shell to ZSH. \033[0K\r"
   chsh -s zsh
else
   echo -n -e "Default shell is already ZSH. Skipping. \033[0K\r"
fi
sleep 1

# Create hidden directory for 1llicit core
mkdir -p "$HOME/.1llicit"

# Download the Core Logic
echo -n -e "Downloading 1llicit Core... \033[0K\r"
curl -fsSL https://raw.githubusercontent.com/LbsLightX/1llicit/main/core.zsh > "$HOME/.1llicit/core.zsh"

# Generate the minimal .zshrc
echo -n -e "Generating .zshrc configuration... \033[0K\r"
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
(( ${_comps} )) && _comps[zinit]=_zinit

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# --- LOAD 1LLICIT CORE ---
if [[ -f "$HOME/.1llicit/core.zsh" ]]; then
    source "$HOME/.1llicit/core.zsh"
fi
EOF
sleep 2

# Installing the Powerline font for Termux.
if [ ! -f ~/.termux/font.ttf ]; then
    echo -n -e "Installing Powerline patched font. \033[0K\r"
    curl -fsSL -o ~/.termux/font.ttf 'https://github.com/romkatv/dotfiles-public/raw/master/.local/share/fonts/NerdFonts/MesloLGS%20NF%20Regular.ttf'
    sleep 2
fi

# Set a default color scheme.
if [ ! -f ~/.termux/colors.properties ]; then
    echo -n -e "Setting up a new color scheme. \033[0K\r"
    curl -fsSL -o ~/.termux/colors.properties 'https://raw.githubusercontent.com/LbsLightX/1llicit-colors/main/themes/3024-night.properties'
    sleep 2
fi

# Set up Termux config file.
if [ ! -f ~/.termux/termux.properties ]; then
    echo -n -e "Setting up Termux's global configuration. \033[0K\r"
    curl -fsSL -o ~/.termux/termux.properties 'https://raw.githubusercontent.com/LbsLightX/1llicit/main/.termux/termux.properties'
    sleep 2
fi

# Reload Termux settings.
sleep 1
termux-reload-settings

# Run a ZSH shell, opens the p10k config wizard.
banner
echo -n -e "Installation complete, enjoy 1llicit! \033[0K\r"
sleep 3

# Restore cursor.
setterm -cursor on

# Enable the fetch alias immediately for this session
alias fetch='fastfetch'

# Unconditional reload
clear
exec zsh -l
exit
