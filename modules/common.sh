module_dotfiles() {
    if [[ -z $SYSINIT_MIRROR_DOTFILES_GIT_REMOTE ]]; then
        git clone https://github.com/garrett-he/dotfiles.git ~/.dotfiles
    else
        git clone $SYSINIT_MIRROR_DOTFILES_GIT_REMOTE ~/.dotfiles
    fi

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
    if [[ -z $SYSINIT_MIRROR_ZSH_ZSH_AUTOSUGGESTIONS_GIT_REMOTE ]]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions.git $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions
    else
        git clone $SYSINIT_MIRROR_ZSH_ZSH_AUTOSUGGESTIONS_GIT_REMOTE $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions
    fi

    if [[ -z $SYSINIT_MIRROR_ZSH_ZSH_SYNTAX_HIGHLIGHTING_GIT_REMOTE ]]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
    else
        git clone $SYSINIT_MIRROR_ZSH_ZSH_SYNTAX_HIGHLIGHTING_GIT_REMOTE $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions
    fi

    sysinit_sed 's#plugins=(git)#plugins=(zsh-autosuggestions zsh-syntax-highlighting)#g' ~/.zshrc
}

module_python_packages() {
    if [[ -n $SYSINIT_MIRROR_PYPI_INDEX ]]; then
        $SYSINIT_PYTHON_PIP config set global.index-url $SYSINIT_MIRROR_PYPI_INDEX
    fi

    $SYSINIT_PYTHON_PIP install --user --break-system-packages poetry cookiecutter

    sysinit_append_shell_profile 'export PATH="'$(python3 -m site --user-base)/bin':$PATH"'
}

module_pyenv() {
    curl -s -S -L https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash

    sysinit_append_shell_profile 'export PYENV_ROOT="$HOME/.pyenv"'
    sysinit_append_shell_profile 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"'
    sysinit_append_shell_profile 'eval "$(pyenv init -)"'
}

module_luaenv() {
    git clone https://github.com/cehoffman/luaenv.git ~/.luaenv
    git clone https://github.com/cehoffman/lua-build.git ~/.luaenv/plugins/lua-build

    sysinit_append_shell_profile 'export PATH="$HOME/.luaenv/bin:$PATH"'
    sysinit_append_shell_profile 'eval "$(luaenv init -)"'
}

module_nvm() {
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
}

module_phpenv() {
    git clone https://github.com/phpenv/phpenv.git ~/.phpenv
    git clone https://github.com/php-build/php-build.git $HOME/.phpenv/plugins/php-build
    sysinit_append_shell_profile 'export PATH="$HOME/.phpenv/bin:$PATH"'
    sysinit_append_shell_profile 'eval "$(phpenv init -)"'
}

module_powerline-fonts() {
    git clone https://github.com/powerline/fonts.git /tmp/powerline-fonts

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

    sysinit_append_shell_profile 'source ~/.set_proxy'
}

module_misc() {
    sysinit_append_shell_profile 'alias vi=vim'
    sysinit_append_shell_profile 'export GPG_TTY=$(tty)'
}
