#!/usr/bin/env bash

set -eo pipefail

SYSINIT_ROOT=$(dirname "$(realpath "$0")")
source "$SYSINIT_ROOT"/vendor/shell-lib/lib/logging.sh
source "$SYSINIT_ROOT"/vendor/shell-lib/lib/os.sh
source "$SYSINIT_ROOT"/vendor/shell-lib/lib/utils.sh
source "$SYSINIT_ROOT"/vendor/shell-lib/lib/file.sh
source "$SYSINIT_ROOT"/functions.sh

sysinit_announce() {
    echo '================================================='
    echo '                _                 _       _ _    '
    echo '               | |               (_)     (_) |   '
    echo '  ___ _   _ ___| |_ ___ _ __ ___  _ _ __  _| |_  '
    echo ' / __| | | / __| __/ _ \  _ ` _ \| |  _ \| | __| '
    echo ' \__ \ |_| \__ \ ||  __/ | | | | | | | | | | |_  '
    echo ' |___/\__, |___/\__\___|_| |_| |_|_|_| |_|_|\__| '
    echo '       __/ |                                     '
    echo '      |___/                                      '
    echo '================================================='
    echo
    echo 'A set of scripts for initializing systems on multiple'
    echo 'operating systems.'
}

sysinit_help() {
    echo 'usage: install.sh [-m MIRRORS]'
    echo 'A set of scripts for initializing systems on multiple operating systems.'
    echo
    echo '  -m MIRRORS        mirrors to use during installation'
}

sysinit_prepare() {
    # Load modules
    local module_dir="$SYSINIT_ROOT"/modules

    logging::debug 'Load modules for common'
    source "$module_dir"/common.sh

    local ostype=$(os::type)

    if [[ $ostype == "linux" ]]; then
        eval $(cat /etc/*-release | grep "^ID=")

        if [[ "$ID" == "manjaro" ]]; then
            ID=arch
        fi

        local linux_module_file="$SYSINIT_ROOT/modules/linux/${ID}.sh"
        if [[ -f $linux_module_file ]]; then
            source "$linux_module_file"
        else
            logging::warning "linux module file not found: ${linux_module_file}"
        fi
    else
        source "$module_dir/$ostype".sh
    fi

    # Load mirrors
    if [[ -n "${SYSINIT_MIRRORS-}" ]]; then
        for mirror in $SYSINIT_MIRRORS; do
            local mirror_dir="$SYSINIT_ROOT/mirrors/$mirror"

            if [[ -d $mirror_dir ]]; then
                for mirror_file in "$mirror_dir"/*; do
                    source "$mirror_file"
                done
            fi
        done
    fi

    # Load configurations
    source "$SYSINIT_ROOT/config/$ostype.conf"
}

sysinit_install() {
    for module in "${modules[@]}"; do
        if sysinit::is_module_installed "$module"; then
            logging::warning "Module '$module' already installed."
            continue
        fi

        if utils::confirm "Install module: $module"; then
            echo
            logging::info "Installing module: $module"
            if ! sysinit::install_module "$module"; then
                exit 1
            fi
        fi
        echo
    done
}

main() {
    while getopts 'hm:' opt; do
        case $opt in
            h) sysinit_help && exit 0 ;;
            m) SYSINIT_MIRRORS="$OPTARG" ;;
            *) ;;
        esac
    done

    sysinit_announce

    echo
    read -n 1 -s -r -p "Press any key to install or Ctrl+C to quit..."
    echo -e "\n\n"

    sysinit_prepare
    sysinit_install
}

(main "$@")
