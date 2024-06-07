export PYENV_ROOT="${XDG_DATA_HOME:-$HOME/.local/share}/pyenv"
pyenv() {
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
  unfunction pyenv
  pyenv "$@"
}
[[ -d "$PYENV_ROOT/bin" ]] && path=("$PYENV_ROOT/bin" $path)
