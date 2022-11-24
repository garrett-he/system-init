#!/usr/bin/env bash

SYSINIT_GIT_REMOTE=https://github.com/garrett-he/system-init.git

mkdir -p ~/.local/share

git clone $SYSINIT_GIT_REMOTE ~/.local/share/system-init
bash ~/.local/share/system-init/install.sh < /dev/tty
