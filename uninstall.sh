#!/usr/bin/env bash

# 1llicit Uninstaller
# "True Gold" Edition

echo -e "\n  ╭── \033[1;31mUNINSTALL 1LLICIT\033[0m ☠  ──"
echo "│"
echo "│ ☠  WARNING: This will remove 1llicit configuration."
echo "│    Your original .zshrc will be restored."
echo "│"
echo -n "│ ◷ Are you sure? (y/N) " 
read -n 1 -r REPLY
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "│ ⚠ Aborted."
    echo "╰──────────────────────"
    exit 1
fi

echo "│"

# 2. Find Backup
BACKUP_DIR="$HOME/storage/shared/1llicit/backup"
if [ -d "$BACKUP_DIR" ]; then
    # Find the newest directory inside backup
    LATEST_BACKUP=$(ls -td "$BACKUP_DIR"/*/ 2>/dev/null | head -1)
    
    if [ -n "$LATEST_BACKUP" ] && [ -f "${LATEST_BACKUP}.zshrc" ]; then
        printf "│ ◷ Found backup: $(basename $LATEST_BACKUP)\r"
        sleep 0.5
        cp -f "${LATEST_BACKUP}.zshrc" "$HOME/.zshrc"
        printf "│ ⊕ Original configuration restored.          \n"
    else
        echo "│ ✕ No .zshrc backup found in $LATEST_BACKUP"
        echo "│   Hint: Check $BACKUP_DIR manually."
    fi
else
    echo "│ ✕ No backup directory found at $BACKUP_DIR"
    echo "│   Skipping restore."
fi

# 3. Cleanup 1llicit Core files
if [ -d "$HOME/.1llicit" ]; then
    rm -rf "$HOME/.1llicit"
    echo "│ ⊕ Removed 1llicit core files."
fi

# 4. Optional Cleanup (Storage)
echo "│"
echo -n "│ ◷ Remove backup folder? (y/N) "
read -n 1 -r REPLY
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    rm -rf "$HOME/storage/shared/1llicit"
    echo "│ ⊕ Backups removed."
fi

# 5. Shell Reset
echo "│"
echo -n "│ ◷ Switch default shell back to Bash? (y/N) "
read -n 1 -r REPLY
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    chsh -s bash
    echo "│ ⊕ Shell switched to Bash."
fi

echo "│"
echo "│ ◷ Uninstall complete. Please restart Termux."
echo "╰──────────────────────"
