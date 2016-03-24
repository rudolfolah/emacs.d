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

(blink-cursor-mode -1)

(defun todo ()
  "Opens file ~/todo.org."
  (interactive)
  (find-file "~/todo.org"))

(defun rmail-after-save-hook () "Blank." t)


(defun remote-term (new-buffer-name cmd &rest switches)
  "Use 'ansi-term' to create `NEW-BUFFER-NAME' running `CMD'.

Includes command line arguments `SWITCHES' when running the command."
  (setq term-ansi-buffer-name (concat "*" new-buffer-name "*"))
  (setq term-ansi-buffer-name (generate-new-buffer-name term-ansi-buffer-name))
  (setq term-ansi-buffer-name (apply 'make-term term-ansi-buffer-name cmd nil switches))
  (set-buffer term-ansi-buffer-name)
  (term-mode)
  (term-char-mode)
  (term-set-escape-char ?\C-x)
  (switch-to-buffer term-ansi-buffer-name))

(defun vbox-startvm (uuid-or-name ui-type)
  "Starts a VirtualBox virtual machine named `UUID-OR-NAME' with
the user interface set to `UI-TYPE' which can be \"headless\" or
\"gui\" or \"separate\"."
  (shell-command (concat "VBoxManage startvm --type \""
                         ui-type "\" \""
                         uuid-or-name "\"")))

;; CoffeeScript sentence-end definition hook
;;(add-hook 'coffee-mode-hook
;;          (lambda ()
;;            (setq-local sentence-end "\\($\\| \\)[
;; ]*")
;;            ))

(provide 'init-local)
;;; init-local.el ends here
