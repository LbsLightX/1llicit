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
    local options=("⦿ 1llicit Theme (Gogh Sync)" "⦿ Termux Styling (Official)" "⦿ Favorites (Recommended)")
    # Cyber-Obsidian UI
    echo -e "\n  \033[1;34m【 THEME LIBRARY SELECTION 】\033[0m"
    echo -e "  \033[1;30m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    # We use fzf to display the list directly instead of echo
    local choice=$(printf "%s\n" "${options[@]}" | fzf --prompt="Themes ⫸ " --height=10 --layout=reverse --header="[ Ctrl-c to Cancel ] | [ Enter to Apply ]")

    case "$choice" in
        *"1llicit Theme"*) 
            if curl --output /dev/null --silent --head --fail "https://raw.githubusercontent.com/LbsLightX/1llicit-colors/main/install.sh"; then
                bash -c "$(curl -fsSL 'https://raw.githubusercontent.com/LbsLightX/1llicit-colors/main/install.sh')"
            else
                echo "✕ Error: Can't connect to repository."
            fi
            ;; 
        *"Termux Styling"*) 
            printf "◷ Fetching official Termux themes...\r"
            local themes=$(curl -fsSL "https://api.github.com/repos/termux/termux-styling/contents/app/src/main/assets/colors" | jq -r '.[].name' | command grep ".properties")
            
            if [ -z "$themes" ]; then
                echo "✕ Error: Could not fetch official themes."
                return
            fi

            local selected=$(printf "%s\n" "$themes" | fzf --prompt="Official ⫸ " --height=15 --layout=reverse --header="[ Ctrl-c to Cancel ] | [ Enter to Apply ]")
            if [[ -n "$selected" ]]; then
                printf "✔ Applying: $(echo $selected | sed 's/\.properties//')\n"
                mkdir -p ~/.termux
                curl -fsSL "https://raw.githubusercontent.com/termux/termux-styling/master/app/src/main/assets/colors/$selected" -o ~/.termux/colors.properties
                termux-reload-settings
            else
                echo "⚠ Cancelled."
            fi
            ;; 
        *"Favorites"*) 
            local url_base="https://raw.githubusercontent.com/LbsLightX/1llicit/main/favorites/themes"
            local themes=$(curl -fsSL "https://api.github.com/repos/LbsLightX/1llicit/contents/favorites/themes" | jq -r '.[].name' | command grep ".properties")
            
            if [ -z "$themes" ]; then
                echo "⚠ No favorites found in repository."
                return
            fi

            local selected=$(printf "%s\n" "$themes" | fzf --prompt="Favorites ⫸ " --height=15 --layout=reverse --header="[ Ctrl-c to Cancel ] | [ Enter to Apply ]")
            if [[ -n "$selected" ]]; then
                printf "✔ Applying: $selected\n"
                mkdir -p ~/.termux
                curl -fsSL "$url_base/$selected" -o ~/.termux/colors.properties
                termux-reload-settings
            else
                echo "⚠ Cancelled."
            fi
            ;; 
        *) ;; 
    esac
}

# --- FONT MANAGER ---
function lit-fonts() {
    for pkg in jq curl fzf; do
        if ! command -v $pkg >/dev/null 2>&1; then
            printf "◷ Installing missing dependency: $pkg\r"
            pkg install -y $pkg >/dev/null 2>&1
            echo "✔ Installed: $pkg"
        fi
    done

    local options=("⦿ Nerd Fonts (2600+)" "⦿ Standard Meslo (Recommended)" "⦿ Favorites")
    echo -e "\n  \033[1;34m【 FONT LIBRARY SELECTION 】\033[0m"
    echo -e "  \033[1;30m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    local choice=$(printf "%s\n" "${options[@]}" | fzf --prompt="Fonts ⫸ " --height=10 --layout=reverse --header="[ Ctrl-c to Cancel ] | [ Enter to Apply ]")

    case "$choice" in
        *"Nerd Fonts"*) 
            if curl --output /dev/null --silent --head --fail "https://github.com/LbsLightX/1llicit"; then
                printf "◷ Fetching fonts list (Stable v3.4.0)... please wait.\r"
                
                local selection=$(curl -fSsL "https://api.github.com/repos/ryanoasis/nerd-fonts/git/trees/v3.4.0?recursive=1" | \
                    jq -r '.tree[] | select(.path|test("\\.(ttf|otf)$"; "i")) | select(.path|contains("Windows Compatible")|not) | .url="https://raw.githubusercontent.com/ryanoasis/nerd-fonts/v3.4.0/" + .path | (.path | split("/") | last) + " | " + .url' | \
                    fzf --delimiter=" | " --with-nth=1 --height=15 --layout=reverse --header="[ Ctrl-c to Cancel ] | [ Enter to Apply ]")
                
                if [[ -n "$selection" ]]; then
                    local url=$(echo "$selection" | sed 's/.* | //')
                    local name=$(echo "$selection" | sed 's/ | .*//')
                    
                    printf "✔ Applying font: $name\n"
                    mkdir -p ~/.termux
                    curl -fsSL "$(echo $url | sed 's/ /%20/g')" -o ~/.termux/font.ttf
                    termux-reload-settings
                else
                    echo "⚠ Cancelled."
                fi
            else
                echo "☍ Connection error."
            fi
            ;; 
        *"Standard Meslo"*) 
            local meslo_base="https://github.com/romkatv/dotfiles-public/raw/master/.local/share/fonts/NerdFonts"
            local variants=("MesloLGS NF Regular.ttf" "MesloLGS NF Bold.ttf" "MesloLGS NF Italic.ttf" "MesloLGS NF Bold Italic.ttf")
            local sel=$(printf "%s\n" "${variants[@]}" | fzf --prompt="Meslo Variants ⫸ " --height=15 --layout=reverse --header="[ Ctrl-c to Cancel ] | [ Enter to Apply ]")
            
            if [[ -n "$sel" ]]; then
                printf "✔ Installing $sel...\n"
                mkdir -p ~/.termux
                curl -fsSL "$meslo_base/${sel// /%20}" -o ~/.termux/font.ttf
                termux-reload-settings
            else
                echo "⚠ Cancelled."
            fi
            ;; 
        *"Favorites"*) 
            local url_base="https://raw.githubusercontent.com/LbsLightX/1llicit/main/favorites/fonts"
            local fonts_list=$(curl -fsSL "https://api.github.com/repos/LbsLightX/1llicit/contents/favorites/fonts" | jq -r '.[].name' | command grep -E ".ttf|.otf")
            
            if [ -z "$fonts_list" ]; then
                echo "⚠ No favorites found in repository."
                return
            fi

            local sel=$(printf "%s\n" "$fonts_list" | fzf --prompt="Favorites ⫸ " --height=15 --layout=reverse --header="[ Ctrl-c to Cancel ] | [ Enter to Apply ]")
            if [[ -n "$sel" ]]; then
                printf "✔ Installing $sel...\n"
                mkdir -p ~/.termux
                curl -fsSL "$url_base/${sel// /%20}" -o ~/.termux/font.ttf
                termux-reload-settings
            else
                echo "⚠ Cancelled."
            fi
            ;; 
        *) ;; 
    esac
}

function lit-update() {
    printf "◷ Updating system packages...\r"
    pkg update && pkg upgrade -y >/dev/null 2>&1
    
    printf "◷ Updating ZSH/Zinit stuff...\r"
    zi update --all >/dev/null 2>&1
    
    printf "◷ Updating bSUDO...\r"
    curl -fsSL 'https://github.com/agnostic-apollo/sudo/releases/latest/download/sudo' -o $PREFIX/bin/bsudo >/dev/null 2>&1
    chmod 700 "$PREFIX/bin/bsudo"
    
    printf "◷ Updating Fastfetch...\r"
    pkg install --only-upgrade fastfetch -y > /dev/null 2>&1
    
    # Self-Update Mechanism (Reloads this core file)
    printf "◷ Updating 1llicit Core...\r"
    curl -fsSL https://raw.githubusercontent.com/LbsLightX/1llicit/main/core.zsh > $HOME/.1llicit/core.zsh
    
    echo "✔ Updated successfully!"
    sleep 1
    clear
    exec zsh
}
