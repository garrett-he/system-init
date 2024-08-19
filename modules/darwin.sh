if [[ $(arch) == "arm64" ]]; then
    SYSINIT_DARWIN_HOMEBREW_PREFIX="/opt/homebrew"
else
    SYSINIT_DARWIN_HOMEBREW_PREFIX="/usr/local"
fi

module_darwin_homebrew() {
    export HOMEBREW_API_DOMAIN="${SYSINIT_MIRROR_HOMEBREW_API_DOMAIN-}"
    export HOMEBREW_BOTTLE_DOMAIN="${SYSINIT_MIRROR_HOMEBREW_BOTTLE_DOMAIN-}"
    export HOMEBREW_BREW_GIT_REMOTE="${SYSINIT_MIRROR_HOMEBREW_BREW_GIT_REMOTE-}"
    export HOMEBREW_CORE_GIT_REMOTE="${SYSINIT_MIRROR_HOMEBREW_CORE_GIT_REMOTE-}"
    export HOMEBREW_PIP_INDEX_URL="${SYSINIT_MIRROR_PYPI_INDEX-}"

    if [[ -z "${SYSINIT_MIRROR_HOMEBREW_INSTALL_GIT_REMOTE-}" ]]; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        git clone "$SYSINIT_MIRROR_HOMEBREW_INSTALL_GIT_REMOTE" /tmp/brew-install
        /bin/bash /tmp/brew-install/install.sh
        rm -rf /tmp/brew-install
    fi

    utils::append_profiles
    utils::append_profiles '# darwin_homebrew'
    utils::append_profiles "export HOMEBREW_API_DOMAIN=$HOMEBREW_API_DOMAIN"
    utils::append_profiles "export HOMEBREW_BOTTLE_DOMAIN=$HOMEBREW_BOTTLE_DOMAIN"
    utils::append_profiles "export HOMEBREW_BREW_GIT_REMOTE=$HOMEBREW_BREW_GIT_REMOTE"
    utils::append_profiles "export HOMEBREW_CORE_GIT_REMOTE=$HOMEBREW_CORE_GIT_REMOTE"
    utils::append_profiles "export HOMEBREW_PIP_INDEX_URL=$HOMEBREW_PIP_INDEX_URL"
}

module_darwin_homebrew_packages() {
    $SYSINIT_DARWIN_HOMEBREW_PREFIX/bin/brew install coreutils gnu-sed gnu-tar findutils jq wget

    utils::append_profiles
    utils::append_profiles '# darwin_homebrew_packages'
    utils::append_profiles 'export PATH="'$SYSINIT_DARWIN_HOMEBREW_PREFIX'/opt/coreutils/libexec/gnubin:$PATH"'
    utils::append_profiles 'export PATH="'$SYSINIT_DARWIN_HOMEBREW_PREFIX'/opt/gnu-sed/libexec/gnubin:$PATH"'
    utils::append_profiles 'export PATH="'$SYSINIT_DARWIN_HOMEBREW_PREFIX'/opt/gnu-tar/libexec/gnubin:$PATH"'
    utils::append_profiles 'export PATH="'$SYSINIT_DARWIN_HOMEBREW_PREFIX'/opt/findutils/libexec/gnubin:$PATH"'
}

module_darwin_python() {
    $SYSINIT_DARWIN_HOMEBREW_PREFIX/bin/brew install python

    utils::append_profiles
    utils::append_profiles '# darwin_python'
    utils::append_profiles 'export PATH="'$SYSINIT_DARWIN_HOMEBREW_PREFIX'/opt/python/libexec/bin:$PATH"'
}
