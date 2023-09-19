module_dotfiles() {
    sysinit::git_clone https://github.com/garrett-he/dotfiles.git ~/.dotfiles SYSINIT_MIRROR_DOTFILES_GIT_REMOTE

    cd ~/.dotfiles
    git submodule init
    git submodule update
    ./install.sh
}

module_zsh() {
    # Install ohmyzsh
    if [[ -z "${SYSINIT_MIRROR_ZSH_OHMYZSH_GIT_REMOTE-}" ]]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    else
        git clone "$SYSINIT_MIRROR_ZSH_OHMYZSH_GIT_REMOTE" /tmp/ohmyzsh
        cd /tmp/ohmyzsh/tools
        REMOTE=$SYSINIT_MIRROR_ZSH_OHMYZSH_GIT_REMOTE sh install.sh --unattended

        rm -rf /tmp/ohmyzsh
    fi

    # Install powerlevel10k
    if [[ -z "${SYSINIT_MIRROR_ZSH_POWERLEVEL10K_GIT_REMOTE-}" ]]; then
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/.oh-my-zsh/custom/themes/powerlevel10k
    else
        git clone --depth=1 $SYSINIT_MIRROR_ZSH_POWERLEVEL10K_GIT_REMOTE $HOME/.oh-my-zsh/custom/themes/powerlevel10k
    fi

    file::sed 's#ZSH_THEME="robbyrussell"#ZSH_THEME="powerlevel10k/powerlevel10k"#g' ~/.zshrc

    # Install zsh-autosuggestions and zsh-syntax-highlighting
    sysinit::git_clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions SYSINIT_MIRROR_ZSH_ZSH_AUTOSUGGESTIONS_GIT_REMOTE
    sysinit::git_clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting SYSINIT_MIRROR_ZSH_ZSH_SYNTAX_HIGHLIGHTING_GIT_REMOTE

    file::sed 's#plugins=(git)#plugins=(zsh-autosuggestions zsh-syntax-highlighting)#g' ~/.zshrc
}

module_python_packages() {
    if [[ -n "${SYSINIT_MIRROR_PYPI_INDEX-}" ]]; then
        $SYSINIT_PYTHON_PIP config set global.index-url $SYSINIT_MIRROR_PYPI_INDEX
    fi

    $SYSINIT_PYTHON_PIP install --upgrade pip
    $SYSINIT_PYTHON_PIP install --user --break-system-packages poetry cookiecutter

    utils::append_profiles 'export PATH="'$(python3 -m site --user-base)/bin':$PATH"'
}

module_pyenv() {
    if [[ -z "${SYSINIT_MIRROR_PYENV_GIT_REMOTE-}" ]]; then
        curl -s -S -L https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash
    else
        git clone $SYSINIT_MIRROR_PYENV_GIT_REMOTE ~/.pyenv
    fi
    utils::append_profiles
    utils::append_profiles '# pyenv'
    utils::append_profiles 'export PYENV_ROOT="$HOME/.pyenv"'
    utils::append_profiles 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"'
    utils::append_profiles 'eval "$(pyenv init -)"'
}

module_luaenv() {
    sysinit::git_clone https://github.com/cehoffman/luaenv.git ~/.luaenv SYSINIT_MIRROR_LUAENV_GIT_REMOTE
    sysinit::git_clone https://github.com/cehoffman/lua-build.git ~/.luaenv/plugins/lua-build SYSINIT_MIRROR_LUA_BUILD_GIT_REMOTE

    utils::append_profiles
    utils::append_profiles '# luaenv'
    utils::append_profiles 'export PATH="$HOME/.luaenv/bin:$PATH"'
    utils::append_profiles 'eval "$(luaenv init -)"'
}

module_nvm() {
    if [[ -z "${SYSINIT_MIRROR_NVM_GIT_REMOTE-}" ]]; then
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
    else
        git clone $SYSINIT_MIRROR_NVM_GIT_REMOTE ~/.nvm
        cd ~/.nvm
        git checkout v0.39.4
        source nvm.sh
    fi

    utils::append_profiles
    utils::append_profiles '# nvm'
    utils::append_profiles 'export NVM_DIR="$HOME/.nvm"'
    utils::append_profiles '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"'
    utils::append_profiles '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"'

    source ~/.nvm/nvm.sh
}

module_phpenv() {
    sysinit::git_clone https://github.com/phpenv/phpenv.git ~/.phpenv SYSINIT_MIRROR_PHPENV_GIT_REMOTE
    sysinit::git_clone https://github.com/php-build/php-build.git ~/.phpenv/plugins/php-build SYSINIT_MIRROR_PHP_BUILD_GIT_REMOTE

    utils::append_profiles
    utils::append_profiles '# phpenv'
    utils::append_profiles 'export PATH="$HOME/.phpenv/bin:$PATH"'
    utils::append_profiles 'eval "$(phpenv init -)"'
}

module_powerline-fonts() {
    sysinit::git_clone https://github.com/powerline/fonts.git /tmp/powerline-fonts SYSINIT_MIRROR_POWERLINE_FONTS_GIT_REMOTE

    cd /tmp/powerline-fonts

    if [[ $(os::type) == "cygwin" ]]; then
        powershell -File install.ps1
    else
        ./install.sh
    fi

    rm -rf /tmp/powerline-fonts
}

module_proxy() {
    {
        echo 'export http_proxy=http://127.0.0.1:7890'
        echo 'export https_proxy=http://127.0.0.1:7890'
        echo 'export all_proxy=socks5://127.0.0.1:7890'
    } >> ~/.set_proxy

    {
        echo 'export http_proxy='
        echo 'export https_proxy='
        echo 'export all_proxy='
    } >> ~/.unset_proxy

    utils::append_profiles
    utils::append_profiles '# proxy'
    utils::append_profiles 'source ~/.set_proxy'
}

module_misc() {
    utils::append_profiles
    utils::append_profiles '# misc'
    utils::append_profiles 'alias vi=vim'
    utils::append_profiles 'export GPG_TTY=$(tty)'
    utils::append_profiles 'export PATH="$HOME/.local/bin:$PATH"'
}
