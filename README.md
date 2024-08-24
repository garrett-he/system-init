![system-init Logo](./images/system-init-logo.png)

# system-init

This repository contains a set of scripts for initializing systems on multiple
operating systems.

## Installation

`system-init` can be installed by running the following command in your
terminal:

```
curl -fsSL https://raw.githubusercontent.com/garrett-he/system-init/main/remote-install.sh | bash
```

If you are installing through a mirror repository, you can set the environment
variable `SYSINIT_GIT_REMOTE`, then execute the above command:

```
SYSINIT_GIT_REMOTE=https://url/to/your/repo.git curl -fsSL https://url/to/your/repo/main/remote-install.sh | bash
```

Alternatively, you can clone this repository on your local machine and install
it manually:

```
git clone https://github.com/garrett-he/system-init.git /tmp/system-init
bash /tmp/system-init
rm -rf /tmp/system-init
```

## Configurations

The configuration files are located in directory `/config` directory and named
with platforms. You can edit these files and define the modules you want to
install.

Note:

1. `system-init` will only load the configuration files of the corresponding
   platform, while others will be ignored.
2. Some modules have dependency relationships, so the order of definition is
   important

## Mirrors

If you want to use mirrors during the installation process, there are two
methods:

1. Pass option `-m MIRRORS`, this can only be used during local installation:

   ```
   ./install.sh -m "mirror1 mirror2"
   ```

2. By using the environment variable `SYSINIT_MIRRORS`, usually used during
   remote installation.

   ```
   SYSINIT_MIRRORS="mirror1 mirror2" curl -fsSL https://raw.githubusercontent.com/garrett-he/system-init/main/remote-install.sh | bash
   ```

There are some pre-defined mirror bundles in directory `/mirrors`. You can use
them by any of the above methods.

Example, install system-init with mirrors from tsinghua and ustc:

```
./install -m "tsinghua ustc"
```

Of course, you can also define mirror sources by yourself.

### All customizable mirror settings

#### common

* SYSINIT_MIRROR_DOTFILES_GIT_REMOTE
* SYSINIT_MIRROR_ZSH_OHMYZSH_GIT_REMOTE
* SYSINIT_MIRROR_ZSH_POWERLEVEL10K_GIT_REMOTE
* SYSINIT_MIRROR_ZSH_ZSH_AUTOSUGGESTIONS_GIT_REMOTE
* SYSINIT_MIRROR_ZSH_ZSH_SYNTAX_HIGHLIGHTING_GIT_REMOTE
* SYSINIT_MIRROR_PYPI_INDEX
* SYSINIT_MIRROR_PYENV_GIT_REMOTE
* SYSINIT_MIRROR_LUAENV_GIT_REMOTE
* SYSINIT_MIRROR_LUA_BUILD_GIT_REMOTE
* SYSINIT_MIRROR_NVM_GIT_REMOTE
* SYSINIT_MIRROR_PHPENV_GIT_REMOTE
* SYSINIT_MIRROR_PHP_BUILD_GIT_REMOTE
* SYSINIT_MIRROR_POWERLINE_FONTS_GIT_REMOTE

#### darwin only

* SYSINIT_MIRROR_HOMEBREW_INSTALL_GIT_REMOTE
* SYSINIT_MIRROR_HOMEBREW_API_DOMAIN
* SYSINIT_MIRROR_HOMEBREW_BOTTLE_DOMAIN
* SYSINIT_MIRROR_HOMEBREW_BREW_GIT_REMOTE
* SYSINIT_MIRROR_HOMEBREW_CORE_GIT_REMOTE

#### cygwin only

* SYSINIT_MIRROR_CYGWIN
* SYSINIT_MIRROR_APT_CYG_GIT_REMOTE

## License

Copyright (C) 2024 Garrett HE <garrett.he@outlook.com>

The BSD-3-Clause License, see [LICENSE](./LICENSE).
