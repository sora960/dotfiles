# ~/.bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# --- XDG Base Directories Defaults ---
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

# --- Environment Variables ---
export EDITOR='nvim'
export MOZ_ENABLE_WAYLAND=1
export MOZ_CRASHREPORTER_DISABLE=1
export GTK_THEME="Adwaita:dark"
export NO_AT_BRIDGE=1

# --- PATH Additions ---
export PATH="$HOME/dotfiles/scripts:$PATH"
export PATH="$HOME/.config/composer/vendor/bin:$PATH"
export PATH="$PATH:/home/lucy/.lmstudio/bin"

# --- Aliases ---
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias clear='printf "\033[2J\033[3J\033[H"'
alias check-corrupt="sudo pacman -Qkk 2>&1 | grep '(SHA256 checksum mismatch)' | grep -v 'backup file:'"

# --- tmux short-keybinds ---
t() {
    if [ -z "$TMUX" ]; then
        tmux attach-session || tmux new-session
    fi
}

tn() {
    tmux new-session -d -s "$1"
    tmux switch-client -t "$1"
}

alias tt='tmux choose-tree'


# --- Prompt ---
PS1='[\u@\h \W]\$ '

# --- Tools & Integrations ---
# Zoxide
eval "$(zoxide init bash)"

# fzf + fd integration
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --exclude .git --exclude node_modules'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --strip-cwd-prefix --hidden --exclude .git --exclude node_modules'
eval "$(fzf --bash)"

# Yazi wrapper (cd into folder on exit)
function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}
