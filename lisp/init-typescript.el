;;; -*- lexical-binding: nil -*-
(require-package 'typescript-mode)

(defun sanityinc/typescript-add-node-modules-path ()
  "Add the nearest project's node_modules binaries to `exec-path'."
  (let ((root (locate-dominating-file default-directory "node_modules")))
    (when root
      (let ((bin-directory (expand-file-name "node_modules/.bin" root)))
        (when (and (file-directory-p bin-directory)
                   (not (member bin-directory exec-path)))
          (setq-local exec-path (cons bin-directory exec-path)))))))

(defun sanityinc/typescript-maybe-start-lsp ()
  "Start LSP when a TypeScript language server is installed."
  (when (executable-find "typescript-language-server")
    (lsp-deferred)))

(add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-mode))
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . typescript-mode))

(add-hook 'typescript-mode-hook #'sanityinc/typescript-add-node-modules-path)
(add-hook 'typescript-mode-hook #'sanityinc/typescript-maybe-start-lsp t)

(provide 'init-typescript)
