module_cygwin_skel() {
    for skel in /etc/skel/.*; do
        test -f "$skel" && cp -n "$skel" ~
    done

	cp "$SYSINIT_ROOT"/config/cygwin/.minttyrc ~
}

module_cygwin_apt-cyg() {
    sysinit_read 'cygwin mirror' SYSINIT_MIRROR_CYGWIN

    git clone https://github.com/transcode-open/apt-cyg.git /usr/local/apt-cyg

    ln -s /usr/local/apt-cyg/apt-cyg /usr/local/bin

    apt-cyg cache /var/cache/cygwin
    apt-cyg mirror "$SYSINIT_MIRROR_CYGWIN"
}

module_cygwin_apt-cyg_packages() {
    apt-cyg install gcc-core make cmake gdb libssl-devel libiconv-devel zlib-devel libffi-devel vim bash-completion dos2unix fdupes
}
