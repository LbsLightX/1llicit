#!/usr/bin/env bash

_require () {
    for pkg in "$@"
    do
        command -v $pkg >/dev/null 2>&1 || { echo >&2 "I require '$pkg' but it's not installed. Aborting."; exit 1; }
    done
}
_require jq curl fzf

# Check connection to your own repository
status_code=$(curl -s -o /dev/null -I -w "%{http_code}" "https://github.com/LbsLightX/1llicit")
if [ "$status_code" -eq "200" ]; then
    echo "Fetching fonts list from repository, please wait."
    declare -A fonts
    while IFS= read -r entry
    do
        fonts+=(["$(basename "$entry")"]="$entry")
    done < <(curl -fSsL https://api.github.com/repos/ryanoasis/nerd-fonts/git/trees/master?recursive=1 | jq -r '.tree[] | select(.path|match("^patched-fonts/.*\\.(ttf)$","i")) | select(.path|contains("Windows Compatible")|not) | .url="https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/" + .path | .url')
    choice=$(printf "%s\n" "${!fonts[@]}" | sort | fzf)
    if [ $? -eq 0 ]; then
        echo "Applying font: $choice"
        mkdir -p ~/.termux
        if curl -fsSL "$( echo "${fonts[$choice]}" | sed 's/ /%20/g' )" -o ~/.termux/font.ttf; then
            termux-reload-settings
            if [ $? -ne 0 ]; then
                echo "Failed to apply font."
            fi
        else
            echo "Failed to download font."
        fi
    else
        echo "Cancelled fonts selection."
    fi
else
    echo "Make sure you're connected to the internet!"
    exit 1
fi
