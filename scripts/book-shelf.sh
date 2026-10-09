#!/usr/bin/env bash
set -euo pipefail

BOOK_DIR="$HOME/Books"
EXTENSIONS='pdf|epub|djvu|cbr|cbz|md|txt'

[ ! -d "$BOOK_DIR" ] && exit 1

# Gather files sorted by modification time (most recent first)
# Maps relative paths for Rofi display while keeping full paths for execution
mapfile -t FULL_PATHS < <(
    find "$BOOK_DIR" -type f -regextype posix-extended -iregex ".*\.(${EXTENSIONS})$" -printf "%T@\t%p\n" 2>/dev/null \
    | sort -rn \
    | cut -f2-
)

[ "${#FULL_PATHS[@]}" -eq 0 ] && exit 0

# Strip BOOK_DIR prefix for cleaner reading in Rofi
DISPLAY_NAMES=()
for path in "${FULL_PATHS[@]}"; do
    DISPLAY_NAMES+=("${path#"$BOOK_DIR"/}")
done

# Show relative paths in Rofi; return the selected line index (0-based)
SELECTED_INDEX=$(
    printf '%s\n' "${DISPLAY_NAMES[@]}" \
    | rofi -dmenu -i -p "󰂱 Books" -format i -lines 12 -width 60
)

# Exit if cancelled (empty string returned)
[ -z "$SELECTED_INDEX" ] && exit 0

SELECTED_FILE="${FULL_PATHS[$SELECTED_INDEX]}"

# Launch viewers detached from the launcher process
case "${SELECTED_FILE##*.}" in
    md|txt)
        uwsm app -- kitty --class floating-notes -e env NVIM_APPNAME=nvim-notes nvim "$SELECTED_FILE" &
        ;;
    epub)
        # Foliate handles reflowable text much better than Zathura if installed; fallback to zathura
        if command -v foliate >/dev/null 2>&1; then
            uwsm app -- foliate "$SELECTED_FILE" &
        else
            uwsm app -- zathura "$SELECTED_FILE" &
        fi
        ;;
    *)
        uwsm app -- zathura "$SELECTED_FILE" &
        ;;
esac
