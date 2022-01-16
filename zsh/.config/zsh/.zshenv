[ -f "$HOME/.local/share/cargo/env" ] && source "$HOME/.local/share/cargo/env"

export GEM_HOME=$HOME/.gem
PATH="$(ruby -e 'print Gem.user_dir')/bin:$PATH"

[ -f "$HOME/.cache/tls/sslkeylog.log" ] && export SSLKEYLOGFILE=~/.cache/tls/sslkeylog.log
