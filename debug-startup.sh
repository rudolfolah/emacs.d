#!/bin/sh -e
if [ -n "$CI" ] || [ -n "$TRAVIS" ]; then
    # Make it look like this is ~/.emacs.d
    export HOME=$PWD/..
    if [ ! -L ../.emacs.d ]; then
        ln -s emacs.d ../.emacs.d
    fi
fi

echo "Attempting startup with debug-init..."

if [ -n "$EMACS" ]; then
    if ! command -v "$EMACS" >/dev/null 2>&1; then
         echo "EMACS variable '$EMACS' is not a valid command. Using default 'emacs'."
         unset EMACS
    fi
fi

${EMACS:=emacs} --debug-init --batch \
                --eval '(progn
                          (defvar url-show-status nil)
                          (let ((debug-on-error t)
                                (user-emacs-directory default-directory)
                                (user-init-file (expand-file-name "init.el"))
                                (load-path (delq default-directory load-path)))
                             (setq url-show-status nil)
                             (load-file user-init-file)
                             (run-hooks (quote after-init-hook)))
                          (message "Feature load times:")
                          (mapc (lambda (x) (message "%.2fms %s" (cdr x) (car x)))
                                (sort sanityinc/require-times (lambda (x y) (> (cdr x) (cdr y))))))' > startup.log 2>&1

echo "Startup finished. Check startup.log for details."