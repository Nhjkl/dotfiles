unset NPM_CONFIG_TMP
[[ -s "$HOME/.local/share/bun/_bun" ]] && source "$HOME/.local/share/bun/_bun"
[[ -d "$HOME/.local/share/npm/bin" ]] && path=("$HOME/.local/share/npm/bin" $path)
[[ -d "$HOME/.local/share/bun/bin" ]] && path=("$HOME/.local/share/bun/bin" $path)
[[ -f "$HOME/.vite-plus/env" ]] && source "$HOME/.vite-plus/env"
