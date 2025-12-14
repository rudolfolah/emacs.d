# Developer Guide

## Scripts, partial list
Description of some of the init scripts:
- init-auto-complete.el Autocompletion
- init-benchmarking.el Benchmarking the startup
- init-common-lisp.el Common Lisp
- init-compat.el Compatability
- init-compile.el Compilation
- init-crontab.el Cron
- init-css.el CSS
- init-csv.el CSV
- init-dash.el Dash modern list library for Emacs
- init-dired.el Dired
- init-editing-utils.el Utilities for editing
- init-elpa.el ELPA package management

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

## Startup Scripts Comparison

| Feature | `test-startup.sh` | `debug-startup.sh` |
| :--- | :--- | :--- |
| **Primary Use** | CI / Quick verification | Debugging / Profiling |
| **Emacs Flags** | `-nw --batch` | `--debug-init --batch` |
| **Output** | Standard Output (console) | File (`startup.log`) |
| **Profiling** | None | Reports feature load times |
| **Env Support** | CI | CI |

