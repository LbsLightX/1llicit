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
  atload"bindkey '^[[A' history-substring-search-up; bindkey '^[[B' history-substring-search-down; HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='fg=magenta,bold'; HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='fg=red,bold'" \
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
    local options=("1) 1llicit Theme (Gogh Sync)" "2) Termux Styling (Official)" "3) Favorites (Recommended)")
    local choice=$(printf "%s\n" "${options[@]}" | fzf --prompt="THEMES > " --height=10 --layout=reverse --header="[ Ctrl-c to Cancel ] | [ Enter to Apply ]")

    case "$choice" in
        *"1llicit Theme"*) 
            if curl --output /dev/null --silent --head --fail "https://raw.githubusercontent.com/LbsLightX/1llicit-colors/main/install.sh"; then
                # Removed "Loading..." echo to prevent it sticking on screen
                bash -c "$(curl -fsSL 'https://raw.githubusercontent.com/LbsLightX/1llicit-colors/main/install.sh')"
            else
                echo "❌ Error: Can't connect to repository."
            fi
            ;; 
        *"Termux Styling"*) 
            local officials=("Dracula" "Solarized-Dark" "Solarized-Light" "Gruvbox-Dark" "One-Dark" "Nord")
            local selected=$(printf "%s\n" "${officials[@]}" | fzf --prompt="Official > " --height=15 --layout=reverse --header="[ Ctrl-c to Cancel ] | [ Enter to Apply ]")
            if [[ -n "$selected" ]]; then
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
            else
                echo "⚠️ Cancelled."
            fi
            ;; 
        *"Favorites"*) 
            local url_base="https://raw.githubusercontent.com/LbsLightX/1llicit/main/favorites/themes"
            local themes=$(curl -fsSL "https://api.github.com/repos/LbsLightX/1llicit/contents/favorites/themes" | jq -r '.[].name' | command grep ".properties")
            
            if [ -z "$themes" ]; then
                echo "⚠️ No favorites found in repository."
                return
            fi

            local selected=$(printf "%s\n" "$themes" | fzf --prompt="Favorites > " --height=15 --layout=reverse --header="[ Ctrl-c to Cancel ] | [ Enter to Apply ]")
            if [[ -n "$selected" ]]; then
                echo "✨ Applying: $selected"
                mkdir -p ~/.termux
                curl -fsSL "$url_base/$selected" -o ~/.termux/colors.properties
                termux-reload-settings
            else
                echo "⚠️ Cancelled."
            fi
            ;; 
        *) ;; 
    esac
}

# --- FONT MANAGER ---
function lit-fonts() {
    for pkg in jq curl fzf; do
        if ! command -v $pkg >/dev/null 2>&1; then
            echo "Installing missing dependency: $pkg"
            pkg install -y $pkg
        fi
    done

    local options=("1) Nerd Fonts (2600+)" "2) Standard Meslo (Recommended)" "3) Favorites")
    local choice=$(printf "%s\n" "${options[@]}" | fzf --prompt="FONTS > " --height=10 --layout=reverse --header="[ Ctrl-c to Cancel ] | [ Enter to Apply ]")

    case "$choice" in
        *"Nerd Fonts"*) 
            if curl --output /dev/null --silent --head --fail "https://github.com/LbsLightX/1llicit"; then
                echo "⏳ Fetching fonts list from repository (Stable v3.4.0)... please wait, this may take 1-2 minutes."
                typeset -A fonts
                while IFS= read -r entry
                do
                    fonts[$(basename "$entry")]="$entry"
                done < <(curl -fSsL "https://api.github.com/repos/ryanoasis/nerd-fonts/git/trees/v3.4.0?recursive=1" | jq -r '.tree[] | select(.path|match("^patched-fonts/.*\\.(ttf|otf)$","i")) | select(.path|contains("Windows Compatible")|not) | .url="https://raw.githubusercontent.com/ryanoasis/nerd-fonts/v3.4.0/" + .path | .url')
                
                local selection=$(printf "%s\n" "${(@k)fonts}" | sort | fzf --height=15 --layout=reverse --header="[ Ctrl-c to Cancel ] | [ Enter to Apply ]")
                if [[ -n "$selection" ]]; then
                    echo "✨ Applying font: $selection"
                    mkdir -p ~/.termux
                    curl -fsSL "$( echo "${fonts[$selection]}" | sed 's/ /%20/g' )" -o ~/.termux/font.ttf
                    termux-reload-settings
                else
                    echo "⚠️ Cancelled."
                fi
            else
                echo " 🌐 Connection error."
            fi
            ;; 
        *"Standard Meslo"*) 
            local meslo_base="https://github.com/romkatv/dotfiles-public/raw/master/.local/share/fonts/NerdFonts"
            local variants=("MesloLGS NF Regular.ttf" "MesloLGS NF Bold.ttf" "MesloLGS NF Italic.ttf" "MesloLGS NF Bold Italic.ttf")
            local sel=$(printf "%s\n" "${variants[@]}" | fzf --prompt="Meslo Variants > " --height=15 --layout=reverse --header="[ Ctrl-c to Cancel ] | [ Enter to Apply ]")
            
            if [[ -n "$sel" ]]; then
                echo "✨ Installing $sel..."
                mkdir -p ~/.termux
                curl -fsSL "$meslo_base/$(echo $sel | sed 's/ /%20/g')" -o ~/.termux/font.ttf
                termux-reload-settings
                echo "✅ Done."
            else
                echo "⚠️ Cancelled."
            fi
            ;; 
        *"Favorites"*) 
            local url_base="https://raw.githubusercontent.com/LbsLightX/1llicit/main/favorites/fonts"
            local fonts_list=$(curl -fsSL "https://api.github.com/repos/LbsLightX/1llicit/contents/favorites/fonts" | jq -r '.[].name' | command grep -E ".ttf|.otf")
            
            if [ -z "$fonts_list" ]; then
                echo "⚠️ No favorites found in repository."
                return
            fi

            local sel=$(printf "%s\n" "$fonts_list" | fzf --prompt="Favorites > " --height=15 --layout=reverse --header="[ Ctrl-c to Cancel ] | [ Enter to Apply ]")
            if [[ -n "$sel" ]]; then
                echo "✨ Installing $sel..."
                mkdir -p ~/.termux
                curl -fsSL "$url_base/$sel" -o ~/.termux/font.ttf
                termux-reload-settings
            else
                echo "⚠️ Cancelled."
            fi
            ;; 
        *) ;; 
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
