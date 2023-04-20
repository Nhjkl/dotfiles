#                 ██
#                ░██
#  ██████  ██████░██      ██████  █████
# ░░░░██  ██░░░░ ░██████ ░░██░░█ ██░░░██
#    ██  ░░█████ ░██░░░██ ░██ ░ ░██  ░░
#   ██    ░░░░░██░██  ░██ ░██   ░██   ██
#  ██████ ██████ ░██  ░██░███   ░░█████
# ░░░░░░ ░░░░░░  ░░   ░░ ░░░     ░░░░░


source "$ZDOTDIR/init.zsh"      # zshinit
source "$ZDOTDIR/ohmyzsh.zsh"   # ohmyzsh
# source "$ZDOTDIR/zap.zsh"       # zap
source "$ZDOTDIR/vimode.zsh"    # zshvimode 必须放在ohmyzsh后面
source "$ZDOTDIR/alias.zsh"     # zshalias
source "$ZDOTDIR/bindkey.zsh"   # zshbindKey
source "$ZDOTDIR/config.zsh"    # zshconf


# bun completions
export BUN_INSTALL="$HOME/.bun" 
export PATH="$BUN_INSTALL/bin:$PATH" 
[ -s "/home/lx/.bun/_bun" ] && source "/home/lx/.bun/_bun"
