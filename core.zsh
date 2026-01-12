# 1llicit Core Configuration
# This file contains the logic for the 1llicit environment.

# -----------------------------------------------------------------------------
# 1. Oh-My-Zsh Libraries (via Zinit)
# -----------------------------------------------------------------------------
zinit lucid light-mode for \
    OMZL::history.zsh \
    OMZL::completion.zsh \
    OMZL::key-bindings.zsh

# -----------------------------------------------------------------------------
# 2. Plugins (Syntax Highlighting, Autosuggestions, History Search)
# -----------------------------------------------------------------------------
# LOAD ORDER IS CRITICAL:
# 1. Syntax Highlighting (Must load BEFORE History Search)
# 2. History Substring Search (Loads AFTER Syntax Highlighting)

zinit wait lucid light-mode for \
  atinit"ZINIT[COMPINIT_OPTS]=-C; zpcompinit; zpcdreplay" \
      zdharma-continuum/fast-syntax-highlighting \
      OMZP::colored-man-pages \
      OMZP::git \
  atload"!_zsh_autosuggest_start" \
      zsh-users/zsh-autosuggestions \
  blockf atpull'zinit creinstall -q .' \
      zsh-users/zsh-completions \
  atload"bindkey '^[[A' history-substring-search-up; bindkey '^[[B' history-substring-search-down" \
      zsh-users/zsh-history-substring-search

# -----------------------------------------------------------------------------
# 3. Theme (Powerlevel10k)
# -----------------------------------------------------------------------------
zinit ice depth=1; zinit light romkatv/powerlevel10k

# -----------------------------------------------------------------------------
# 4. FZF Configuration
# -----------------------------------------------------------------------------
zinit wait lucid is-snippet for \
    $PREFIX/share/fzf/key-bindings.zsh \
    $PREFIX/share/fzf/completion.zsh

# Use 16 colors
export FZF_DEFAULT_OPTS='--color 16'

# -----------------------------------------------------------------------------
# 5. Custom Functions & Widgets
# -----------------------------------------------------------------------------

# Magic Backspace: cd .. on empty line (Stops at HOME)
function magic-backspace() {
    if [[ -z "$BUFFER" ]]; then
        if [[ "$PWD" == "$HOME" ]]; then return; fi
        cd ..
        zle reset-prompt
    else
        zle backward-delete-char
    fi
}
zle -N magic-backspace
bindkey "^?" magic-backspace

# --- THEME MANAGER ---
function lit-colors() {
    echo -e "\n  \033[1;34mTHEME LIBRARY SELECTION\033[0m"
    echo -e "  \033[1;30m----------------------------------------\033[0m"
    echo -e "  \033[1;33m1)\033[0m 🎨 1llicit Theme (Gogh Sync)"
    echo -e "  \033[1;33m2)\033[0m 🛡️ Termux Styling (Official)"
    echo -e "  \033[1;33m3)\033[0m ⭐ Favorites (Recommended)"
    echo -e "  \033[1;30m----------------------------------------\033[0m"
    echo -n "  Select option: "
    read -k 1 choice
    echo -e "\n"

    case "$choice" in
        1)
            # Main Repository
            if [ $(curl -s -o /dev/null -I -w "% {http_code}" https://raw.githubusercontent.com/LbsLightX/1llicit-colors/main/install.sh) -eq 200 ]; then
                echo "Loading full library..."
                bash -c "$(curl -fsSL 'https://raw.githubusercontent.com/LbsLightX/1llicit-colors/main/install.sh')"
                clear
            else
                echo "❌ Error: Can't connect to repository."
            fi
            ;;
        2)
            # Termux Official (Simulated List)
            local officials=("Dracula" "Solarized-Dark" "Solarized-Light" "Gruvbox-Dark" "One-Dark" "Nord")
            local selected=$(printf "%s\n" "${officials[@]}" | fzf --prompt="🛡️ Official > ")
            if [[ -n "$selected" ]]; then
                # Mapping to file names in our repo (since we have them all anyway)
                local url="https://raw.githubusercontent.com/LbsLightX/1llicit-colors/main/themes/${selected}.properties"
                # Fix naming mismatches manually
                [[ "$selected" == "Dracula" ]] && url="https://raw.githubusercontent.com/LbsLightX/1llicit-colors/main/themes/dracula.properties"
                [[ "$selected" == "Solarized-Dark" ]] && url="https://raw.githubusercontent.com/LbsLightX/1llicit-colors/main/themes/solarized-dark.properties"
                [[ "$selected" == "Solarized-Light" ]] && url="https://raw.githubusercontent.com/LbsLightX/1llicit-colors/main/themes/solarized-light.properties"
                [[ "$selected" == "Gruvbox-Dark" ]] && url="https://raw.githubusercontent.com/LbsLightX/1llicit-colors/main/themes/gruvbox-dark.properties"
                [[ "$selected" == "One-Dark" ]] && url="https://raw.githubusercontent.com/LbsLightX/1llicit-colors/main/themes/one-dark.properties"
                [[ "$selected" == "Nord" ]] && url="https://raw.githubusercontent.com/LbsLightX/1llicit-colors/main/themes/nord.properties"

                echo "✨ Applying: $selected"
                mkdir -p ~/.termux
                curl -fsSL "$url" -o ~/.termux/colors.properties
                termux-reload-settings
            fi
            ;;
        3)
            # Favorites Menu
            local themes=("3024-night" "Monokai-Pro" "Tokyo-Night" "Catppuccin-Mocha" "Rose-Pine")
            local selected=$(printf "%s\n" "${themes[@]}" | fzf --prompt="⭐ Favorites > ")
            if [[ -n "$selected" ]]; then
                local url="https://raw.githubusercontent.com/LbsLightX/1llicit-colors/main/themes/${selected}.properties"
                # Manual fixes
                [[ "$selected" == "Monokai-Pro" ]] && url="https://raw.githubusercontent.com/LbsLightX/1llicit-colors/main/themes/monokai-pro.properties"
                [[ "$selected" == "Tokyo-Night" ]] && url="https://raw.githubusercontent.com/LbsLightX/1llicit-colors/main/themes/tokyo-night.properties"
                [[ "$selected" == "Catppuccin-Mocha" ]] && url="https://raw.githubusercontent.com/LbsLightX/1llicit-colors/main/themes/catppuccin-mocha.properties"
                [[ "$selected" == "Rose-Pine" ]] && url="https://raw.githubusercontent.com/LbsLightX/1llicit-colors/main/themes/rose-pine.properties"

                echo "✨ Applying: $selected"
                mkdir -p ~/.termux
                curl -fsSL "$url" -o ~/.termux/colors.properties
                termux-reload-settings
            fi
            ;;
        *)
            echo "Cancelled."
            ;;
    esac
}

# --- FONT MANAGER ---
function lit-fonts() {
    # Ensure dependencies
    for pkg in jq curl fzf; do
        if ! command -v $pkg >/dev/null 2>&1; then
            echo "Installing missing dependency: $pkg"
            pkg install -y $pkg
        fi
    done

    echo -e "\n  \033[1;34mFONT LIBRARY SELECTION\033[0m"
    echo -e "  \033[1;30m----------------------------------------\033[0m"
    echo -e "  \033[1;33m1)\033[0m 📚 Nerd Fonts (2600+)"
    echo -e "  \033[1;33m2)\033[0m ⚡ Standard Meslo (Recommended)"
    echo -e "  \033[1;33m3)\033[0m ⭐ Favorites"
    echo -e "  \033[1;30m----------------------------------------\033[0m"
    echo -n "  Select option: "
    read -k 1 choice
    echo -e "\n"

    case "$choice" in
        1)
            # The Big Fetch
            status_code=$(curl -s -o /dev/null -I -w "% {http_code}" "https://github.com/LbsLightX/1llicit")
            if [ "$status_code" -eq "200" ]; then
                echo "⏳ Fetching fonts list from repository (Stable v3.4.0)... please wait, this may take 1-2 minutes."
                typeset -A fonts
                while IFS= read -r entry
                do
                    fonts[$(basename "$entry")]="$entry"
                done < <(curl -fSsL "https://api.github.com/repos/ryanoasis/nerd-fonts/git/trees/v3.4.0?recursive=1" | jq -r '.tree[] | select(.path|match("^patched-fonts/.*\\.(ttf|otf)$","i")) | select(.path|contains("Windows Compatible")|not) | .url="https://raw.githubusercontent.com/ryanoasis/nerd-fonts/v3.4.0/" + .path | .url')
                
                choice=$(printf "%s\n" "${(@k)fonts}" | sort | fzf)
                if [ $? -eq 0 ]; then
                    echo "✨ Applying font: $choice"
                    mkdir -p ~/.termux
                    curl -fsSL "$( echo "${fonts[$choice]}" | sed 's/ /%20/g' )" -o ~/.termux/font.ttf
                    termux-reload-settings
                fi
            else
                echo " 🌐 Please check your internet connection."
            fi
            ;;
        2)
            # Instant Install
            echo "✨ Installing MesloLGS NF..."
            mkdir -p ~/.termux
            curl -fsSL -o ~/.termux/font.ttf 'https://github.com/romkatv/dotfiles-public/raw/master/.local/share/fonts/NerdFonts/MesloLGS%20NF%20Regular.ttf'
            termux-reload-settings
            echo "✅ Done."
            ;;
        3)
            # Favorites Menu
            local favs=("JetBrainsMono" "FiraCode" "Hack" "CascadiaCode" "VictorMono")
            local sel=$(printf "%s\n" "${favs[@]}" | fzf --prompt="⭐ Favorites > ")
            if [[ -n "$sel" ]]; then
                echo "✨ Installing $sel..."
                local url=""
                [[ "$sel" == "JetBrainsMono" ]] && url="https://github.com/ryanoasis/nerd-fonts/raw/v3.4.0/patched-fonts/JetBrainsMono/Ligatures/Regular/JetBrainsMonoNerdFont-Regular.ttf"
                [[ "$sel" == "FiraCode" ]] && url="https://github.com/ryanoasis/nerd-fonts/raw/v3.4.0/patched-fonts/FiraCode/Regular/FiraCodeNerdFont-Regular.ttf"
                [[ "$sel" == "Hack" ]] && url="https://github.com/ryanoasis/nerd-fonts/raw/v3.4.0/patched-fonts/Hack/Regular/HackNerdFont-Regular.ttf"
                [[ "$sel" == "CascadiaCode" ]] && url="https://github.com/ryanoasis/nerd-fonts/raw/v3.4.0/patched-fonts/CascadiaCode/Regular/CaskaydiaCoveNerdFont-Regular.ttf"
                [[ "$sel" == "VictorMono" ]] && url="https://github.com/ryanoasis/nerd-fonts/raw/v3.4.0/patched-fonts/VictorMono/Regular/VictorMonoNerdFont-Regular.ttf"
                
                mkdir -p ~/.termux
                curl -fsSL "$url" -o ~/.termux/font.ttf
                termux-reload-settings
            fi
            ;;
        *)
            echo "Cancelled."
            ;;
    esac
}

function lit-update() {
    echo "Updating system packages."
    pkg update && pkg upgrade -y
    clear
    
    echo "Updating ZSH/Zinit stuff.."
    zi update --all
    clear
    
    echo "Updating bSUDO..."
    curl -fsSL 'https://github.com/agnostic-apollo/sudo/releases/latest/download/sudo' -o $PREFIX/bin/bsudo
    chmod 700 "$PREFIX/bin/bsudo"
    clear
    
    echo "Updating Fastfetch...."
    pkg install --only-upgrade fastfetch -y > /dev/null 2>&1
    clear
    
    # Self-Update Mechanism (Reloads this core file)
    echo "Updating 1llicit Core..."
    curl -fsSL https://raw.githubusercontent.com/LbsLightX/1llicit/main/core.zsh > $HOME/.1llicit/core.zsh
    
    echo "✨ Updated successfully, enjoy! 👯"
    sleep 2
    clear
    exec zsh
}

# -----------------------------------------------------------------------------
# 6. Aliases
# -----------------------------------------------------------------------------
alias fetch='fastfetch'
