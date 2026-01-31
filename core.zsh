# 1llicit Core Configuration
# This file contains the logic for the 1llicit environment.


# -----------------------------------------------------------------------------
# 1. Oh-My-Zsh Libraries (via Zinit)
# -----------------------------------------------------------------------------

zinit lucid light-mode for \
    OMZL::history.zsh \
    OMZL::completion.zsh \
    OMZL::key-bindings.zsh \
    OMZP::extract

# Zsh Optimization
setopt hist_ignore_all_dups
setopt hist_find_no_dups
setopt pushd_ignore_dups


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

zinit ice depth=1 compile'(pure|async).zsh'; zinit light romkatv/powerlevel10k


# -----------------------------------------------------------------------------
# 4. Tools & Utilities
# -----------------------------------------------------------------------------

zinit wait lucid for wfxr/forgit

zinit light Aloxaf/fzf-tab
zinit light hlissner/zsh-autopair
zinit light zdharma-continuum/zui
zinit light zdharma-continuum/zinit-console
zinit light djui/alias-tips


# -----------------------------------------------------------------------------
# 5. FZF & Completion Configuration
# -----------------------------------------------------------------------------

zinit wait lucid is-snippet for \
    $PREFIX/share/fzf/completion.zsh \
    $PREFIX/share/fzf/key-bindings.zsh

# FZF-TAB Settings
zstyle ':completion:*:git-checkout:*' sort false

# [THE FIX] Use ANSI codes (\033[36m) instead of Zsh codes (%F)
# \033[36m = Cyan
# \033[0m  = Reset
zstyle ':completion:*:descriptions' format '── \033[36m%d\033[0m ──'

# Smart Preview
if command -v lsd >/dev/null; then
    zstyle ':fzf-tab:complete:cd:*' fzf-preview 'lsd -1 --color=always --icon=always $realpath'
elif command -v eza >/dev/null; then
    zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
else
    zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color=always -1 --group-directories-first $realpath'
fi

zstyle ':fzf-tab:*' fzf-flags --height=15 --layout=reverse --prompt="╬ Select ⫸ "


# -----------------------------------------------------------------------------
# 6. Custom Functions & Widgets
# -----------------------------------------------------------------------------
# Magic Backspace: cd .. on empty line (Stops at HOME)
function magic-backspace() {
    if [[ -z "$BUFFER" ]]; then
        # FIX: Added space after 'if'
        if [[ "$PWD" == "$HOME" ]] || [[ "$PWD" == "/storage/emulated/0" ]]; then 
            return
        fi
        
        cd ..
        zle reset-prompt
    else
        zle backward-delete-char
    fi
}
zle -N magic-backspace
bindkey "^?" magic-backspace

# -----------------------------------------------------------------------------
# Styles & Colors
# -----------------------------------------------------------------------------

BOLD="\033[1m"
DIM="\033[2m"
UNDER="\033[4m"
GREEN="\033[1;32m"
RED="\033[1;31m"
YELLOW="\033[1;33m"
CYAN="\033[1;36m"
WHITE="\033[1;97m"
RESET="\033[0m"


# -----------------------------------------------------------------------------
# Theme Manager
# -----------------------------------------------------------------------------

function 1ll-colors() {
    local options=("⦿ 1llicit Theme (Gogh Sync)" "⦿ Termux Styling (Official)" "⦿ Favorites (Recommended)")
    
    echo -e "\n╔═════════════════ ${WHITE}${BOLD}${UNDER}THEME LIBRARY${RESET} ═════════════════ ❐"
    echo "╬"
        
    local selection=$(printf "%s\n" "${options[@]}" | fzf --prompt="╬ Selection ⫸ " --height=10 --layout=reverse --header="[ Ctrl-c to Cancel ] | [ Enter to Apply ]")

    if [[ -z "$selection" ]]; then
        echo -e "╬ ${RED}${BOLD}[-]${RESET} Cancelled."
        echo -e "╚══════════════════════════════════ ❏"
        return
    fi

    case "$selection" in
        *"1llicit Theme"*) 
            if curl --output /dev/null --silent --head --fail "https://raw.githubusercontent.com/LbsLightX/1llicit-colors/main/install.sh"; then
                bash -c "$(curl -fsSL 'https://raw.githubusercontent.com/LbsLightX/1llicit-colors/main/install.sh')"
            else
                echo -e "╬ ${RED}${BOLD}[!] Error:${RESET} Can't connect to repository."
            fi
            ;; 
        *"Termux Styling"*) 
            printf "╬ ${CYAN}[*]${RESET} Fetching official Termux themes...\r"
            local themes=$(curl -fsSL "https://api.github.com/repos/termux/termux-styling/contents/app/src/main/assets/colors" | jq -r '.[].name' | command grep ".properties")
            
            if [ -z "$themes" ]; then
                printf "\r\033[K"
                echo -e "╬ ${RED}${BOLD}[!] Error:${RESET} Could not fetch official themes."
                echo -e "╚══════════════════════════════════ ❏"
                return
            fi
            
            printf "\r\033[K"

            local sub_selection=$(printf "%s\n" "$themes" | fzf --prompt="╬ Styling color theme ⫸ " --height=15 --layout=reverse --header="[ Ctrl-c to Cancel ] | [ Enter to Apply ]")
            if [[ -n "$sub_selection" ]]; then
                printf "╬ ${CYAN}[*]${RESET} Applying color scheme: $(echo $sub_selection | sed 's/\.properties//')...\r"
                mkdir -p ~/.termux
                curl -fsSL "https://raw.githubusercontent.com/termux/termux-styling/master/app/src/main/assets/colors/$sub_selection" -o ~/.termux/colors.properties >/dev/null 2>&1
                termux-reload-settings
                printf "\r\033[K"
                echo -e "╬ ${GREEN}${BOLD}[+]${RESET} Applied: $(echo $sub_selection | sed 's/\.properties//')"
            else
                echo -e "╬ ${RED}${BOLD}[-]${RESET} Cancelled."
            fi
            ;; 
        *"Favorites"*) 
            local url_base="https://raw.githubusercontent.com/LbsLightX/lbs-archives/main/1llicit/themes/favorites"
            local themes=$(curl -fsSL "https://api.github.com/repos/LbsLightX/lbs-archives/contents/1llicit/themes/favorites" | jq -r '.[].name' | command grep ".properties")
            
            if [ -z "$themes" ]; then
                echo -e "╬ ${RED}${BOLD}[!]${RESET} No favorites found in repository."
                echo -e "╚══════════════════════════════════ ❏"
                return
            fi

            local sub_selection=$(printf "%s\n" "$themes" | fzf --prompt="╬ Selection ⫸ " --height=15 --layout=reverse --header="[ Ctrl-c to Cancel ] | [ Enter to Apply ]")
            if [[ -n "$sub_selection" ]]; then
                printf "╬ ${CYAN}[*]${RESET} Applying color scheme: $sub_selection...\r"
                mkdir -p ~/.termux
                curl -fsSL "$url_base/$sub_selection" -o ~/.termux/colors.properties >/dev/null 2>&1
                termux-reload-settings
                printf "\r\033[K"
                echo -e "╬ ${GREEN}${BOLD}[+]${RESET} Applied: $sub_selection"
            else
                echo -e "╬ ${RED}${BOLD}[-]${RESET} Cancelled."
            fi
            ;; 
        *) ;; 
    esac
    echo -e "╚══════════════════════════════════ ❏"
}

# -----------------------------------------------------------------------------
# Syntax Highlighting Manager
# -----------------------------------------------------------------------------

function 1ll-syntax() {
    if ! command -v fast-theme >/dev/null 2>&1; then
        echo -e "╬ ${RED}${BOLD}[!] Error:${RESET} fast-syntax-highlighting plugin not loaded."
        return 1
    fi

    local options=("⦿ Fast-Theme (Recommended)")
    
    echo -e "\n╔════════════════ ${WHITE}${BOLD}${UNDER}SYNTAX THEME${RESET} ═════════════════ ❐"
    echo "╬"
    
    local selection=$(printf "%s\n" "${options[@]}" | fzf --prompt="╬ Selection ⫸ " --height=10 --layout=reverse --header="[ Ctrl-c to Cancel ] | [ Enter to Apply ]")

    if [[ -z "$selection" ]]; then
        echo -e "╬ ${RED}${BOLD}[-]${RESET} Cancelled."
        echo -e "╚══════════════════════════════════ ❏"
        return
    fi

    case "$selection" in
        *"Fast-Theme"*)
            local themes=$(fast-theme -l | awk '{print $1}')
            local sub_selection=$(echo "$themes" | fzf --prompt="╬ Syntax highlighting ⫸ " --height=15 --layout=reverse --header="[ Ctrl-c to Cancel ] | [ Enter to Apply ]")
            
            if [[ -n "$sub_selection" ]]; then
                printf "╬ ${CYAN}[*]${RESET} Applying syntax theme: $sub_selection...\r"
                fast-theme "$sub_selection" >/dev/null 2>&1
                printf "\r\033[K"
                echo -e "╬ ${GREEN}${BOLD}[+] Applied syntax theme:${RESET} $sub_selection"
            else
                echo -e "╬ ${RED}${BOLD}[-]${RESET} Cancelled."
            fi
            ;; 
        *) ;; 
    esac
    echo -e "╚══════════════════════════════════ ❏"
}


# -----------------------------------------------------------------------------
# Font Manager
# -----------------------------------------------------------------------------

function 1ll-fonts() {
    echo -e "\n╔════════════════ ${WHITE}${BOLD}${UNDER}FONT LIBRARY${RESET} ═════════════════ ❐"
    echo "╬"
    
    for pkg in jq curl fzf; do
        if ! command -v $pkg >/dev/null 2>&1; then
            printf "╬ ${CYAN}[*]${RESET} Installing dependency: $pkg...\r"
            pkg install -y $pkg >/dev/null 2>&1
            printf "\r\033[K"
            echo -e "╬ ${GREEN}${BOLD}[+]${RESET} Installed dependency: $pkg"
        fi
    done

    local options=("⦿ Nerd Fonts (2600+)" "⦿ Standard Meslo (Recommended)" "⦿ The Collection (Curated)" "⦿ Favorites")
    local selection=$(printf "%s\n" "${options[@]}" | fzf --prompt="╬ Selection ⫸ " --height=10 --layout=reverse --header="[ Ctrl-c to Cancel ] | [ Enter to Apply ]")

    if [[ -z "$selection" ]]; then
        echo -e "╬ ${RED}${BOLD}[-]${RESET} Cancelled."
        echo -e "╚══════════════════════════════════ ❏"
        return
    fi

    case "$selection" in
        *"Nerd Fonts"*) 
            if curl --output /dev/null --silent --head --fail "https://github.com/LbsLightX/1llicit"; then
                printf "╬ ${CYAN}[*]${RESET} Fetching list (v3.4.0)... please wait.\r"
                
                local nf_selection=$(curl -fSsL "https://api.github.com/repos/ryanoasis/nerd-fonts/git/trees/v3.4.0?recursive=1" | \
                    jq -r --arg base "$BASE_URL" '.tree[] | .path | select(test("\\.(ttf|otf)$"; "i") and 
                    (test("Windows|Desktop|Propo"; "i") | not)) | "\(split("/")[-1]) | \($base)\(.)"' | \
                    fzf --delimiter=" | " --with-nth=1 --height=15 --layout=reverse --header=$'[ Ctrl-c to Cancel ] | [ Enter to Apply ] \n\033[1;31m[!] ONLY SELECT .TTF OR .OTF FILES\033[0m' --prompt="╬ Nerd fonts ⫸ ")
                
                printf "\r\033[K"

                if [[ -n "$nf_selection" ]]; then
                    local url=$(echo "$nf_selection" | sed 's/.* | //')
                    local name=$(echo "$nf_selection" | sed 's/ | .*//')
                    
                    printf "╬ ${CYAN}[*]${RESET} Installing font: $name...\r"
                    mkdir -p ~/.termux
                    curl -fsSL "$(echo $url | sed 's/ /%20/g')" -o ~/.termux/font.ttf >/dev/null 2>&1
                    termux-reload-settings
                    printf "\r\033[K"
                    echo -e "╬ ${GREEN}${BOLD}[+]${RESET} Installed: $name"
                else
                    echo -e "╬ ${RED}${BOLD}[-]${RESET} Cancelled."
                fi
            else
                echo -e "╬ ${RED}${BOLD}[!]${RESET} Connection error."
            fi
            ;; 
        *"Standard Meslo"*) 
            local meslo_base="https://raw.githubusercontent.com/LbsLightX/lbs-archives/main/1llicit/fonts/meslolgs/powerlevel10k"
            local variants=("MesloLGS NF Regular.ttf" "MesloLGS NF Bold.ttf" "MesloLGS NF Italic.ttf" "MesloLGS NF Bold Italic.ttf")
            local sub_selection=$(printf "%s\n" "${variants[@]}" | fzf --prompt="╬ Meslo family ⫸ " --height=15 --layout=reverse --header="[ Ctrl-c to Cancel ] | [ Enter to Apply ]")
            
            if [[ -n "$sub_selection" ]]; then
                printf "╬ ${CYAN}[*]${RESET} Installing font: $sub_selection...\r"
                mkdir -p ~/.termux
                curl -fsSL "$meslo_base/${sub_selection// /%20}" -o ~/.termux/font.ttf >/dev/null 2>&1
                termux-reload-settings
                printf "\r\033[K"
                echo -e "╬ ${GREEN}${BOLD}[+]${RESET} Installed: $sub_selection"
            else
                echo -e "╬ ${RED}${BOLD}[-]${RESET} Cancelled."
            fi
            ;;
        *"The Collection"*)
            local collections=("SFMono Ligaturized" "Maple Mono NF")
            local coll_choice=$(printf "%s\n" "${collections[@]}" | fzf --prompt="╬ Select Family ⫸ " --height=10 --layout=reverse --header="[ Ctrl-c to Cancel ] | [ Enter to Apply ]")
            
            if [[ -z "$coll_choice" ]]; then
                echo -e "╬ ${RED}[-]${RESET} Cancelled."
                echo -e "╚══════════════════════════════════════════ ◈"
                return
            fi
            
            local folder=""
            case "$coll_choice" in
                *"SFMono"*) folder="sfmono" ;; 
                *"Maple"*)  folder="maple" ;; 
            esac
            
            printf "╬ ${CYAN}[*]${RESET} Fetching variants...\r"
            local api_url="https://api.github.com/repos/LbsLightX/lbs-archives/contents/1llicit/fonts/$folder"
            local raw_base="https://raw.githubusercontent.com/LbsLightX/lbs-archives/main/1llicit/fonts/$folder"
            
            local fonts_list=$(curl -fsSL "$api_url" | jq -r '.[].name' | command grep -E ".ttf|.otf")
            printf "\r\033[K"
            
            if [ -z "$fonts_list" ]; then
                echo -e "╬ ${RED}${BOLD}[!]${RESET} Error fetching fonts list."
                return
            fi

            local sub_selection=$(printf "%s\n" "$fonts_list" | fzf --prompt="╬ Select Variant ⫸ " --height=15 --layout=reverse --header="[ Ctrl-c to Cancel ] | [ Enter to Apply ]")
            
            if [[ -n "$sub_selection" ]]; then
                printf "╬ ${CYAN}[*]${RESET} Installing font: $sub_selection...\r"
                mkdir -p ~/.termux
                curl -fsSL "$raw_base/${sub_selection// /%20}" -o ~/.termux/font.ttf >/dev/null 2>&1
                termux-reload-settings
                printf "\r\033[K"
                echo -e "╬ ${GREEN}${BOLD}[+]${RESET} Installed: $sub_selection"
            else
                echo -e "╬ ${RED}${BOLD}[-]${RESET} Cancelled."
            fi
            ;;
        *"Favorites"*) 
            local url_base="https://raw.githubusercontent.com/LbsLightX/lbs-archives/main/1llicit/fonts/favorites"
            local fonts_list=$(curl -fsSL "https://api.github.com/repos/LbsLightX/lbs-archives/contents/1llicit/fonts/favorites" | jq -r '.[].name' | command grep -E ".ttf|.otf")
            
            if [ -z "$fonts_list" ]; then
                echo -e "╬ ${RED}${BOLD}[!]${RESET} No favorites found in repository."
                return
            fi

            local sub_selection=$(printf "%s\n" "$fonts_list" | fzf --prompt="╬ Selection ⫸ " --height=15 --layout=reverse --header="[ Ctrl-c to Cancel ] | [ Enter to Apply ]")
            if [[ -n "$sub_selection" ]]; then
                printf "╬ ${CYAN}[*]${RESET} Installing font: $sub_selection...\r"
                mkdir -p ~/.termux
                curl -fsSL "$url_base/${sub_selection// /%20}" -o ~/.termux/font.ttf >/dev/null 2>&1
                termux-reload-settings
                printf "\r\033[K"
                echo -e "╬ ${GREEN}${BOLD}[+]${RESET} Installed: $sub_selection"
            else
                echo -e "╬ ${RED}${BOLD}[-]${RESET} Cancelled."
            fi
            ;; 
        *) ;; 
    esac
    echo -e "╚══════════════════════════════════ ❏"
}

# -----------------------------------------------------------------------------
# Git Tools (Forgit Menu)
# -----------------------------------------------------------------------------

function forgit() {
    # Curated list with clear descriptions
    local options=(
        "add              | Stage changed files"
        "diff             | View file changes"
        "reset::head      | Unstage files (Undo Add)"
        "log              | View commit history"
        "checkout::branch | Switch branch"
        "stash::show      | View saved stashes"
        "stash::push      | Save current changes to stash"
        "ignore           | Create .gitignore file"
        "blame            | View line-by-line history"
        "checkout::file   | Revert file (Discard changes) [Destructive]"
        "branch::delete   | Delete branch [Destructive]"
        "clean            | Delete untracked files [Destructive]"
        "rebase           | Interactive Rebase"
        "cherry::pick     | Apply commit to current branch"
    )
    
    local selection=$(printf "%s\n" "${options[@]}" | fzf --prompt="╬ Git Tools ⫸ " --height=20 --layout=reverse --header="[ Ctrl-c to Cancel ] | [ Enter to Apply ]")
    
    if [[ -n "$selection" ]]; then
        # Extract the command name (everything before the " | ")
        local cmd=$(echo "$selection" | awk '{print $1}')
        eval "forgit::$cmd"
    fi
}


# -----------------------------------------------------------------------------
# System Backup
# -----------------------------------------------------------------------------

function 1ll-backup() {
    echo -e "\n╔════════════ ${WHITE}${BOLD}${UNDER}SYSTEM BACKUP${RESET} ════════════ ❐"
    echo "╬"
    
    local backup_root="/storage/emulated/0/Download/1llicit-Backups"
    local timestamp=$(date +%Y-%m-%d_%H-%M-%S)
    local target="$backup_root/$timestamp"
    
    # Check storage access
    if [ ! -d "/storage/emulated/0/Download" ]; then
        echo -e "╬ ${RED}${BOLD}[!] Error:${RESET} Storage permission denied."
        echo -e "╚══════════════════════════════════ ❏"
        return 1
    fi
    
    printf "╬ ${CYAN}[*]${RESET} Creating backup at: $timestamp...\r"
    mkdir -p "$target"
    
    # Critical files
    cp -r ~/.zshrc "$target/" 2>/dev/null
    cp -r ~/.1llicit "$target/" 2>/dev/null
    cp -r ~/.termux "$target/" 2>/dev/null
    
    printf "\r\033[K"
    echo -e "╬ ${GREEN}${BOLD}[+]${RESET} Backup saved to:"
    echo -e "╬     ${DIM}Download/1llicit-Backups/$timestamp${RESET}"
    echo "╬"
    echo -e "╚═══════════ ${GREEN}${BOLD}BACKUP COMPLETE${RESET} ══════════ ❐"
}


# -----------------------------------------------------------------------------
# Update Utility
# -----------------------------------------------------------------------------

function 1ll-update() {
    echo -e "\n╔════════════════ ${WHITE}${BOLD}${UNDER}SYSTEM UPDATE${RESET} ═════════════════ ❐"
    echo "╬"
    
    printf "╬ ${CYAN}[*]${RESET} Updating system packages...\r"
    pkg update -y -qq >/dev/null 2>&1
    pkg upgrade -y -qq >/dev/null 2>&1
    printf "\r\033[K"
    echo -e "╬ ${GREEN}•${RESET} System packages updated.    [ ${GREEN}OK${RESET} ]"
    
    printf "╬ ${CYAN}[*]${RESET} Updating ZSH/Zinit stuff (Wait, it may take 1-2 minutes.)\r"
    zi update --all >/dev/null 2>&1
    printf "\r\033[K"
    echo -e "╬ ${GREEN}•${RESET} ZSH/Zinit updated.          [ ${GREEN}OK${RESET} ]"
    
    printf "╬ ${CYAN}[*]${RESET} Updating bSUDO...\r"
    curl -fsSL 'https://github.com/agnostic-apollo/sudo/releases/latest/download/sudo' -o $PREFIX/bin/bsudo >/dev/null 2>&1
    chmod 700 "$PREFIX/bin/bsudo"
    printf "\r\033[K"
    echo -e "╬ ${GREEN}•${RESET} bSUDO updated.              [ ${GREEN}OK${RESET} ]"
    
    printf "╬ ${CYAN}[*]${RESET} Updating 1llicit Core...\r"
    local temp_core="$HOME/.1llicit/core.zsh.tmp"
    if curl -fsSL https://raw.githubusercontent.com/LbsLightX/1llicit/main/core.zsh > "$temp_core"; then
        mv "$temp_core" "$HOME/.1llicit/core.zsh"
        printf "\r\033[K"
        echo -e "╬ ${GREEN}•${RESET} 1llicit Core updated.       [ ${GREEN}OK${RESET} ]"
    else
        rm -f "$temp_core"
        printf "\r\033[K"
        echo -e "╬ ${RED}•${RESET} Core update failed.         [ ${RED}ERROR${RESET} ]"
    fi
    
    echo "╬"
    echo -e "╚═══════════════════ ${GREEN}${BOLD}COMPLETE${RESET} ══════════════════ ❏"
    sleep 1

    # Reload
    clear
    exec zsh
}


# -----------------------------------------------------------------------------
# Finalization & Hooks
# -----------------------------------------------------------------------------

# Set default syntax theme
if command -v fast-theme >/dev/null 2>&1; then
    fast-theme zdharma >/dev/null 2>&1
fi


# User Customization Hook
if [[ -f "$HOME/.1llicit/user.zsh" ]]; then
    source "$HOME/.1llicit/user.zsh"
fi

# LbsLightX
