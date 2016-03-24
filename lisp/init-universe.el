;;; init-universe --- Settings for Universe.com projects
;;; Commentary:
;;; Code:
(defvar uni-local-base-dirs
  '(
    (multiverse "/Users/rudolfolah/Workspace/multiverse/")
    (web "/Users/rudolfolah/Workspace/web/")
    (boxoffice "/Users/rudolfolah/Workspace/boxoffice/"))
  "Local base directories for Universe files.")

(defvar uni-remote-base-dirs
  '(
    (multiverse "~/local-code/multiverse/")
    (web "~/local-code/web/")
    (boxoffice "~/local-code/boxoffice/"))
  "Remote base directories for Universe files.")

(defun uni-sync ()
  "Run rsync shell command."
  (interactive)
  (shell-command "cd ~/Workspace && sh ~/Workspace/sync.sh")
  (kill-buffer "*Shell Command Output*"))

(defun uni-one-sync (repo local-file-name)
  "Run sync for exactly one file."
  (interactive)
  (let* ((local-base-dir (cadr (assoc repo uni-local-base-dirs)))
         (remote-base-dir (cadr (assoc repo uni-remote-base-dirs)))
         (remote-file-name (concat "/" (symbol-name repo) ":"
                                   (s-replace local-base-dir remote-base-dir local-file-name))))
    (message "remote: %s" remote-file-name)
    (copy-file local-file-name remote-file-name t)))

(add-hook 'after-save-hook
          (lambda ()
            (if (or (s-starts-with? "/Users/rudolfolah/Workspace/web" (buffer-file-name))
                    (s-starts-with? "/Users/rudolfolah/Workspace/boxoffice" (buffer-file-name)))
                (progn
                  (message "Syncing universe repos...")
                  (uni-sync)))))

(add-hook 'after-save-hook
          (lambda ()
            (if (s-starts-with? "/Users/rudolfolah/Workspace/multiverse" (buffer-file-name))
                (progn
                  (message "Syncing file: %s" (buffer-file-name))
                  (uni-one-sync 'multiverse (buffer-file-name))))))

(defmacro uni-def-type-check (typename search filename extension)
  "Defines a function with TYPENAME that checks the type of a
buffer. If the buffer contains SEARCH and its file-name includes
FILENAME and ends with EXTENSION, the function returns T."
  `(defun ,(intern (format "uni-%s-p" typename)) (buffer)
     ,(format "Returns T if BUFFER has a %s.

Checks the directory for \"%s\" and searches the file itself for
\"%s\" to see if it contains a %s." typename search filename typename)
     (with-current-buffer buffer
       (save-excursion
         (goto-char (point-min))
         (let* ((index (search-forward ,search nil t))
                (directory-p (s-contains-p ,filename
                                           (file-name-directory (buffer-file-name))))
                (ends-with-p (s-ends-with-p ,extension (buffer-file-name))))
           (and index directory-p ends-with-p))))))

(uni-def-type-check "ember-model" "DS.Model" "models/" ".coffee")
(uni-def-type-check "ember-controller" "Controller" "app/controllers/" ".coffee")
(uni-def-type-check "ember-component" "Ember.Component" "app/components/" ".coffee")
(uni-def-type-check "ember-component-test" "moduleForComponent" "unit/components/" ".coffee")
(uni-def-type-check "ember-component-template" "" "app/templates/components/" ".hbs")
(uni-def-type-check "rails-controller" "Controller" "app/controllers/" ".rb")
(uni-def-type-check "rails-controller-test" "Controller" "spec/controllers/" ".rb")
(uni-def-type-check "rails-active-model" "ActiveModel" "app/models/" ".rb")
(uni-def-type-check "rails-mongoid-model" "Mongoid::Document" "app/models/" ".rb")
(uni-def-type-check "rails-model-test" "Model" "spec/models/" ".rb")

(defun uni-dwim-find-other-file ()
  "Find the other file containing the code for the word or file underneath.

For ember components/models/templates/views, finds the file where
the code is stored.  For example, using this command on a
template HBS will go to the component, controller or route.
Using the command on a component within a template HBS will go to
the component template.  Using the command on the component
template will go to the component coffeescript.

For an Ember model, goes to the Ruby model class.

For ruby files uses the current word and finds the class
definition."
  (interactive)
  (let* ((buffer (current-buffer))
         (find-func (cond ((uni-ember-model-p buffer)
                           'uni-rails-model-file-name)
                          ((uni-ember-controller-p buffer)
                           'uni-ember-template-name)
                          ((uni-ember-component-p buffer)
                           'uni-ember-component-template-name)
                          ((uni-ember-component-test-p buffer)
                           'uni-ember-component-name)
                          ((uni-ember-component-template-p buffer)
                           'uni-ember-component-name)
                          ((uni-rails-controller-p buffer)
                           'uni-rails-controller-test-name)
                          ((uni-rails-controller-test-p buffer)
                           'uni-rails-controller-name-from-test)
                          ((uni-rails-active-model-p buffer)
                           'uni-rails-model-test-name)
                          ((uni-rails-mongoid-model-p buffer)
                           'uni-rails-model-test-name)
                          ((uni-rails-model-test-p buffer)
                           'uni-rails-model-name-from-test)
                          )))
    (if find-func
        (find-file (funcall find-func (buffer-file-name buffer)))
      (error "uni-dwim-find-other-file could not recognize this file!"))))

(defun uni-dwim-find-test ()
  "Find the test/spec for the file underneath."
  (interactive)
  (let* ((buffer (current-buffer))
         (find-func (cond ((or (uni-ember-model-p buffer)
                               (uni-ember-controller-p buffer)
                               (uni-ember-component-p buffer))
                           'uni-ember-test-name)
                          ((or (uni-rails-controller-p buffer)
                               nil)
                           'uni-rails-test-name))))
    (if find-func
        (find-file (funcall find-func (buffer-file-name buffer)))
      (error "uni-dwim-find-test could not find a test for this file!"))))

;; bind uni-dwim to coffee-mode, web-mode, ruby-mode
(defun uni-dwim-hook-func ()
  "Binds keys for uni-dwim-*."
  (local-set-key (kbd "C-c C-f") 'uni-dwim-find-other-file)
  (local-set-key (kbd "C-c C-t") 'uni-dwim-find-test))

(add-hook 'coffee-mode-hook 'uni-dwim-hook-func)
(add-hook 'ruby-mode-hook 'uni-dwim-hook-func)
(add-hook 'web-mode-hook 'uni-dwim-hook-func)

(defun uni-ember-test-name (ember-file-name)
  "Convert the EMBER-FILE-NAME to an Ember test name."
  (s-replace ".coffee" "-test.coffee"
             (s-replace "/app/" "/tests/unit/" ember-file-name)))

(defun uni-ember-component-name (file-name)
  "Convert the FILE-NAME to an Ember component name."
  (let* ((base-dir (directory-file-name (cadr (assoc 'multiverse uni-local-base-dirs))))
         (prefixes (mapcar (lambda (prefix) (concat base-dir "/" prefix "/"))
                           '("app/controllers"
                             "app/components"
                             "app/views"
                             "app/templates/components"
                             "tests/unit/components")))
         (suffixes '(".rb" ".coffee" ".js" ".hbs" "-test.js" "-test.coffee"))
         (name (s-chop-suffixes suffixes (s-chop-prefixes prefixes file-name))))
    ;; TODO: check prefixes and suffixes, they aren't currently
    ;; matching for a component test
    (concat base-dir "/app/components/" name ".coffee")))

(defun uni-ember-template-name (file-name)
  "Convert the FILE-NAME to a template name."
  (let* ((base-dir (directory-file-name (cadr (assoc 'multiverse uni-local-base-dirs))))
         (prefixes (mapcar (lambda (prefix) (concat base-dir "/app/" prefix "/"))
                           '("controllers" "components" "views")))
         (suffixes '(".rb" ".coffee" ".js"))
         (name (s-chop-suffixes suffixes (s-chop-prefixes prefixes file-name))))
    (concat base-dir "/app/templates/" name ".hbs")))

(defun uni-rails-controller-test-name (file-name)
  "Convert the FILE-NAME to a Rails controller test name."
  (let* ((base-dir (directory-file-name (cadr (assoc 'web uni-local-base-dirs))))
         (prefixes (mapcar (lambda (prefix) (concat base-dir "/app/" prefix "/"))
                           '("controllers")))
         (suffixes '(".rb"))
         (name (s-chop-suffixes suffixes (s-chop-prefixes prefixes file-name))))
    (concat base-dir "/spec/controllers/" name "_spec.rb")))

(defun uni-rails-controller-name-from-test (file-name)
  "Convert the FILE-NAME to a Rails controller name from a Rails
controller spec name."
  (let* ((base-dir (directory-file-name (cadr (assoc 'web uni-local-base-dirs))))
         (prefixes (mapcar (lambda (prefix) (concat base-dir "/spec/" prefix "/"))
                           '("controllers")))
         (suffixes '("_spec.rb"))
         (name (s-chop-suffixes suffixes (s-chop-prefixes prefixes file-name))))
    (concat base-dir "/app/controllers/" name ".rb")))

(defun uni-rails-model-test-name (file-name)
  "Convert the FILE-NAME to a Rails model test name."
  (let* ((base-dir (directory-file-name (cadr (assoc 'web uni-local-base-dirs))))
         (prefixes (mapcar (lambda (prefix) (concat base-dir "/app/" prefix "/"))
                           '("models")))
         (suffixes '(".rb"))
         (name (s-chop-suffixes suffixes (s-chop-prefixes prefixes file-name))))
    (concat base-dir "/spec/models/" name "_spec.rb")))

(defun uni-rails-model-name-from-test (file-name)
  "Convert the FILE-NAME to a Rails model name from a Rails model
spec name."
  (let* ((base-dir (directory-file-name (cadr (assoc 'web uni-local-base-dirs))))
         (prefixes (mapcar (lambda (prefix) (concat base-dir "/spec/" prefix "/"))
                           '("models")))
         (suffixes '("_spec.rb"))
         (name (s-chop-suffixes suffixes (s-chop-prefixes prefixes file-name))))
    (concat base-dir "/app/models/" name ".rb")))

(defun uni-ember-model-to-ember-adapter (model-name)
  "Convert MODEL-NAME to adapter name."
  (s-dashed-words model-name))

(defun uni-rails-api-to-ember-adapter (controller-name)
  "Convert Rails CONTROLLER-NAME to Ember adapter name."
  (singularize-string (replace-regexp-in-string
                       "_controller" ""  controller-name)))

(defun uni-ember-model ()
  "Vists the Ember model for the current file if it exists.

If the file is in multiverse and is an adapter or serializer,
visits the model.

If the file is a ruby file and is a controller or model or
serializer, visits the model."
  ;; TODO
  )

(defun uni-ember-adapter ()
  "Visits the Ember adapter for the current Ember module.

If the module is a serializer or a model, uses `find-file' to visit the Ember adapter file.  Otherwise does nothing."
  (interactive)
  (let* ((dir "~/Workspace/multiverse/app/adapters/")
         (filename (uni-ember-model-to-ember-adapter (file-name-base)))
         (exists-p (s-matches-p "/\\(models|serializers\\)/"))
         (full-file-path (concat dir filename ".coffee")))
    (if exists-p
        (find-file full-file-path))))

(defun uni-rails-model ()
  "Visits the Rails model for the current Ember module.

If the module is an adapter or serializer or model, uses
`find-file' to visit the Rails model file.  Otherwise does
nothing."
  (interactive)
  (let* ((dir "~/Workspace/web/app/models/")
         (filename (replace-regexp-in-string
                    "-" "_" (s-dashed-words (file-name-base))))
         (exists-p (s-matches-p "/\\(models|adapters|serializers\\)/"
                                (buffer-file-name)))
         (full-file-path (concat dir filename ".rb")))
    (if exists-p
        (find-file full-file-path))))

(defun uni-rails-api ()
  "Visits the API controller for the current Ember module.

If the module is an adapter or serializer or model, uses
`find-file' to visit the Rails controller file.  Otherwise does
nothing."
  (interactive)
  (let* ((dir "~/Workspace/web/app/controllers/api/v2/")
         (filename (pluralize-string
                    (replace-regexp-in-string
                     "-" "_" (s-dashed-words (file-name-base)))))
         (exists-p (s-matches-p "/\\(models|adapters|serializers\\)/"
                                (buffer-file-name)))
         (full-file-path (concat dir filename "_controller.rb")))
    (if exists-p
        (find-file full-file-path))))

(defun ssh-web ()
  "SSH into web virtual machine."
  (interactive)
  (remote-term "ssh: web" "ssh" "web"))

(defun ssh-multiverse ()
  "SSH into multiverse virtual machine."
  (interactive)
  (remote-term "ssh: multiverse" "ssh" "multiverse"))

(defun ssh-boxoffice ()
  "SSH into boxoffice virtual machine."
  (interactive)
  (remote-term "ssh: boxoffice" "ssh" "boxoffice"))

(defun vm-web ()
  (interactive)
  (vbox-startvm "universe-web" "headless"))

(defun vm-multiverse ()
  (interactive)
  (vbox-startvm "universe-multiverse" "headless"))

(defun vm-boxoffice ()
  (interactive)
  (vbox-startvm "universe-boxoffice" "headless"))

;; TODO
(defun rspec (file-name)
  "Run rspec on web virtual machine with `FILE-NAME'."
  (interactive "fEnter existing spec filename: ")
  (let* ((remote-file-name (replace-string "~/Workspace/web/" "" file-name))
         (remote-command (concat "cd ~/local-code/web && bundle exec rspec "
                                 remote-file-name)))
    (shell-command (concat "ssh web '" remote-command "'"))))

(provide 'init-universe)
