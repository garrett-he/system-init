#!/usr/bin/env bash

SYSINIT_GIT_REMOTE=https://github.com/garrett-he/system-init.git

git clone $SYSINIT_GIT_REMOTE /tmp/system-init
bash /tmp/system-init/install.sh < /dev/tty
rm -rf /tmp/system-init
