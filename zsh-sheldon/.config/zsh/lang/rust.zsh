export CARGO_HOME="${CARGO_HOME:-$HOME/.cargo}"
export RUSTUP_DIST_SERVER=https://mirrors.sjtug.sjtu.edu.cn/rust-static
export RUSTUP_UPDATE_ROOT=https://mirrors.sjtug.sjtu.edu.cn/rust-static/rustup
[[ -f "$CARGO_HOME/env" ]] && source "$CARGO_HOME/env"
[[ -d "$CARGO_HOME/bin" ]] && path=("$CARGO_HOME/bin" $path)
