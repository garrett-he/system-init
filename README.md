![Logo](./logo/system-init.png)

# system-init

This repository contains a set of scripts for initializing systems on multiple
operating systems.

## Installation

`system-init` can be installed by running the following command in your
terminal:

```
$ curl -fsSL https://raw.githubusercontent.com/garrett-he/system-init/main/remote-install.sh | bash
```

If you are installing through a mirror repository, you can set the environment
variable `SYSINIT_GIT_REMOTE`, then execute the above command:

```
$ SYSINIT_GIT_REMOTE=https://url/to/your/repo.git curl -fsSL https://url/to/your/repo/main/remote-install.sh | bash
```

Alternatively, you can clone this repository on your local machine and install
it manually:

```
$ git clone https://github.com/garrett-he/system-init.git /tmp/system-init
$ bash /tmp/system-init
$ rm -rf /tmp/system-init
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

## License

Copyright (C) 2022 Garrett HE <garrett.he@hotmail.com>

The BSD-3-Clause License, see [LICENSE](./LICENSE).
