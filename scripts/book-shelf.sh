#!/usr/bin/env bash

# Source folder
BOOK_DIR="$HOME/Books"

# Supported extensions
EXTENSIONS="pdf|epub|djvu|cbr|cbz|md|txt"

# Select file via Rofi showing only clean file names
SELECTED_FILE=$(find "$BOOK_DIR" -type f 2>/dev/null | grep -Ei "\.(${EXTENSIONS})$" | rofi -dmenu -i -p "Books: ")

# Exit if cancelled
[ -z "$SELECTED_FILE" ] && exit 0

# Check file extension and launch the appropriate viewer
case "$SELECTED_FILE" in
    *.md|*.txt)
        # Open plaintext / markdown notes in the stripped floating Neovim
        uwsm app -- kitty --class floating-notes -e env NVIM_APPNAME=nvim-notes nvim "$SELECTED_FILE"
        ;;
    *)
        # Open PDF, EPUB, DJVU, and Comic formats in stripped floating Zathura
        uwsm app -- zathura "$SELECTED_FILE"
        ;;
esac
