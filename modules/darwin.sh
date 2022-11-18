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

module_darwin_python() {
    $SYSINIT_DARWIN_HOMEBREW_PREFIX/bin/brew install python

    sysinit_append_shell_profile 'export PATH="'$SYSINIT_DARWIN_HOMEBREW_PREFIX'/opt/python/libexec/bin:$PATH"'
}

module_darwin_lua() {
    $SYSINIT_DARWIN_HOMEBREW_PREFIX/bin/brew install lua luarocks

    sysinit_append_shell_profile 'export PATH="$HOME/.luarocks/bin:$PATH"'
}

module_darwin_php() {
    $SYSINIT_DARWIN_HOMEBREW_PREFIX/bin/brew install php
}

module_darwin_preferences() {
    defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
    defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

    defaults write com.apple.screencapture location ~/Pictures
    killall SystemUIServer
}
