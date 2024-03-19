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
alias proxyOn="export ALL_PROXY=socks5://192.168.100.1:7891"
alias proxyOff="unset ALL_PROXY"
alias yarn='yarn --use-yarnrc "$XDG_CONFIG_HOME/yarn/yarnrc"'

alias pathList='echo -e ${PATH//:/\\n}'
alias reloadShell="exec ${SHELL} -l"
alias bravekill="ps ux | grep 'Brave Helper --type=renderer' | grep -v extension-process | tr -s ' ' | cut -d ' ' -f2 | xargs kill"

if hash exa &>/dev/null; then
  alias l="exa -l -h -g -a --icons"
fi

,touch () {
	mkdir -p "$(dirname "$1")" && touch "$1"
}

,vi () {
	mkdir -p "$(dirname "$1")" && nvim "$1"
}

,take () {
	mkdir -p "$(dirname "$1")" && take "$1"
}
