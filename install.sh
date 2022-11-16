#!/usr/bin/env bash

set -eo pipefail

SYSINIT_ROOT=$(dirname "$(realpath "$0")")
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

sysinit_prepare() {
    # Load modules
    local module_dir="$SYSINIT_ROOT"/modules

    sysinit_print_debug 'Load modules for common'
    source "$module_dir"/common.sh
    source "$module_dir/$(sysinit_ostype)".sh

    # Load configurations
    source "$SYSINIT_ROOT/config/$(sysinit_ostype).conf"
}

sysinit_install() {
    for module in "${modules[@]}"; do
        if sysinit_is_module_installed "$module"; then
            sysinit_print_warning "Module '$module' already installed."
            continue
        fi

        if sysinit_confirm "Install module: $module"; then
            echo
            sysinit_print_info "Installing module: $module"
            if ! sysinit_install_module "$module"; then
                exit 1
            fi
        fi
        echo
    done
}

main() {
    sysinit_announce

    echo
    read -n 1 -s -r -p "Press any key to install or Ctrl+C to quit..."
    echo -e "\n\n"

    sysinit_prepare
    sysinit_install
}

(main "$@")
