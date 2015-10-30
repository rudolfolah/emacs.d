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

;; turn off the paredit mode, really annoying
(paredit-mode -1)

;; turn off the lambda symbol
(global-prettify-symbols-mode -1)

;; a useful function taken from: http://emacs.stackexchange.com/a/5576/10000
(defun global-disable-mode (mode-fn)
  "Disable `MODE-FN' in ALL buffers."
  (interactive "a")
  (dolist (buffer (buffer-list))
    (with-current-buffer buffer
      (funcall mode-fn -1))))

(add-to-list 'auto-mode-alist '("\\.hbs\\'" . web-mode))

(provide 'init-local)
;;; init-local.el ends here
