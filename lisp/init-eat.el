;;; -*- lexical-binding: t -*-

(add-hook 'eat-mode-hook
          (lambda ()
            ;; Coalesce split animation frames without using Eat's full 8 ms default.
            (setq-local eat-minimum-latency 0.005)
            ;; Eat 0.9.4 ignores synchronized output. Use omp's incremental
            ;; repaint path instead of exposing partial erase-and-rewrite frames.
            (setq-local process-environment
                        (cons "PI_NO_SYNC_OUTPUT=1" process-environment))
            ;; Eat's cursor blink timer repaints the entire Emacs frame.
            (setq-local eat-very-visible-cursor-type eat-default-cursor-type
                        eat-very-visible-vertical-bar-cursor-type
                        eat-vertical-bar-cursor-type
                        eat-very-visible-horizontal-bar-cursor-type
                        eat-horizontal-bar-cursor-type)))

(when (eq system-type 'darwin)
  (after-load 'eat
    ;; System curses (including zsh's) cannot read Eat's bundled 32-bit
    ;; terminfo. Apple's tic emits compatible entries without changing TERM.
    (let* ((source (expand-file-name "eat.ti"
                                    (file-name-directory (locate-library "eat"))))
           (directory (expand-file-name "var/eat-terminfo" user-emacs-directory))
           (entry (expand-file-name "65/eat-truecolor" directory)))
      (when (file-newer-than-file-p source entry)
        (make-directory directory t)
        (with-temp-buffer
          (unless (eq 0 (call-process "/usr/bin/tic" nil '(t t) nil
                                      "-x" "-o" directory source))
            (error "Cannot compile Eat terminfo: %s" (buffer-string)))))
      (setq eat-term-terminfo-directory directory))))

(provide 'init-eat)
