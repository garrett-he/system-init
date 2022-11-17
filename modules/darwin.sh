if [[ $(arch) == "arm64" ]]; then
    SYSINIT_DARWIN_HOMEBREW_PREFIX="/opt/homebrew"
else
    SYSINIT_DARWIN_HOMEBREW_PREFIX="/usr/local"
fi

module_darwin_homebrew() {
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

module_darwin_homebrew_packages() {
    $SYSINIT_DARWIN_HOMEBREW_PREFIX/bin/brew install coreutils gnu-sed gnu-tar findutils jq wget

    sysinit_append_shell_profile 'export PATH="'$SYSINIT_DARWIN_HOMEBREW_PREFIX'/opt/coreutils/libexec/gnubin:$PATH"'
    sysinit_append_shell_profile 'export PATH="'$SYSINIT_DARWIN_HOMEBREW_PREFIX'/opt/gnu-sed/libexec/gnubin:$PATH"'
    sysinit_append_shell_profile 'export PATH="'$SYSINIT_DARWIN_HOMEBREW_PREFIX'/opt/gnu-tar/libexec/gnubin:$PATH"'
    sysinit_append_shell_profile 'export PATH="'$SYSINIT_DARWIN_HOMEBREW_PREFIX'/opt/findutils/libexec/gnubin:$PATH"'
}
