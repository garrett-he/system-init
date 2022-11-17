if [[ $(arch) == "arm64" ]]; then
    SYSINIT_DARWIN_HOMEBREW_PREFIX="/opt/homebrew"
else
    SYSINIT_DARWIN_HOMEBREW_PREFIX="/usr/local"
fi

module_darwin_homebrew() {
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}
