alias vi=nvim
alias v=nvim
alias lz=lazygit
alias c=clear
alias r=ranger
alias s=neofetch
alias q=exit
alias wttr="curl wttr.in"
alias cz="git add .;git cz"
alias proxyOn="export ALL_PROXY=socks5://127.0.0.1:1080"
alias proxyOff="unset ALL_PROXY"

if hash exa &>/dev/null; then
  alias l="exa -l -h -g -a --icons"
fi

# work
if [ -f ~/.ssh/login ] ; then
  alias jumpzm=~/.ssh/login
fi
