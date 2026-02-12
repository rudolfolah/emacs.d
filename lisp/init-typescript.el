(require-package 'typescript-mode)

(when (maybe-require-package 'add-node-modules-path)
  (add-hook 'typescript-mode-hook 'add-node-modules-path))

(add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-mode))
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . typescript-mode))

(add-hook 'typescript-mode-hook 'lsp-deferred)

(provide 'init-typescript)
