#!/usr/bin/env bash

if [[ -z $SYSINIT_GIT_REMOTE ]]; then
    SYSINIT_GIT_REMOTE=https://github.com/garrett-he/system-init.git
fi

git clone $SYSINIT_GIT_REMOTE /tmp/system-init

cd /tmp/system-init
git submodule init
git submodule update
/tmp/system-init/install.sh "$SYSINIT_FLAGS" < /dev/tty

rm -rf /tmp/system-init
