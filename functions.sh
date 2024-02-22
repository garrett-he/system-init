sysinit_install_log="$SYSINIT_ROOT"/.install.log

sysinit_ostype() {
    if [[ $OSTYPE == "darwin"* ]]; then
        echo darwin
    elif [[ $OSTYPE == "linux"* ]]; then
        echo linux
    else
        echo "$OSTYPE"
    fi
}

sysinit_print_error() {
    echo -e "\033[1;31m$1\033[0m" >&2
}

sysinit_print_warning() {
    echo -e "\033[1;33m$1\033[0m"
}

sysinit_print_info() {
    echo -e "\033[1;32m$1\033[0m"
}

sysinit_print_debug() {
    if [[ -z $DOTFILES_DEBUG ]]; then
        return
    fi

    echo -e "\033[0;37m[debug] $1\033[0m"
}

sysinit_read() {
    read -r -p "$(echo -e "\033[1;34m$1\033[0m: ")"
    eval "$2='$REPLY'"

    if [[ -z $REPLY ]]; then
        eval "$2=$3"
    fi
}

sysinit_confirm() {
    read -r -p "$(echo -e "\033[1;34m$1?\033[0m [y/N]: ")"

    if [[ "$REPLY" = "y" ]] || [[ "$REPLY" = "Y" ]]; then
        return 0
    else
        return 1
    fi
}

sysinit_is_defined() {
    declare -F "$1" > /dev/null
    return $?
}

sysinit_is_true() {
    if [[ "$1" == "1" ]] || [[ "$1" == "Y" ]] || [[ "$1" == "y" ]]; then
        return 0
    else
        return 1
    fi
}

sysinit_sed() {
    if [[ $OSTYPE == "darwin"* ]]; then
        /usr/bin/sed -i '' -e "$@"
    else
        sed -i "$@"
    fi
}

sysinit_replace_text() {
    sysinit_sed "s#$2#$3#g" "$1"
}

sysinit_delete_line() {
    sysinit_sed "/$2/d" "$1"
}

sysinit_append_shell_profiles() {
    if [[ -z $2 ]]; then
        for rcfile in .zshrc .bashrc; do
            echo "$1" >> "$HOME/$rcfile"
        done
    else
        echo "$1" >> "$HOME/.${2}rc"
    fi
}

sysinit_backup_files() {
    for file in "$@"; do
        if [[ -e "$file" ]]; then
            cp -R "$file" "$file~"
        fi
    done
}

sysinit_is_module_defined() {
    type module_"$1" > /dev/null 2> /dev/null

    return $?
}

sysinit_is_module_installed() {
    grep "$1" "$sysinit_install_log" > /dev/null 2> /dev/null

    return $?
}

sysinit_install_module() {
    if ! sysinit_is_module_defined "$1"; then
        sysinit_print_error "Module '$1' not defined."
        return 1
    fi

    if ! sysinit_is_module_installed "$1"; then
        module_"$1"

        echo "$1" >> "$sysinit_install_log"
    fi

    return 0
}

sysinit_git_clone() {
    local git_remote_url

    if [[ -z $3 ]] || [[ -z ${!3} ]]; then
        git_remote_url=$1
    else
        git_remote_url=${!3}
    fi

    git clone "$git_remote_url" "$2"
}
