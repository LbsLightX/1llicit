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
function 1ll-colors() {
    local options=("⦿ 1llicit Theme (Gogh Sync)" "⦿ Termux Styling (Official)" "⦿ Favorites (Recommended)")
    
    echo -e "\n  ╭── \033[1;34mTHEME LIBRARY\033[0m ✿ ──"
    # Using the bar style requested
    local choice=$(printf "%s\n" "${options[@]}" | fzf --prompt="│ ⫸ " --height=10 --layout=reverse --header="│ [ Ctrl-c to Cancel ] | [ Enter to Apply ]")

    case "$choice" in
        *"1llicit Theme"*) 
            if curl --output /dev/null --silent --head --fail "https://raw.githubusercontent.com/LbsLightX/1llicit-colors/main/install.sh"; then
                bash -c "$(curl -fsSL 'https://raw.githubusercontent.com/LbsLightX/1llicit-colors/main/install.sh')"
            else
                echo "│ ⊖ Error: Can't connect to repository."
            fi
            ;; 
        *"Termux Styling"*) 
            printf "│ ◷ Fetching official Termux themes...\r"
            local themes=$(curl -fsSL "https://api.github.com/repos/termux/termux-styling/contents/app/src/main/assets/colors" | jq -r '.[].name' | command grep ".properties")
            
            if [ -z "$themes" ]; then
                printf "│ ⊖ Error: Could not fetch official themes.\n"
                return
            fi
            
            printf "%*s\r" "${COLUMNS:-80}" ""

            local selected=$(printf "%s\n" "$themes" | fzf --prompt="│ Official ⫸ " --height=15 --layout=reverse --header="│ [ Ctrl-c to Cancel ] | [ Enter to Apply ]")
            if [[ -n "$selected" ]]; then
                printf "│ ◷ Applying: $(echo $selected | sed 's/\.properties//')...\r"
                mkdir -p ~/.termux
                curl -fsSL "https://raw.githubusercontent.com/termux/termux-styling/master/app/src/main/assets/colors/$selected" -o ~/.termux/colors.properties >/dev/null 2>&1
                termux-reload-settings
                printf "│ ❀ Applied: $(echo $selected | sed 's/\.properties//')         \n"
            else
                echo "│ ⚠ Cancelled."
            fi
            ;; 
        *"Favorites"*) 
            local url_base="https://raw.githubusercontent.com/LbsLightX/1llicit/main/favorites/themes"
            local themes=$(curl -fsSL "https://api.github.com/repos/LbsLightX/1llicit/contents/favorites/themes" | jq -r '.[].name' | command grep ".properties")
            
            if [ -z "$themes" ]; then
                echo "│ ⚠ No favorites found in repository."
                return
            fi

            local selected=$(printf "%s\n" "$themes" | fzf --prompt="│ Favorites ⫸ " --height=15 --layout=reverse --header="│ [ Ctrl-c to Cancel ] | [ Enter to Apply ]")
            if [[ -n "$selected" ]]; then
                printf "│ ◷ Applying: $selected...\r"
                mkdir -p ~/.termux
                curl -fsSL "$url_base/$selected" -o ~/.termux/colors.properties >/dev/null 2>&1
                termux-reload-settings
                printf "│ ❀ Applied: $selected         \n"
            else
                echo "│ ⚠ Cancelled."
            fi
            ;; 
        *) ;; 
    esac
    echo "╰──────────────────────"
}

# --- SYNTAX HIGHLIGHTING MANAGER ---
function 1ll-syntax() {
    if ! command -v fast-theme >/dev/null 2>&1; then
        echo "│ ⊖ Error: fast-syntax-highlighting plugin not loaded."
        return 1
    fi

   # Only one option for now, but ready for more!
    local options=("⦿ Fast-Theme (Default)")
    
    echo -e "\n  ╭── \033[1;34mSYNTAX THEME\033[0m ❀ ──"
    local mode=$(printf "%s\n" "${options[@]}" | fzf --prompt="│ Mode ⫸ " --height=10 --layout=reverse --header="│ [ Ctrl-c to Cancel ] | [ Enter to Apply ]")

    case "$mode" in
        *"Fast-Theme"*) 
            local themes=$(fast-theme -l | awk '{print $1}')
            local selected=$(echo "$themes" | fzf --prompt="│ Syntax ⫸ " --height=15 --layout=reverse --header="│ [ Ctrl-c to Cancel ] | [ Enter to Apply ]")
            
            if [[ -n "$selected" ]]; then
                printf "│ ◷ Applying: $selected...\r"
                fast-theme "$selected" >/dev/null 2>&1
                printf "│ ❀ Applied: $selected                                    \n"
            else
                echo "│ ⚠ Cancelled."
            fi
            ;; 
        *) ;; 
    esac
    echo "╰──────────────────────"
}

# --- FONT MANAGER ---
function 1ll-fonts() {
    echo -e "\n  ╭── \033[1;34mFONT LIBRARY\033[0m ✽ ──"
    
    for pkg in jq curl fzf; do
        if ! command -v $pkg >/dev/null 2>&1; then
            printf "│ ◷ Installing dependency: $pkg...\r"
            pkg install -y $pkg >/dev/null 2>&1
            printf "│ ⊕ Installed: $pkg                         \n"
        fi
    done

    local options=("⦿ Nerd Fonts (2600+)" "⦿ Standard Meslo (Recommended)" "⦿ Favorites")
    local choice=$(printf "%s\n" "${options[@]}" | fzf --prompt="│ Fonts ⫸ " --height=10 --layout=reverse --header="│ [ Ctrl-c to Cancel ] | [ Enter to Apply ]")

    case "$choice" in
        *"Nerd Fonts"*) 
            if curl --output /dev/null --silent --head --fail "https://github.com/LbsLightX/1llicit"; then
                printf "│ ◷ Fetching list (v3.4.0)... please wait.\r"
                
                local selection=$(curl -fSsL "https://api.github.com/repos/ryanoasis/nerd-fonts/git/trees/v3.4.0?recursive=1" | \
                    jq -r '.tree[] | select(.path|test("\\.(ttf|otf)$"; "i")) | select(.path|contains("Windows Compatible")|not) | .url="https://raw.githubusercontent.com/ryanoasis/nerd-fonts/v3.4.0/" + .path | (.path | split("/") | last) + " | " + .url' | \
                    fzf --delimiter=" | " --with-nth=1 --height=15 --layout=reverse --header="│ [ Ctrl-c to Cancel ] | [ Enter to Apply ]" --prompt="│ Select ⫸ ")
                
                printf "%*s\r" "${COLUMNS:-80}" ""

                if [[ -n "$selection" ]]; then
                    local url=$(echo "$selection" | sed 's/.* | //')
                    local name=$(echo "$selection" | sed 's/ | .*//')
                    
                    printf "│ ◷ Installing: $name...\r"
                    mkdir -p ~/.termux
                    curl -fsSL "$(echo $url | sed 's/ /%20/g')" -o ~/.termux/font.ttf >/dev/null 2>&1
                    termux-reload-settings
                    printf "│ ❀ Installed: $name                                         \n"
                else
                    echo "│ ⚠ Cancelled."
                fi
            else
                echo "│ ☍ Connection error."
            fi
            ;; 
        *"Standard Meslo"*) 
            local meslo_base="https://github.com/romkatv/dotfiles-public/raw/master/.local/share/fonts/NerdFonts"
            local variants=("MesloLGS NF Regular.ttf" "MesloLGS NF Bold.ttf" "MesloLGS NF Italic.ttf" "MesloLGS NF Bold Italic.ttf")
            local sel=$(printf "%s\n" "${variants[@]}" | fzf --prompt="│ Meslo ⫸ " --height=15 --layout=reverse --header="│ [ Ctrl-c to Cancel ] | [ Enter to Apply ]")
            
            if [[ -n "$sel" ]]; then
                printf "│ ◷ Installing: $sel...\r"
                mkdir -p ~/.termux
                curl -fsSL "$meslo_base/${sel// /%20}" -o ~/.termux/font.ttf >/dev/null 2>&1
                termux-reload-settings
                printf "│ ❀ Installed: $sel                                         \n"
            else
                echo "│ ⚠ Cancelled."
            fi
            ;; 
        *"Favorites"*) 
            local url_base="https://raw.githubusercontent.com/LbsLightX/1llicit/main/favorites/fonts"
            local fonts_list=$(curl -fsSL "https://api.github.com/repos/LbsLightX/1llicit/contents/favorites/fonts" | jq -r '.[].name' | command grep -E ".ttf|.otf")
            
            if [ -z "$fonts_list" ]; then
                echo "│ ⚠ No favorites found in repository."
                return
            fi

            local sel=$(printf "%s\n" "$fonts_list" | fzf --prompt="│ Favorites ⫸ " --height=15 --layout=reverse --header="│ [ Ctrl-c to Cancel ] | [ Enter to Apply ]")
            if [[ -n "$sel" ]]; then
                printf "│ ◷ Installing: $sel...\r"
                mkdir -p ~/.termux
                curl -fsSL "$url_base/${sel// /%20}" -o ~/.termux/font.ttf >/dev/null 2>&1
                termux-reload-settings
                printf "│ ❀ Installed: $sel                                         \n"
            else
                echo "│ ⚠ Cancelled."
            fi
            ;; 
        *) ;; 
    esac
    echo "╰──────────────────────"
}

function 1ll-update() {
    echo -e "\n  ╭── \033[1;34mSYSTEM UPDATE\033[0m ❁ ──"
    
    printf "│ ◷ Updating system packages...\r"
    pkg update && pkg upgrade -y >/dev/null 2>&1
    printf "│ ⊕ System packages updated.   \n"
    
    printf "│ ◷ Updating ZSH/Zinit stuff...\r"
    zi update --all >/dev/null 2>&1
    printf "│ ⊕ ZSH/Zinit updated.         \n"
    
    printf "│ ◷ Updating bSUDO...\r"
    curl -fsSL 'https://github.com/agnostic-apollo/sudo/releases/latest/download/sudo' -o $PREFIX/bin/bsudo >/dev/null 2>&1
    chmod 700 "$PREFIX/bin/bsudo"
    printf "│ ⊕ bSUDO updated.             \n"
    
    printf "│ ◷ Updating Fastfetch...\r"
    pkg install --only-upgrade fastfetch -y > /dev/null 2>&1
    printf "│ ⊕ Fastfetch updated.         \n"
    
    printf "│ ◷ Updating 1llicit Core...\r"
    curl -fsSL https://raw.githubusercontent.com/LbsLightX/1llicit/main/core.zsh > $HOME/.1llicit/core.zsh
    printf "│ ⊕ 1llicit Core updated.      \n"
    
    echo "╰──────────────────────"
    echo "✨ All updates complete! 👯"
    sleep 1
    clear
    exec zsh
}
