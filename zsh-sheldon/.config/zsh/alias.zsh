alias v=nvim
alias c=clear
alias q=exit
alias yarn='yarn --use-yarnrc "${XDG_CONFIG_HOME:-$HOME/.config}/yarn/config"'

if hash eza &>/dev/null; then
  alias l="eza -l -h -g -a --icons"
elif hash exa &>/dev/null; then
  alias l="exa -l -h -g -a --icons"
fi

s () {
  fastfetch
}

r() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  command yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd < "$tmp"
  [[ "$cwd" != "$PWD" ]] && [[ -d "$cwd" ]] && builtin cd -- "$cwd"
  rm -f -- "$tmp"
}

,proxy() {
  if (( ${+http_proxy} )); then
    unset all_proxy http_proxy https_proxy ALL_PROXY HTTP_PROXY HTTPS_PROXY
    echo "proxy off"
  else
    export all_proxy=socks5://127.0.0.1:7890
    export http_proxy=http://127.0.0.1:7890
    export https_proxy=${http_proxy}
    export ALL_PROXY=${all_proxy}
    export HTTP_PROXY=${http_proxy}
    export HTTPS_PROXY=${https_proxy}
    echo "proxy on"
  fi
}

,touch () {
	mkdir -p "$(dirname "$1")" && touch "$1"
}

,vi () {
	mkdir -p "$(dirname "$1")" && nvim "$1"
}

,take () {
	mkdir -p "$1" && builtin cd "$1"
}

,cc () {
  claude --dangerously-skip-permissions
}

,t () {
  tmux-sessionizer
}

,tk () {
  tmux kill-server
}

,p () {
  ~/.local/share/password-store/pass-fzf.sh
}

,lz () {
  lazygit
}

,ld () {
  lazydocker
}

,wttr () {
  curl wttr.in
}
