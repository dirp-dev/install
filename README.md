# dirp installer

Install [dirp](https://github.com/dirp-dev/dirp) with a single command:

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/dirp-dev/install/HEAD/install.sh)"
```

By default, the binary is installed to `~/.local/bin`. To customize the install location, set `DIRP_INSTALL_DIR`:

```sh
DIRP_INSTALL_DIR=~/bin /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/dirp-dev/install/HEAD/install.sh)"
```
