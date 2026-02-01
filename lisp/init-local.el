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

;; To add more snippets, create files in the directory specified above (~/snippets).
;; You should create subdirectories for each major mode, e.g. ~/snippets/rust-mode/.
;;
;; Example: Rust trait snippet
;; File: ~/snippets/rust-mode/trait
;; Content:
;; # -*- mode: snippet -*-
;; # name: trait
;; # key: trait
;; # --
;; trait ${1:Name} {
;;     $0
;; }
;;
;; Example: Rust struct snippet
;; File: ~/snippets/rust-mode/struct
;; Content:
;; # -*- mode: snippet -*-
;; # name: struct
;; # key: struct
;; # --
;; struct ${1:Name} {
;;     ${2:field}: ${3:Type},
;;     $0
;; }

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
;; (paredit-mode -1)

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
  "Start a VirtualBox virtual machine.

Start a VirtualBox virtual machine named `UUID-OR-NAME' with the
user interface set to `UI-TYPE' which can be \"headless\" or
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

;; more convenient ag
(defun ag-find-symbol (directory)
  "Use ag to find the symbol under point, only prompts for `DIRECTORY'."
  (interactive (list (read-directory-name
                      (concat "Find \"" (ag/dwim-at-point) "\" in: "))))
  (ag (ag/dwim-at-point) directory))

(global-set-key (kbd "C-c C-p") 'ag-find-symbol)
(global-set-key (kbd "C-c C-d") 'ag-dired)

(require-package 'org-doing)
(global-set-key (kbd "C-c #") 'org-doing-log)

;; Set TERM to xterm-256color globally for ansi-term to help with CLI rendering
(setq term-term-name "xterm-256color")

;; Fix ansi-term colors for light themes
(defun fix-ansi-term-colors ()
  "Update ansi-term colors for better visibility on light backgrounds."
  (when (eq (frame-parameter nil 'background-mode) 'light)
    (set-face-attribute 'term-color-black nil :foreground "#555555")
    (set-face-attribute 'term-color-blue    nil :foreground "#0000aa")
    (set-face-attribute 'term-color-cyan    nil :foreground "#008b8b")
    (set-face-attribute 'term-color-green   nil :foreground "#006400")
    (set-face-attribute 'term-color-magenta nil :foreground "#800080")
    (set-face-attribute 'term-color-red     nil :foreground "#cc0000")
    (set-face-attribute 'term-color-white nil :foreground "#1a1a1a")
    (set-face-attribute 'term-color-yellow  nil :foreground "#a05a00")
    ))

(add-hook 'term-mode-hook 'fix-ansi-term-colors)

(provide 'init-local)
;;; init-local.el ends here
