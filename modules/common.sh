module_dotfiles() {
    curl -fsSL https://raw.githubusercontent.com/garrett-he/dotfiles/main/remote-install.sh | bash
}

module_ohmyzsh() {
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/.oh-my-zsh/custom/themes/powerlevel10k
    sysinit_sed 's#ZSH_THEME="robbyrussell"#ZSH_THEME="powerlevel10k/powerlevel10k"#g' ~/.zshrc

    git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

    sysinit_sed 's#plugins=(git)#plugins=(zsh-autosuggestions zsh-syntax-highlighting)#g' ~/.zshrc
}

module_python_packages() {
    $SYSINIT_PYTHON_PIP install --user --break-system-packages poetry cookiecutter

    sysinit_append_shell_profile 'export PATH="'$(python3 -m site --user-base)/bin':$PATH"'
}

module_pyenv() {
    curl -s -S -L https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash

    sysinit_append_shell_profile 'export PYENV_ROOT="$HOME/.pyenv"'
    sysinit_append_shell_profile 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"'
    sysinit_append_shell_profile 'eval "$(pyenv init -)"'
}
