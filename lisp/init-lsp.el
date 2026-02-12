(require-package 'lsp-mode)
(require-package 'lsp-ui)

(add-hook 'lsp-mode-hook 'lsp-ui-mode)

(setq lsp-ui-doc-enable t
      lsp-ui-peek-enable t
      lsp-ui-sideline-enable t
      lsp-ui-imenu-enable t
      lsp-ui-flycheck-enable t)

(provide 'init-lsp)
