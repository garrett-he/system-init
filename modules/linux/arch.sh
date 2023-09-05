module_linux_python() {
    sudo pacman -S --noconfirm python python-pip

    sysinit::append_profiles
    sysinit::append_profiles '# linux_python'
    sysinit::append_profiles 'export PATH="$HOME/.local/bin:$PATH"'
}

module_linux_lua() {
    sudo pacman -S --noconfirm lua luarocks

    sysinit::append_profiles
    sysinit::append_profiles '# linux_lua'
    sysinit::append_profiles 'export PATH="$HOME/.luarocks/bin:$PATH"'
}
