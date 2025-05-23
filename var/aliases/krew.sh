command -v kubectl >/dev/null && {
# load Krew plugin manager if available
        test -d $HOME/.krew \
                && export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
}
