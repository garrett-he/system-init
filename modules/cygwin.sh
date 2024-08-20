module_cygwin_skel() {
    for skel in /etc/skel/.*; do
        test -f "$skel" && cp -n "$skel" ~
    done

	cp "$SYSINIT_ROOT"/modules/cygwin/.minttyrc ~
}

module_cygwin_apt-cyg() {
    if [[ -z "${SYSINIT_MIRROR_CYGWIN-}" ]]; then
        utils::read 'cygwin mirror' SYSINIT_MIRROR_CYGWIN
    fi

    sysinit::git_clone https://github.com/transcode-open/apt-cyg.git /usr/local/apt-cyg SYSINIT_MIRROR_APT_CYG_GIT_REMOTE

    ln -s /usr/local/apt-cyg/apt-cyg /usr/local/bin

    apt-cyg cache /var/cache/cygwin
    apt-cyg mirror "$SYSINIT_MIRROR_CYGWIN"
}

module_cygwin_apt-cyg_packages() {
    apt-cyg install gcc-core make cmake gdb libssl-devel libiconv-devel zlib-devel libffi-devel vim bash-completion dos2unix fdupes
}

module_cygwin_python() {
    apt-cyg install python3 python3-devel python3-pip python3-cffi

    ln -sf /usr/bin/python3.9.exe /usr/local/bin/python3
    ln -sf /usr/bin/python3.9.exe /usr/local/bin/python
    ln -sf /usr/bin/pip3.9 /usr/local/bin/pip3
    ln -sf /usr/bin/pip3 /usr/local/bin/pip
}
