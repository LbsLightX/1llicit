#!/usr/bin/env bash

# Turn off cursor.
setterm -cursor off

banner () {
clear
echo -e "\033[1;34m" # Make it Blue
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
echo -e "\033[0m" # Reset color
echo "      ! 1llicit !1llicit !1llicit !1llicit !       "
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
printf "◷ Syncing with fastest mirrors...\r"
(echo 'n' | pkg update 2>/dev/null) | while read -r line; do :; done
printf "✔ Syncing with fastest mirrors... Done!\n"
sleep 1

# Upgrade packages.
printf "◷ Updating system...\r"
shutt pkg upgrade -y -o Dpkg::Options::='--force-confnew' 2>/dev/null
printf "✔ Updating system... Done!       \n"
sleep 1

# Installing required packages.
printf "◷ Installing required packages...\r"
shutt pkg install -y curl git zsh man jq perl fzf fastfetch termux-api 2>/dev/null
printf "✔ Installing required packages... Done!\n"
sleep 1

# Installing BetterSUDO.
printf "◷ Installing bSUDO...\r"
curl -fsSL 'https://github.com/agnostic-apollo/sudo/releases/latest/download/sudo' -o $PREFIX/bin/bsudo
chmod 700 "$PREFIX/bin/bsudo"
printf "✔ Installing bSUDO... Done!      \n"
sleep 1

# Giving Storage permision to Termux App.
if [ ! -d ~/storage ]; then
    echo "Requesting storage access..."
    termux-setup-storage
    sleep 2
fi


# 1. Define the specific backup folder with the current date/time
BACKUP_PATH="$HOME/storage/shared/1llicit/backup/$(date +%Y_%m_%d_%H_%M)"

# 2. Create that specific folder
mkdir -p "$BACKUP_PATH"

# 3. Run the loop (Transient Style)
printf "◷ Backing up existing configuration...\r"
for i in "$HOME/.zshrc" "$HOME/.termux/font.ttf" "$HOME/.termux/colors.properties" "$HOME/.termux/termux.properties"
do
    if [ -f $i ]; then
        # Overwrite the line with the current file being moved
        printf "◷ Backing up: $(basename $i)...          \r"
        mv -f "$i" "$BACKUP_PATH/$(basename $i)"
        sleep 0.5
    fi
done
printf "✔ Backup complete! (Saved to storage)    \n"
sleep 1

# Clean slate
rm -f "$HOME/.zshrc"

# Changing default shell to ZSH (if needed).
if [[ "$SHELL" != *"zsh"* ]]; then
   printf "◷ Changing default shell to ZSH...\r"
   chsh -s zsh
   printf "✔ Default shell changed to ZSH.   \n"
fi

# Create hidden directory for 1llicit core
mkdir -p "$HOME/.1llicit"

# Download the Core Logic
printf "◷ Downloading 1llicit Core...\r"
curl -fsSL https://raw.githubusercontent.com/LbsLightX/1llicit/main/core.zsh > "$HOME/.1llicit/core.zsh"
printf "✔ Downloading 1llicit Core... Done!\n"

# Generate the minimal .zshrc
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

# Installing the Powerline font for Termux.
if [ ! -f ~/.termux/font.ttf ]; then
    printf "◷ Installing default font (MesloLGS)...\r"
    curl -fsSL -o ~/.termux/font.ttf 'https://github.com/romkatv/dotfiles-public/raw/master/.local/share/fonts/NerdFonts/MesloLGS%20NF%20Regular.ttf' >/dev/null 2>&1
    printf "✔ Default font installed.              \n"
fi

# Set a default color scheme.
if [ ! -f ~/.termux/colors.properties ]; then
    printf "◷ Setting default color scheme...\r"
    curl -fsSL -o ~/.termux/colors.properties 'https://raw.githubusercontent.com/LbsLightX/1llicit-colors/main/themes/3024-night.properties' >/dev/null 2>&1
    printf "✔ Default color scheme set.          \n"
fi

# Set up Termux config file.
if [ ! -f ~/.termux/termux.properties ]; then
    printf "◷ Configuring Termux keys...\r"
    curl -fsSL -o ~/.termux/termux.properties 'https://raw.githubusercontent.com/LbsLightX/1llicit/main/.termux/termux.properties' >/dev/null 2>&1
    printf "✔ Termux keys configured.       \n"
fi

# Reload Termux settings.
termux-reload-settings

# Set Official 1llicit Highlighting Theme
zsh -ic "fast-theme zdharma" > /dev/null 2>&1

# Run a ZSH shell, opens the p10k config wizard.
banner
printf "✔ Installation complete! Enjoy 1llicit. 👯\n"
sleep 3

# Restore cursor.
setterm -cursor on

# Enable the fetch alias immediately for this session
alias fetch='fastfetch'

# Unconditional reload
clear
exec zsh -l
exit
