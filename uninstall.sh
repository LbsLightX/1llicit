#!/usr/bin/env bash

# 1. Verification
echo "⚠️  WARNING: This will uninstall 1llicit configuration."
read -p "Are you sure? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 1
fi

# 2. Find Backup
BACKUP_DIR="$HOME/storage/shared/1llicit/backup"
if [ -d "$BACKUP_DIR" ]; then
    # Find the newest directory inside backup (the one most recently created)
    LATEST_BACKUP=$(ls -td "$BACKUP_DIR"/*/ 2>/dev/null | head -1)
    
    if [ -n "$LATEST_BACKUP" ] && [ -f "${LATEST_BACKUP}.zshrc" ]; then
        echo "Found backup at: $LATEST_BACKUP"
        echo "Restoring .zshrc..."
        cp -f "${LATEST_BACKUP}.zshrc" "$HOME/.zshrc"
        echo "✅ Original configuration restored."
    else
        echo "❌ No .zshrc backup found in $LATEST_BACKUP"
        echo "Hint: Check $BACKUP_DIR manually for your old files."
    fi
else
    echo "❌ No backup directory found at $BACKUP_DIR"
    echo "Skipping restore."
fi

# 3. Optional Cleanup
read -p "Do you want to remove the 1llicit backup folder? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    rm -rf "$HOME/storage/shared/1llicit"
    echo "Backups removed."
fi

# 4. Shell Reset
read -p "Do you want to switch default shell back to Bash? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    chsh -s bash
    echo "Shell switched to Bash."
fi

echo "Uninstall complete. Please restart Termux."
