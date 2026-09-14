[ -f ~/.profile ] && source ~/.profile

# --- Prompt ---
eval "$(starship init zsh)"

# --- mise ---
if command -v mise &> /dev/null; then
  # export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$HOME/.local/share/omarchy/bin:$PATH"
  eval "$(mise activate zsh)"
fi

# --- fzf and zoxide integration ---
if command -v fzf >/dev/null 2>&1; then
  eval "$(fzf --zsh)"
fi

if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init --cmd cd zsh)"
fi

# --- Zinit Plugin Manager ---
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

# --- Completion ---
autoload -Uz compinit
compinit -d ~/.zcompdump-$HOST

# --- Plugins via zinit ---
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions
zinit light Aloxaf/fzf-tab
zinit light zsh-users/zsh-syntax-highlighting

# --- History ---
HISTFILE=~/.histfile
HISTSIZE=32768
SAVEHIST=$HISTSIZE
HISTDUP=erase

# History behavior options
setopt APPEND_HISTORY           # append to the history file, don’t overwrite it
setopt INC_APPEND_HISTORY       # write commands to history file immediately
setopt SHARE_HISTORY            # share command history across all sessions
setopt HIST_IGNORE_ALL_DUPS     # ignore duplicate commands in history
setopt HIST_IGNORE_SPACE        # don't record commands that start with a space
setopt HIST_SAVE_NO_DUPS        # don't write duplicate entries to the history file
setopt HIST_FIND_NO_DUPS        # do not display duplicates during history search
setopt HIST_REDUCE_BLANKS       # remove extra spaces from commands

# --- Zsh Options ---
setopt autocd extendedglob nomatch

# Use Emacs-style keybindings
bindkey -e

# --- Completion styling ---
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color "$realpath"'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color "$realpath"'
zstyle ':completion:*' mark-symlinked-directories yes
zstyle ':completion:*' match-hidden-files false
zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'


# --- Aliases ---
if command -v eza >/dev/null 2>&1; then
  alias ls='eza --color=always --group-directories-first --icons=auto'
  alias ll='ls -lh'
  alias la='ls -lah'
  alias lt='eza --tree --level=2 --long --icons --git'
  alias lta='lt -a'
fi

alias ff="fzf --preview 'bat --style=numbers --color=always {}'"

if command -v zoxide &> /dev/null; then
  alias cd="zd"
  zd() {
    if [ $# -eq 0 ]; then
      builtin cd ~ && return
    elif [ -d "$1" ]; then
      builtin cd "$1"
    else
      z "$@" && printf "\U000F17A9 " && pwd || echo "Error: Directory not found"
    fi
  }
fi

new_tmux () {
  session_dir=$(zoxide query --list | fzf)
  session_name=$(basename "$session_dir")

  if tmux has-session -t $session_name 2>/dev/null; then
    if [ -n "$TMUX" ]; then
      tmux switch-client -t "$session_name"
    else
      tmux attach -t "$session_name"
    fi
    notification="tmux attached to $session_name"
  else
    if [ -n "$TMUX" ]; then
      tmux new-session -d -c "$session_dir" -s "$session_name" && tmux switch-client -t "$session_name"
      notification="new tmux session INSIDE TMUX: $session_name"
    else
      tmux new-session -c "$session_dir" -s "$session_name"
      notification="new tmux session: $session_name"
    fi
  fi

  if [ -s "$session_name" ]; then
    notify-send "$notification"
  fi
}

alias tm=new_tmux

yank_path() {
  local target="${1:-.}"
  local abs

  abs=$(realpath "$target") || {
    echo "Error: '$target' does not exist." >&2
    return 1
  }

  printf "%s" "$abs" | wl-copy
}

alias yp=yank_path

# Open file/URL in default app (background)
open() {
  xdg-open "$@" >/dev/null 2>&1 &
}

# --- Common navigation ---
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# --- Tools ---
alias grep='grep --color=auto'
alias diff='diff --color=auto'
alias ip='ip -c=auto'
alias df='df -h'
alias du='du -h'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias vim='nvim'
alias c='clear'
n() { if [ "$#" -eq 0 ]; then nvim .; else nvim "$@"; fi; } # Open Neovim n current dir or specific file

# --- Git ---
alias g='git'
alias gcm='git commit -m'
alias gcam='git commit -a -m'
alias gcad='git commit -a --amend'

# --- Keybindings ---
bindkey '^R' history-incremental-search-backward
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

# --- Environment Variables ---
export EDITOR="nvim"
export VISUAL="$EDITOR"
export SUDO_EDITOR="$EDITOR"
export BAT_THEME=ansi
export PAGER="less"

# --- Doom Emacs ---
export PATH="$HOME/.config/emacs/bin:$PATH"

# --- Golang ---
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
export PATH="$GOBIN:$PATH"

[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"

. "$HOME/.local/share/../bin/env"
