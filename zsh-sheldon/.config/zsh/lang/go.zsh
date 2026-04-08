export CGO_ENABLED=1
export GOPROXY=https://goproxy.cn,direct
[[ -d "$GOPATH/bin" ]] && path=("$GOPATH/bin" $path)
