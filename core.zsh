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

# Styles for UI
B="\033[1m"
DIM="\033[2m"
GREEN="\033[1;32m"
RED="\033[1;31m"
YELLOW="\033[1;33m"
CYAN="\033[1;36m"
WHITE="\033[1;97m"
RESET="\033[0m"

# --- THEME MANAGER ---
function 1ll-colors() {
    local options=("⦿ 1llicit Theme (Gogh Sync)" "⦿ Termux Styling (Official)" "⦿ Favorites (Recommended)")
    
    echo -e "\n${WHITE}${B}╔═════════ THEME LIBRARY ════════════════════════════ ◈${RESET}"
    local choice=$(printf "%s\n" "${options[@]}" | fzf --prompt="╬ Selection ⫸ " --height=10 --layout=reverse --header="╬ [ Ctrl-c to Cancel ] | [ Enter to Apply ]")

    case "$choice" in
        *"1llicit Theme"*) 
            if curl --output /dev/null --silent --head --fail "https://raw.githubusercontent.com/LbsLightX/1llicit-colors/main/install.sh"; then
                bash -c "$(curl -fsSL 'https://raw.githubusercontent.com/LbsLightX/1llicit-colors/main/install.sh')"
            else
                echo -e "╬ ${RED}${B}[!] Error:${RESET} Can't connect to repository."
            fi
            ;;;;
        *"Termux Styling"*) 
            printf "╬ ${CYAN}[*]${RESET} Fetching official Termux themes...\r"
            local themes=$(curl -fsSL "https://api.github.com/repos/termux/termux-styling/contents/app/src/main/assets/colors" | jq -r '.[].name' | command grep ".properties")
            
            if [ -z "$themes" ]; then
                printf "\r\033[K"
                echo -e "╬ ${RED}${B}[!] Error:${RESET} Could not fetch official themes."
                return
            fi
            
            printf "\r\033[K"

            local selected=$(printf "%s\n" "$themes" | fzf --prompt="╬ Official ⫸ " --height=15 --layout=reverse --header="╬ [ Ctrl-c to Cancel ] | [ Enter to Apply ]")
            if [[ -n "$selected" ]]; then
                printf "╬ ${CYAN}[*]${RESET} Applying color scheme: $(echo $selected | sed 's/\.properties//')...\r"
                mkdir -p ~/.termux
                curl -fsSL "https://raw.githubusercontent.com/termux/termux-styling/master/app/src/main/assets/colors/$selected" -o ~/.termux/colors.properties >/dev/null 2>&1
                termux-reload-settings
                printf "\r\033[K"
                echo -e "╬ ${GREEN}${B}[+] Applied color scheme:${RESET} $(echo $selected | sed 's/\.properties//')"
            else
                echo -e "╬ ${RED}${B}[-] Cancelled.${RESET}"
            fi
            ;;;;
        *"Favorites"*) 
            local url_base="https://raw.githubusercontent.com/LbsLightX/1llicit/main/favorites/themes"
            local themes=$(curl -fsSL "https://api.github.com/repos/LbsLightX/1llicit/contents/favorites/themes" | jq -r '.[].name' | command grep ".properties")
            
            if [ -z "$themes" ]; then
                echo -e "╬ ${RED}${B}[-] Cancelled:${RESET} No favorites found in repository."
                return
            fi

            local selected=$(printf "%s\n" "$themes" | fzf --prompt="╬ Favorites ⫸ " --height=15 --layout=reverse --header="╬ [ Ctrl-c to Cancel ] | [ Enter to Apply ]")
            if [[ -n "$selected" ]]; then
                printf "╬ ${CYAN}[*]${RESET} Applying color scheme: $selected...\r"
                mkdir -p ~/.termux
                curl -fsSL "$url_base/$selected" -o ~/.termux/colors.properties >/dev/null 2>&1
                termux-reload-settings
                printf "\r\033[K"
                echo -e "╬ ${GREEN}${B}[+] Applied color scheme:${RESET} $selected"
            else
                echo -e "╬ ${RED}${B}[-] Cancelled.${RESET}"
            fi
            ;;;;
        *)
            ;;
    esac
    echo -e "╚════════════════════════════════════════════════════ ◈"
}

# --- SYNTAX HIGHLIGHTING MANAGER ---
function 1ll-syntax() {
    if ! command -v fast-theme >/dev/null 2>&1; then
        echo -e "╬ ${RED}${B}[!] Error:${RESET} fast-syntax-highlighting plugin not loaded."
        return 1
    fi

    local options=("⦿ Browse Theme List (Preview)" "⦿ Select via Menu (Quick)")
    
    echo -e "\n${WHITE}${B}╔═════════ SYNTAX THEME ═════════════════════════════ ◈${RESET}"
    local mode=$(printf "%s\n" "${options[@]}" | fzf --prompt="╬ Mode ⫸ " --height=10 --layout=reverse --header="╬ [ Ctrl-c to Cancel ] | [ Enter to Apply ]")

    case "$mode" in
        *"Browse"*) 
            echo -e "╬ ${CYAN}[*]${RESET} Loading previews..."
            fast-theme -l
            ;;;;
        *"Select"*) 
            local themes=$(fast-theme -l | awk '{print $1}')
            local selected=$(echo "$themes" | fzf --prompt="╬ Syntax ⫸ " --height=15 --layout=reverse --header="╬ [ Ctrl-c to Cancel ] | [ Enter to Apply ]")
            
            if [[ -n "$selected" ]]; then
                printf "╬ ${CYAN}[*]${RESET} Applying: $selected...\r"
                fast-theme "$selected" >/dev/null 2>&1
                printf "\r\033[K"
                echo -e "╬ ${GREEN}${B}[+] Applied syntax theme:${RESET} $selected"
            else
                echo -e "╬ ${RED}${B}[-] Cancelled.${RESET}"
            fi
            ;;;;
        *)
            ;;
    esac
    echo -e "╚════════════════════════════════════════════════════ ◈"
}

# --- FONT MANAGER ---
function 1ll-fonts() {
    echo -e "\n${WHITE}${B}╔═════════ FONT LIBRARY ═════════════════════════════ ◈${RESET}"
    
    for pkg in jq curl fzf; do
        if ! command -v $pkg >/dev/null 2>&1; then
            printf "╬ ${CYAN}[*]${RESET} Installing dependency: $pkg...\r"
            pkg install -y $pkg >/dev/null 2>&1
            printf "\r\033[K"
            echo -e "╬ ${GREEN}${B}[+] Installed dependency:${RESET} $pkg"
        fi
    done

    local options=("⦿ Nerd Fonts (2600+)" "⦿ Standard Meslo (Recommended)" "⦿ Favorites")
    local choice=$(printf "%s\n" "${options[@]}" | fzf --prompt="╬ Fonts ⫸ " --height=10 --layout=reverse --header="╬ [ Ctrl-c to Cancel ] | [ Enter to Apply ]")

    case "$choice" in
        *"Nerd Fonts"*) 
            if curl --output /dev/null --silent --head --fail "https://github.com/LbsLightX/1llicit"; then
                printf "╬ ${CYAN}[*]${RESET} Fetching list (v3.4.0)... please wait.\r"
                
                local selection=$(curl -fSsL "https://api.github.com/repos/ryanoasis/nerd-fonts/git/trees/v3.4.0?recursive=1" | \
                    jq -r '.tree[] | select(.path|test("\\.(ttf|otf)$"; "i")) | select(.path|contains("Windows Compatible")|not) | .url="https://raw.githubusercontent.com/ryanoasis/nerd-fonts/v3.4.0/" + .path | (.path | split("/") | last) + " | " + .url' | \
                    fzf --delimiter=" | " --with-nth=1 --height=15 --layout=reverse --header="╬ [ Ctrl-c to Cancel ] | [ Enter to Apply ]" --prompt="╬ Select ⫸ ")
                
                printf "\r\033[K"

                if [[ -n "$selection" ]]; then
                    local url=$(echo "$selection" | sed 's/.* | //')
                    local name=$(echo "$selection" | sed 's/ | .*//')
                    
                    printf "╬ ${CYAN}[*]${RESET} Installing font: $name...\r"
                    mkdir -p ~/.termux
                    curl -fsSL "$(echo $url | sed 's/ /%20/g')" -o ~/.termux/font.ttf >/dev/null 2>&1
                    termux-reload-settings
                    printf "\r\033[K"
                    echo -e "╬ ${GREEN}${B}[+] Installed font:${RESET} $name"
                else
                    echo -e "╬ ${RED}${B}[-] Cancelled.${RESET}"
                fi
            else
                echo -e "╬ ${RED}${B}[!]${RESET} Connection error."
            fi
            ;;;;
        *"Standard Meslo"*) 
            local meslo_base="https://github.com/romkatv/dotfiles-public/raw/master/.local/share/fonts/NerdFonts"
            local variants=("MesloLGS NF Regular.ttf" "MesloLGS NF Bold.ttf" "MesloLGS NF Italic.ttf" "MesloLGS NF Bold Italic.ttf")
            local sel=$(printf "%s\n" "${variants[@]}" | fzf --prompt="╬ Meslo ⫸ " --height=15 --layout=reverse --header="╬ [ Ctrl-c to Cancel ] | [ Enter to Apply ]")
            
            if [[ -n "$sel" ]]; then
                printf "╬ ${CYAN}[*]${RESET} Installing font: $sel...\r"
                mkdir -p ~/.termux
                curl -fsSL "$meslo_base/${sel// /%20}" -o ~/.termux/font.ttf >/dev/null 2>&1
                termux-reload-settings
                printf "\r\033[K"
                echo -e "╬ ${GREEN}${B}[+] Installed font:${RESET} $sel"
            else
                echo -e "╬ ${RED}${B}[-] Cancelled.${RESET}"
            fi
            ;;;;
        *"Favorites"*) 
            local url_base="https://raw.githubusercontent.com/LbsLightX/1llicit/main/favorites/fonts"
            local fonts_list=$(curl -fsSL "https://api.github.com/repos/LbsLightX/1llicit/contents/favorites/fonts" | jq -r '.[].name' | command grep -E ".ttf|.otf")
            
            if [ -z "$fonts_list" ]; then
                echo -e "╬ ${RED}${B}[-] Cancelled:${RESET} No favorites found in repository."
                return
            fi

            local sel=$(printf "%s\n" "$fonts_list" | fzf --prompt="╬ Favorites ⫸ " --height=15 --layout=reverse --header="╬ [ Ctrl-c to Cancel ] | [ Enter to Apply ]")
            if [[ -n "$sel" ]]; then
                printf "╬ ${CYAN}[*]${RESET} Installing font: $sel...\r"
                mkdir -p ~/.termux
                curl -fsSL "$url_base/${sel// /%20}" -o ~/.termux/font.ttf >/dev/null 2>&1
                termux-reload-settings
                printf "\r\033[K"
                echo -e "╬ ${GREEN}${B}[+] Installed font:${RESET} $sel"
            else
                echo -e "╬ ${RED}${B}[-] Cancelled.${RESET}"
            fi
            ;;;;
        *)
            ;;
    esac
    echo -e "╚════════════════════════════════════════════════════ ◈"
}

function 1ll-update() {
    echo -e "\n${WHITE}${B}╔═════════ SYSTEM UPDATE ════════════════════════════ ◈${RESET}"
    echo "╬"
    
    printf "╬ ${CYAN}[*]${RESET} Updating system packages...\r"
    pkg update -y -qq >/dev/null 2>&1
    pkg upgrade -y -qq >/dev/null 2>&1
    printf "\r\033[K"
    echo -e "╬ ${GREEN}${B}[+]${RESET} System packages updated."
    
    printf "╬ ${CYAN}[*]${RESET} Updating ZSH/Zinit stuff (may take 1-2 mins)..."
    zi update --all >/dev/null 2>&1
    printf "\r\033[K"
    echo -e "╬ ${GREEN}${B}[+]${RESET} ZSH/Zinit updated."
    
    printf "╬ ${CYAN}[*]${RESET} Updating bSUDO..."
    curl -fsSL 'https://github.com/agnostic-apollo/sudo/releases/latest/download/sudo' -o $PREFIX/bin/bsudo >/dev/null 2>&1
    chmod 700 "$PREFIX/bin/bsudo"
    printf "\r\033[K"
    echo -e "╬ ${GREEN}${B}[+]${RESET} bSUDO updated."
    
    printf "╬ ${CYAN}[*]${RESET} Updating Fastfetch..."
    pkg install --only-upgrade fastfetch -y > /dev/null 2>&1
    printf "\r\033[K"
    echo -e "╬ ${GREEN}${B}[+]${RESET} Fastfetch updated."
    
    printf "╬ ${CYAN}[*]${RESET} Updating 1llicit Core..."
    curl -fsSL https://raw.githubusercontent.com/LbsLightX/1llicit/main/core.zsh > $HOME/.1llicit/core.zsh
    printf "\r\033[K"
    echo -e "╬ ${GREEN}${B}[+]${RESET} 1llicit Core updated."
    
    echo "╬"
    echo -e "╚═════════ ${GREEN}${B}COMPLETE${RESET} ════════════════════════════════ ◈"
    sleep 1
    clear
    exec zsh
}
