;;; init-local --- Local settings
;;; Commentary:
;;; Code:
(require-package 'monokai-theme)
(require 'monokai-theme)
(load-theme 'monokai t)
(setq visible-bell nil)

(require-package 'yasnippet)
(require 'yasnippet)
(setq yas-snippet-dirs
      '("~/snippets"))
(yas-global-mode t)

(provide 'init-local)
;;; init-local.el ends here
