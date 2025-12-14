;;; Character sets

(defcustom sanityinc/force-default-font-for-symbols nil
  "When non-nil, force Emacs to use your default font for symbols."
  :type 'boolean)

(defun sanityinc/maybe-use-default-font-for-symbols ()
  "Force Emacs to render symbols using the default font, if so configured."
  (when sanityinc/force-default-font-for-symbols
    (set-fontset-font "fontset-default" 'symbol (face-attribute 'default :family))))

(add-hook 'after-init-hook 'sanityinc/maybe-use-default-font-for-symbols)

;;; Changing font sizes

(require-package 'default-text-scale)
(global-set-key (kbd "C-M-=") 'default-text-scale-increase)
(global-set-key (kbd "C-M--") 'default-text-scale-decrease)


(defun sanityinc/maybe-adjust-visual-fill-column ()
  "Readjust visual fill column when the global font size is modified.
This is helpful for writeroom-mode, in particular."
  (if visual-fill-column-mode
      (add-hook 'after-setting-font-hook 'visual-fill-column--adjust-window nil t)
    (remove-hook 'after-setting-font-hook 'visual-fill-column--adjust-window t)))

(add-hook 'visual-fill-column-mode-hook
          'sanityinc/maybe-adjust-visual-fill-column)


;;; Font choices
(defvar my-preferred-fonts '("Inconsolata" "Hack" "Menlo" "Monaco" "Courier New") "Fonts in order of preference")

(defun get-first-existing-font ()
  "Find the first available font from `my-preferred-fonts`."
  (catch 'found
    (dolist (font my-preferred-fonts)
      (when (find-font (font-spec :name font))
	(throw 'found font)))
    "Monospace"))

;;; Default font size
(defun set-default-font-size ()
  (interactive)
  (set-frame-font (format "%s 16" (get-first-existing-font)) nil t))
(set-default-font-size)
;;; Screencast font size
(defun set-screencast-font-size ()
  (interactive)
  (set-frame-font (format "%s 24" (get-first-existing-font)) nil t))

(provide 'init-fonts)
