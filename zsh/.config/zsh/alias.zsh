alias vi=nvim
alias v=nvim
alias lz=lazygit
alias c=clear
# alias r=ranger
alias r=lfrun
alias s=neofetch
alias q=exit
alias wttr="curl wttr.in"
alias cz="git add .;git cz"
# alias proxyOn="export ALL_PROXY=socks5://127.0.0.1:1080"
alias proxyOn="export ALL_PROXY=http://127.0.0.1:8899"
alias proxyOff="unset ALL_PROXY"

alias pathList='echo -e ${PATH//:/\\n}'
alias reloadShell="exec ${SHELL} -l"
alias bravekill="ps ux | grep 'Brave Helper --type=renderer' | grep -v extension-process | tr -s ' ' | cut -d ' ' -f2 | xargs kill"

if hash exa &>/dev/null; then
  alias l="exa -l -h -g -a --icons"
fi

# work
if [ -f ~/.ssh/login ] ; then
  alias jumpzm=~/.ssh/login
fi
