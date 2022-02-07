#!/usr/bin/env bash

#=============================================================================
# install.sh --- bootstrap script for dotfiles
#=============================================================================

# Init option {{{
Color_off='\033[0m'       # Text Reset

# terminal color template {{{
# Regular Colors
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

# Bold
BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BBlue='\033[1;34m'        # Blue
BPurple='\033[1;35m'      # Purple
BCyan='\033[1;36m'        # Cyan
BWhite='\033[1;37m'       # White

# Underline
UBlack='\033[4;30m'       # Black
URed='\033[4;31m'         # Red
UGreen='\033[4;32m'       # Green
UYellow='\033[4;33m'      # Yellow
UBlue='\033[4;34m'        # Blue
UPurple='\033[4;35m'      # Purple
UCyan='\033[4;36m'        # Cyan
UWhite='\033[4;37m'       # White

# Background
On_Black='\033[40m'       # Black
On_Red='\033[41m'         # Red
On_Green='\033[42m'       # Green
On_Yellow='\033[43m'      # Yellow
On_Blue='\033[44m'        # Blue
On_Purple='\033[45m'      # Purple
On_Cyan='\033[46m'        # Cyan
On_White='\033[47m'       # White

# High Intensity
IBlack='\033[0;90m'       # Black
IRed='\033[0;91m'         # Red
IGreen='\033[0;92m'       # Green
IYellow='\033[0;93m'      # Yellow
IBlue='\033[0;94m'        # Blue
IPurple='\033[0;95m'      # Purple
ICyan='\033[0;96m'        # Cyan
IWhite='\033[0;97m'       # White

# Bold High Intensity
BIBlack='\033[1;90m'      # Black
BIRed='\033[1;91m'        # Red
BIGreen='\033[1;92m'      # Green
BIYellow='\033[1;93m'     # Yellow
BIBlue='\033[1;94m'       # Blue
BIPurple='\033[1;95m'     # Purple
BICyan='\033[1;96m'       # Cyan
BIWhite='\033[1;97m'      # White

# High Intensity backgrounds
On_IBlack='\033[0;100m'   # Black
On_IRed='\033[0;101m'     # Red
On_IGreen='\033[0;102m'   # Green
On_IYellow='\033[0;103m'  # Yellow
On_IBlue='\033[0;104m'    # Blue
On_IPurple='\033[0;105m'  # Purple
On_ICyan='\033[0;106m'    # Cyan
On_IWhite='\033[0;107m'   # White
# }}}

# version
Version='1.1.0'
#System name
System="$(uname -s)"

# }}}

# 需安装的软件列表
app_array=(
  "stow"
  "git"
  "python"
  "zsh"
  "nvim"
  # "ranger"
  "lazygit"
  # "tig"
  "neofetch"
  "fzf"
  "lf"
)

exitFlg=0

# need_cmd {{{
need_cmd () {
  if ! hash "$1" &>/dev/null; then
    error "需要 '$1' （找不到命令）"
    exit 1
  fi
}

check_cmd () {
  if ! hash "$1" &>/dev/null; then
    warn "${BIRed}您未安装 $1"
    exitFlg=1
  else
    success "${BIGreen}您已安装 $1";
  fi
}
# }}}

# success/info/error/warn {{{
msg() {
  printf '%b\n' "$1" >&2
}

success() {
  msg "${Green}[✔]${Color_off} ${1}${2}"
}

info() {
  msg "${Blue}[➭]${Color_off} ${1}${2}"
}

error() {
  msg "${Red}[✘]${Color_off} ${1}${2}"
  exit 1
}

warn () {
  msg "${Yellow}[⚠]${Color_off} ${1}${2}"
}
# }}}

# echo_with_color {{{
echo_with_color () {
  printf '%b\n' "$1$2$Color_off" >&2
}
# }}}

# welcome {{{
welcome () {
  echo_with_color ${Yellow} "      _       _    __ _ _            "
  echo_with_color ${Yellow} "   __| | ___ | |_ / _(_) | ___  ___  "
  echo_with_color ${Yellow} "  / _| |/ _ \| __| |_| | |/ _ \/ __| "
  echo_with_color ${Yellow} " | (_| | (_) | |_|  _| | |  __/\__ \ "
  echo_with_color ${Yellow} "  \__,_|\___/ \__|_| |_|_|\___||___/ "
  echo_with_color ${Yellow} "                                     "
  echo_with_color ${Yellow} " 版本 : ${Version}                   "
}
# }}}

check_app_setup () {
  echo_with_color ${Yellow} "==================================================================="
  echo_with_color ${Yellow} "为您检测开发环境所需软件"
  echo_with_color ${Yellow} "-------------------------------------------------------------------"

  for((i=0;i<${#app_array[@]};i++)) do
    check_app ${app_array[i]};
  done;

  echo_with_color ${Yellow} "检测完毕"
  echo_with_color ${Yellow} "==================================================================="

  if [ $exitFlg == 1 ]; then
    error "请按安装缺失的软件"
  fi
}

check_app () {
  info "正在检测是否存在 $1";
  check_cmd $1;
  echo_with_color ${Yellow} "-------------------------------------------------------------------"
}

gen_ln () {
  echo_with_color ${Yellow} ""
  echo_with_color ${Yellow} ""
  echo_with_color ${Yellow} "正在创建软链接..."

  stow zsh;
  stow starship;
  stow vim;
  stow wallpapers;
  stow x11;
  stow linux-bin;
  stow linux-profile;
  stow alacritty;
  stow dwm;
  stow fontconfig;
  stow fonts;
  stow git;
  stow lazygit;
  stow lf;
  stow npm;
  stow picom;
  stow rofi;

  echo_with_color ${Yellow} "创建完毕!"
}

### main {{{
main () {
  welcome
  check_app_setup
  gen_ln
}
# }}}

main $@
