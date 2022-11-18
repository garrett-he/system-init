module_python() {
    sudo pacman -S python python-pip

    sysinit_append_shell_profile 'export PATH="$HOME/.local/bin:$PATH"'
}

module_linux_lua() {
    sudo pacman -S lua luarocks
}
