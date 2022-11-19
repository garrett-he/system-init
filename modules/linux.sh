module_linux_python() {
    sudo pacman -S python python-pip

    sysinit_append_shell_profile 'export PATH="$HOME/.local/bin:$PATH"'
}

module_linux_lua() {
    sudo pacman -S lua luarocks
}

module_linux_php() {
    sudo pacman -S php
}

module_linux_clash() {
    sudo pacman -S clash

    systemctl enable --user clash
    systemctl start --user clash
}
