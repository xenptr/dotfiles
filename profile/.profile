# Prevent double-sourcing
[ -n "$__PROFILE_LOADED" ] && return
export __PROFILE_LOADED=1

# Systemd ssh-agent socket
export SSH_AUTH_SOCK=/run/user/$UID/ssh-agent.socket

# Auto-load ssh key once per login
if ! ssh-add -l >/dev/null 2>&1; then
  ssh-add ~/.ssh/id_ed25519_github >/dev/null 2>&1
fi

. "$HOME/.local/share/../bin/env"
