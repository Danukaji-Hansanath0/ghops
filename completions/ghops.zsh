#compdef ghops

_ghops() {
    local -a opts
    opts=(
        '-h[Show help]'
        '--help[Show help]'
        '-v[Show version]'
        '--version[Show version]'
    )
    _arguments $opts
}

_ghops "$@"
