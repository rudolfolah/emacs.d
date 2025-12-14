# Developer Guide

## Debugging

To debug Emacs startup issues locally or in CI, you can use the `debug-startup.sh` script.

This script runs Emacs with `--debug-init` and captures all output (stdout and stderr) to `startup.log`.

### Usage

```sh
./debug-startup.sh
```

After running the script, examine the `startup.log` file for error messages and backtraces.

```sh
cat startup.log
```

The `startup.log` file is ignored by git.
