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
# 2. Plugins (Syntax Highlighting, Autosuggestions)
# -----------------------------------------------------------------------------
zinit wait lucid light-mode for \
  atinit"ZINIT[COMPINIT_OPTS]=-C; zpcompinit; zpcdreplay" \
      zdharma-continuum/fast-syntax-highlighting \
      OMZP::colored-man-pages \
      OMZP::git \
  atload"!_zsh_autosuggest_start" \
      zsh-users/zsh-autosuggestions \
  blockf atpull'zinit creinstall -q .' \
      zsh-users/zsh-completions

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
# 5. Custom Functions
# -----------------------------------------------------------------------------

function lit-colors() {
    # Check connection
    if [ $(curl -s -o /dev/null -I -w "%{http_code}" https://raw.githubusercontent.com/LbsLightX/1llicit-colors/main/install.sh) -eq 200 ]; then
        echo "Loading color scheme menu, please wait."
        bash -c "$(curl -fsSL 'https://raw.githubusercontent.com/LbsLightX/1llicit-colors/main/install.sh')"
        clear
    else
        echo "Can't connect to color schemes repository."
    fi
}

function lit-fonts() {
    # 1. Dependency Check
    for pkg in jq curl fzf; do
        if ! command -v $pkg >/dev/null 2>&1; then
            echo "Installing missing dependency: $pkg"
            pkg install -y $pkg
        fi
    done

    CACHE_FILE="$HOME/.1llicit/fonts.cache"
    
    # 2. Update Cache Logic (Force update if argument --update is passed)
    if [[ ! -f "$CACHE_FILE" ]] || [[ "$1" == "--update" ]]; then
        echo "Fetching fonts list from repository (Stable v3.4.0)... please wait, this may take 1-2 minutes."
        
        # Check connection before trying to download
        status_code=$(curl -s -o /dev/null -I -w "%{http_code}" "https://github.com/LbsLightX/1llicit")
        if [ "$status_code" -ne "200" ]; then
             echo " 🌐 Please check your internet/ dns and try again."
             return 1
        fi

        # Download and Parse to Cache File
        # Format: "Filename|URL" (We use | as delimiter)
        curl -fSsL "https://api.github.com/repos/ryanoasis/nerd-fonts/git/trees/v3.4.0?recursive=1" | \
        jq -r '.tree[] | select(.path|match("^patched-fonts/.*\\.(ttf|otf)$","i")) | select(.path|contains("Windows Compatible")|not) | .url="https://raw.githubusercontent.com/ryanoasis/nerd-fonts/v3.4.0/" + .path | .path + "|" + .url' \
        > "$CACHE_FILE"
        
        echo "✅ Cache updated."
    fi

    # 3. Read from Cache
    typeset -A fonts
    while IFS="|" read -r path url
    do
        name=$(basename "$path")
        fonts[$name]="$url"
    done < "$CACHE_FILE"

    # 4. Display Menu
    choice=$(printf "%s\n" "${(@k)fonts}" | sort | fzf)
    
    if [ $? -eq 0 ]; then
        echo "✨ Applying font: $choice"
        mkdir -p ~/.termux
        # Retrieve URL from array
        if curl -fsSL "$( echo "${fonts[$choice]}" | sed 's/ /%20/g' )" -o ~/.termux/font.ttf; then
            termux-reload-settings
            if [ $? -ne 0 ]; then
                echo "❌ Failed to apply font."
            fi
        else
            echo " 🚫 Failed to download font."
        fi
    else
        echo "⚠️ Cancelled fonts selection."
    fi
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
    
    echo "Updated successfully, enjoy!"
    sleep 2
    clear
    exec zsh
}

# -----------------------------------------------------------------------------
# 6. Aliases
# -----------------------------------------------------------------------------
alias fetch='fastfetch'
