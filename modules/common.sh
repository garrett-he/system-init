module_dotfiles() {
    sysinit::git_clone file:///home/garrett/Downloads/dotfiles ~/.dotfiles SYSINIT_MIRROR_DOTFILES_GIT_REMOTE

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

    file::sed 's#ZSH_THEME="robbyrussell"#ZSH_THEME="powerlevel10k/powerlevel10k"#g' ~/.zshrc

    # Install zsh-autosuggestions and zsh-syntax-highlighting
    sysinit::git_clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions SYSINIT_MIRROR_ZSH_ZSH_AUTOSUGGESTIONS_GIT_REMOTE
    sysinit::git_clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting SYSINIT_MIRROR_ZSH_ZSH_SYNTAX_HIGHLIGHTING_GIT_REMOTE

    file::sed 's#plugins=(git)#plugins=(zsh-autosuggestions zsh-syntax-highlighting)#g' ~/.zshrc
}

module_python_packages() {
    if [[ -n $SYSINIT_MIRROR_PYPI_INDEX ]]; then
        $SYSINIT_PYTHON_PIP config set global.index-url $SYSINIT_MIRROR_PYPI_INDEX
    fi

    $SYSINIT_PYTHON_PIP install --upgrade pip
    $SYSINIT_PYTHON_PIP install --user --break-system-packages poetry cookiecutter

    utils::append_profiles 'export PATH="'$(python3 -m site --user-base)/bin':$PATH"'
}
