module_dotfiles() {
    sysinit_git_clone https://github.com/garrett-he/dotfiles.git ~/.dotfiles SYSINIT_MIRROR_DOTFILES_GIT_REMOTE

    cd ~/.dotfiles
    ./install.sh
}

module_zsh() {
    # Install ohmyzsh
    if [[ -z $SYSINIT_MIRROR_ZSH_OHMYZSH_GIT_REMOTE ]]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    else
        git clone "$SYSINIT_MIRROR_ZSH_OHMYZSH_GIT_REMOTE" /tmp/ohmyzsh
        cd /tmp/ohmyzsh/tools
        REMOTE=$SYSINIT_MIRROR_ZSH_OHMYZSH_GIT_REMOTE sh install.sh --unattended

        rm -rf /tmp/ohmyzsh
    fi

    # Install powerlevel10k
    if [[ -z $SYSINIT_MIRROR_ZSH_POWERLEVEL10K_GIT_REMOTE ]]; then
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/.oh-my-zsh/custom/themes/powerlevel10k
    else
        git clone --depth=1 $SYSINIT_MIRROR_ZSH_POWERLEVEL10K_GIT_REMOTE $HOME/.oh-my-zsh/custom/themes/powerlevel10k
    fi

    sysinit_sed 's#ZSH_THEME="robbyrussell"#ZSH_THEME="powerlevel10k/powerlevel10k"#g' ~/.zshrc

    # Install zsh-autosuggestions and zsh-syntax-highlighting
    sysinit_git_clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions SYSINIT_MIRROR_ZSH_ZSH_AUTOSUGGESTIONS_GIT_REMOTE
    sysinit_git_clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting SYSINIT_MIRROR_ZSH_ZSH_SYNTAX_HIGHLIGHTING_GIT_REMOTE

    sysinit_sed 's#plugins=(git)#plugins=(zsh-autosuggestions zsh-syntax-highlighting)#g' ~/.zshrc
}

module_python_packages() {
    if [[ -n $SYSINIT_MIRROR_PYPI_INDEX ]]; then
        $SYSINIT_PYTHON_PIP config set global.index-url $SYSINIT_MIRROR_PYPI_INDEX
    fi

    $SYSINIT_PYTHON_PIP install --upgrade pip
    $SYSINIT_PYTHON_PIP install --user --break-system-packages poetry cookiecutter

    sysinit_append_shell_profiles 'export PATH="'$(python3 -m site --user-base)/bin':$PATH"'
}

module_pyenv() {
    if [[ -z $SYSINIT_MIRROR_PYENV_GIT_REMOTE ]]; then
        curl -s -S -L https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash
    else
        git clone $SYSINIT_MIRROR_PYENV_GIT_REMOTE ~/.pyenv
    fi
    sysinit_append_shell_profiles
    sysinit_append_shell_profiles '# pyenv'
    sysinit_append_shell_profiles 'export PYENV_ROOT="$HOME/.pyenv"'
    sysinit_append_shell_profiles 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"'
    sysinit_append_shell_profiles 'eval "$(pyenv init -)"'
}

module_luaenv() {
    sysinit_git_clone https://github.com/cehoffman/luaenv.git ~/.luaenv SYSINIT_MIRROR_LUAENV_GIT_REMOTE
    sysinit_git_clone https://github.com/cehoffman/lua-build.git ~/.luaenv/plugins/lua-build SYSINIT_MIRROR_LUA_BUILD_GIT_REMOTE

    sysinit_append_shell_profiles
    sysinit_append_shell_profiles '# luaenv'
    sysinit_append_shell_profiles 'export PATH="$HOME/.luaenv/bin:$PATH"'
    sysinit_append_shell_profiles 'eval "$(luaenv init -)"'
}

module_nvm() {
    if [[ -z $SYSINIT_MIRROR_NVM_GIT_REMOTE ]]; then
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
    else
        git clone $SYSINIT_MIRROR_NVM_GIT_REMOTE ~/.nvm
        cd ~/.nvm
        git checkout v0.39.4
        source nvm.sh
    fi

    sysinit_append_shell_profiles
    sysinit_append_shell_profiles '# nvm'
    sysinit_append_shell_profiles 'export NVM_DIR="$HOME/.nvm"'
    sysinit_append_shell_profiles '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"'
    sysinit_append_shell_profiles '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"'

    source ~/.nvm/nvm.sh
    nvm install lts/hydrogen
}

module_phpenv() {
    sysinit_git_clone https://github.com/phpenv/phpenv.git ~/.phpenv SYSINIT_MIRROR_PHPENV_GIT_REMOTE
    sysinit_git_clone https://github.com/php-build/php-build.git ~/.phpenv/plugins/php-build SYSINIT_MIRROR_PHP_BUILD_GIT_REMOTE

    sysinit_append_shell_profiles
    sysinit_append_shell_profiles '# phpenv'
    sysinit_append_shell_profiles 'export PATH="$HOME/.phpenv/bin:$PATH"'
    sysinit_append_shell_profiles 'eval "$(phpenv init -)"'
}

module_powerline-fonts() {
    sysinit_git_clone https://github.com/powerline/fonts.git /tmp/powerline-fonts SYSINIT_MIRROR_POWERLINE_FONTS_GIT_REMOTE

    cd /tmp/powerline-fonts

    if [[ "$sysinit_ostype" == "cygwin" ]]; then
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

    sysinit_append_shell_profiles
    sysinit_append_shell_profiles '# proxy'
    sysinit_append_shell_profiles 'source ~/.set_proxy'
}

module_misc() {
    sysinit_append_shell_profiles
    sysinit_append_shell_profiles '# misc'
    sysinit_append_shell_profiles 'alias vi=vim'
    sysinit_append_shell_profiles 'export GPG_TTY=$(tty)'
    sysinit_append_shell_profiles 'export PATH="$HOME/.local/bin:$PATH"'
}
