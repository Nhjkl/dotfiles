#                 ██
#                ░██
#  ██████  ██████░██      ██████  █████
# ░░░░██  ██░░░░ ░██████ ░░██░░█ ██░░░██
#    ██  ░░█████ ░██░░░██ ░██ ░ ░██  ░░
#   ██    ░░░░░██░██  ░██ ░██   ░██   ██
#  ██████ ██████ ░██  ░██░███   ░░█████
# ░░░░░░ ░░░░░░  ░░   ░░ ░░░     ░░░░░
#
# History in cache directory:
source $ZDOTDIR/zshinit

HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.cache/zsh/history
setopt no_nomatch
setopt hist_ignore_all_dups hist_save_nodups
DISABLE_MAGIC_FUNCTIONS=true

plugins=(
  git
  npm
  # pnpm
  pip
  yarn
  vi-mode
)

source $ZSH/oh-my-zsh.sh

# common {{{
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
# }}}

# work
if [ -f ~/.ssh/login ] ; then
  alias jumpzm=~/.ssh/login
fi

# zshvimode
source "$ZDOTDIR/zshvimode"

# Load syntax highlighting; should be last.
source $ZSH/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh 2>/dev/null
source $ZSH/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null

eval "$(starship init zsh)"
# eval "$(thefuck --alias)"
