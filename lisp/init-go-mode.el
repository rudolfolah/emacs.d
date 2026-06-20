(with-suppressed-warnings (bytecomp) (require-package 'go-mode))

;; Set Go buffers to use a tab width of 4
(add-hook 'go-mode-hook
          (lambda ()
            (setq-local tab-width 4)))

(provide 'init-go-mode)
