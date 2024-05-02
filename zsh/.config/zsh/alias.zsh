alias vi=nvim
alias v=nvim
alias lz=lazygit
alias c=clear
# alias r=ranger
# alias r=lfrun
alias r=yazi
alias s=neofetch
alias q=exit
alias tk="tmux kill-server"
alias wttr="curl wttr.in"
alias cz="git add .;git cz"
alias yarn='yarn --use-yarnrc "$XDG_CONFIG_HOME/yarn/config"'

alias pathList='echo -e ${PATH//:/\\n}'
alias reloadShell="exec ${SHELL} -l"
alias bravekill="ps ux | grep 'Brave Helper --type=renderer' | grep -v extension-process | tr -s ' ' | cut -d ' ' -f2 | xargs kill"

if hash exa &>/dev/null; then
  alias l="exa -l -h -g -a --icons"
fi

proxyOn() {
  export all_proxy=socks5://192.168.100.1:7891
  export http_proxy=http://192.168.100.1:7890
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
