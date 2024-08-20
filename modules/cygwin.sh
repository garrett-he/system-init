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
