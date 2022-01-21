# Cargo
[ -f "$CARGO_HOME/env" ] && source "$CARGO_HOME/env"

# GEM
PATH="$(ruby -e 'print Gem.user_dir')/bin:$PATH"

# nvm
nvm() {
  . "$NVM_DIR/nvm.sh" ; nvm $@ ;
}
export PATH=$NVM_DIR/versions/node/v16.13.2/bin/:$PATH
export NVM_NODEJS_ORG_MIRROR=http://npm.taobao.org/mirrors/node

