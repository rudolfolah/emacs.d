;;; init-local --- Local settings
;;; Commentary:
;;; Code:
(color-theme-sanityinc-solarized-light)
(setq visible-bell nil)

(require-package 'yasnippet)
(require 'yasnippet)
(setq yas-snippet-dirs
      '("~/snippets"))
(yas-global-mode t)

(require-package 'web-mode)
(require 'web-mode)

(provide 'init-local)
;;; init-local.el ends here
