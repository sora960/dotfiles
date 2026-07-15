#!/bin/bash
# 1. Sync the files to the live system
sudo cp -r ~/dotfiles/sddm/lucy/* /usr/share/sddm/themes/lucy/
echo "✔️ Files synced to /usr/share/sddm/themes/lucy/"

# 2. Launch the test window automatically
echo "🚀 Launching SDDM Test Mode..."
QT_QPA_PLATFORM=xcb sddm-greeter --test-mode --theme /usr/share/sddm/themes/lucy
