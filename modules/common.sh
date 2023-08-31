module_dotfiles() {
    sysinit::git_clone file:///home/garrett/Downloads/dotfiles ~/.dotfiles SYSINIT_MIRROR_DOTFILES_GIT_REMOTE

    cd ~/.dotfiles
    ./install.sh
}
