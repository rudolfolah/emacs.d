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
(setq
 web-mode-markup-indent-offset 2
 web-mode-enable-auto-quoting nil
 web-mode-enable-auto-pairing nil
 web-mode-enable-auto-opening t
 web-mode-enable-auto-closing t)

;; turn off undo tree, the redo mode functions in a very strange way.
(global-undo-tree-mode -1)

;; turn off electric pairing, really annoying
(electric-pair-mode -1)


(provide 'init-local)
;;; init-local.el ends here
