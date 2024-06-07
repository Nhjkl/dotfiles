alias vi=nvim
alias v=nvim
alias lz=lazygit
alias c=clear
alias s=fastfetch
alias q=exit
alias tk="tmux kill-server"
alias wttr="curl wttr.in"
alias pp='/home/sean/.local/src/password-store/pass-fzf.sh'
alias cz="git add .;git cz"
alias yarn='yarn --use-yarnrc "$XDG_CONFIG_HOME/yarn/config"'

if hash exa &>/dev/null; then
  alias l="exa -l -h -g -a --icons"
fi

r() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  command yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd < "$tmp"
  [ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
  rm -f -- "$tmp"
}

proxyOn() {
  export all_proxy=socks5://127.0.0.1:7890
  export http_proxy=http://127.0.0.1:7890
  export https_proxy=${http_proxy}
  export ALL_PROXY=${all_proxy}
  export HTTP_PROXY=${http_proxy}
  export HTTPS_PROXY=${https_proxy}
}

proxyOff() {
  unset all_proxy
  unset http_proxy
  unset https_proxy
  unset ALL_PROXY
  unset HTTP_PROXY
  unset HTTPS_PROXY
}

,touch () {
	mkdir -p "$(dirname "$1")" && touch "$1"
}

,vi () {
	mkdir -p "$(dirname "$1")" && nvim "$1"
}

,take () {
	mkdir -p "$(dirname "$1")" && take "$1"
}
