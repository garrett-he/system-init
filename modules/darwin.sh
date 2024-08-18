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
