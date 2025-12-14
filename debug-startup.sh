#!/bin/sh -e
if [ -n "$CI" ] || [ -n "$TRAVIS" ]; then
    # Make it look like this is ~/.emacs.d
    export HOME=$PWD/..
    if [ ! -L ../.emacs.d ]; then
        ln -s emacs.d ../.emacs.d
    fi
fi

echo "Attempting startup with debug-init..."
${EMACS:=emacs} --debug-init --batch \
                --eval '(progn
                          (defvar url-show-status nil)
                          (let ((debug-on-error t)
                                (user-emacs-directory default-directory)
                                (user-init-file (expand-file-name "init.el"))
                                (load-path (delq default-directory load-path)))
                             (setq url-show-status nil)
                             (load-file user-init-file)
                             (run-hooks (quote after-init-hook))))' > startup.log 2>&1

echo "Startup finished. Check startup.log for details."

