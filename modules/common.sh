module_dotfiles() {
    sysinit::git_clone https://github.com/garrett-he/dotfiles.git ~/.dotfiles

    cd ~/.dotfiles
    git submodule init
    git submodule update
    ./install.sh
}
