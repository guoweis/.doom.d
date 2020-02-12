(setq user-full-name "Luca Cambiaghi"
      user-mail-address "luca.cambiaghi@me.com")

(setq doom-scratch-buffer-major-mode 'emacs-lisp-mode)

(general-auto-unbind-keys)

(map! :leader
      :desc "M-x"                   :n "SPC" #'counsel-M-x
      :desc "Async shell command"   :n "!"   #'async-shell-command
      :desc "Toggle eshell"         :n "'"   #'+eshell/toggle

      (:desc "windows" :prefix "w"
        :desc "Cycle focus to other window(s)" :n "TAB" #'other-window )

      (:desc "open" :prefix "o"
        :desc "Terminal"              :n  "t" #'+term/toggle
        :desc "Eshell"                :n  "e" #'+eshell/toggle )
      (:desc "project" :prefix "p"
        :desc "Eshell"               :n "'" #'projectile-run-eshell )
)

(setq display-line-numbers-type nil)

(setq doom-font (font-spec :family "Menlo" :size 14))

;transparent adjustment
(set-frame-parameter (selected-frame)'alpha '(94 . 94))
(add-to-list 'default-frame-alist'(alpha . (94 . 94)))

(setq doom-theme 'doom-vibrant)

(after! centaur-tabs
    (setq centaur-tabs-set-modified-marker t
        centaur-tabs-modified-marker "M"
        centaur-tabs-cycle-scope 'tabs
        centaur-tabs-set-close-button nil)
    (centaur-tabs-group-by-projectile-project)
    (map! :n "g t" #'centaur-tabs-forward
          :n "g T" #'centaur-tabs-backward)
    (add-hook! dired-mode #'centaur-tabs-local-mode)
)

(after! winum
  ;; (defun winum-assign-0-to-treemacs ()
  ;;   (when (string-match-p (buffer-name) "*Treemacs*") 10))

  ;; (add-to-list 'winum-assign-functions #'winum-assign-0-to-treemacs)

    (map! (:when (featurep! :ui window-select)
            :leader
            :n "0" #'treemacs-select-windows
            :n "1" #'winum-select-window-1
            :n "2" #'winum-select-window-2
            :n "3" #'winum-select-window-3
        )))

(setq +pretty-code-enabled-modes '(org-mode))

;; add to ~/.doom.d/config.el
;; (use-package! golden-ratio
;;   :after-call pre-command-hook
;;   :config
;;   (golden-ratio-mode +1)
;;   ;; Using this hook for resizing windows is less precise than
;;   ;; `doom-switch-window-hook'.
;;   (remove-hook 'window-configuration-change-hook #'golden-ratio)
;;   (add-hook 'doom-switch-window-hook #'golden-ratio) )

;; (after! ivy-posframe
;;     (setq ivy-posframe-display-functions-alist
;;             '((swiper          . nil)
;;             (complete-symbol . ivy-posframe-display-at-point)
;;             (t               . ivy-posframe-display-at-frame-top-center)))
;;     (setq ivy-posframe-min-width 110)
;;     (setq ivy-posframe-width 110)
;; (setq ivy-posframe-parameters '((alpha . 85)))
;;     (setq ivy-posframe-height-alist '((t . 20))))
;; (ivy-posframe-mode)

(setq magit-repository-directories '(("~/git" . 2))
      magit-save-repository-buffers nil
      ;; Don't restore the wconf after quitting magit
      magit-inhibit-save-previous-winconf t)

(setq org-directory "~/git/org-notes/"
      org-image-actual-width nil
      +org-export-directory "~/git/org-notes/export/"
      org-default-notes-file "~/git/org-notes/inbox.org"
      org-id-locations-file "~/git/org-notes/.orgids"
      )

(load! "modules/ox-ravel")

(after! org

  (setq org-capture-templates
                  '(("d" "Diary")
                    ("u" "URL")))

  (add-to-list 'org-capture-templates
             '("dn" "New Diary Entry" entry(file+olp+datetree"~/git/org-notes/personal/diary.org" "Daily Logs")
"* %^{thought for the day}
:PROPERTIES:
:CATEGORY: %^{category}
:SUBJECT:  %^{subject}
:MOOD:     %^{mood}
:END:
:RESOURCES:
:END:

\*What was one good thing you learned today?*:
- %^{whatilearnedtoday}

\*List one thing you could have done better*:
- %^{onethingdobetter}

\*Describe in your own words how your day was*:
- %?"))

  (add-to-list 'org-capture-templates
      '("un" "New URL Entry" entry(file+function "~/git/org-notes/personal/dailies.org" org-reverse-datetree-goto-date-in-file)
            "* [[%^{URL}][%^{Description}]] %^g %?")))

(setq org-bullets-bullet-list '("✖" "✚")
      org-ellipsis "▼")

(after! org (set-popup-rule! "^Capture.*\\.org$" :side 'right :size .40 :select t :vslot 2 :ttl 3))
(after! org (set-popup-rule! "*org agenda*" :side 'right :size .40 :select t :vslot 2 :ttl 3))

(after! evil-org
  (setq org-babel-default-header-args:jupyter-python '((:async . "yes")
                                                        (:pandoc t)
                                                        (:kernel . "python3"))))

;; (add-hook! '+org-babel-load-functions
  ;;   (λ! ()
  ;;       (require 'ob-jupyter  "/Users/luca/.emacs.d/.local/straight/repos/emacs-jupyter/ob-jupyter.el" nil)
  ;;       (org-babel-jupyter-override-src-block "python"))
  ;; )
;; (org-babel-jupyter-restore-src-block "python")

;; (after! org
;;   (set-company-backend! 'org-mode
;;     '(company-capf)))

;; (defun add-pcomplete-to-capf ()
;;   (add-hook 'completion-at-point-functions 'pcomplete-completions-at-point nil t))

;; (add-hook 'org-mode-hook #'add-pcomplete-to-capf)

;;(:when (featurep! :tools +jupyter)
(map! :after jupyter
    :map evil-org-mode-map
    :n "gR" #'jupyter-org-execute-subtree
    :localleader
    :desc "Hydra" :n "," #'jupyter-org-hydra/body
    :desc "Inspect at point" :n "?" #'jupyter-inspect-at-point
    :desc "Execute and step" :n "RET" #'jupyter-org-execute-and-next-block
    :desc "Delete code block" :n "x" #'jupyter-org-kill-block-and-results
    :desc "New code block above" :n "+" #'jupyter-org-insert-src-block
    :desc "New code block below" :n "=" (λ! () (interactive) (jupyter-org-insert-src-block t nil))
    :desc "Merge code blocks" :n "m" #'jupyter-org-merge-blocks
    :desc "Split code block" :n "-" #'jupyter-org-split-src-block
    )

(after! jupyter (set-popup-rule! "*jupyter-pager*" :side 'right :size .40 :select t :vslot 2 :ttl 3))
(after! jupyter (set-popup-rule! "^\\*Org Src*" :side 'right :size .40 :select t :vslot 2 :ttl 3))

(require 'ox-ipynb)

(defadvice! +python-poetry-open-repl-a (orig-fn &rest args)
  "Use the Python binary from the current virtual environment."
  :around #'+python/open-repl
  (if (getenv "VIRTUAL_ENV")
      (let ((python-shell-interpreter (executable-find "ipython")))
        (apply orig-fn args))
    (apply orig-fn args)))

(add-hook! python-mode
  ;; (set-repl-handler! 'python-mode #'jupyter-repl-pop-to-buffer)
  (set-repl-handler! 'python-mode #'+python/open-ipython-repl)
  )

(setq python-shell-prompt-detect-failure-warning nil)

;; (setq python-shell-interpreter "ipython")

;; (add-hook! python-mode
;;     (add-to-list python-shell-extra-pythonpaths (list (getenv "PYTHONPATH"))))

(set-popup-rule! "^\\*Python*" :ignore t)

(after! lsp-mode
  (setq lsp-ui-sideline-enable nil
      lsp-enable-indentation nil
      lsp-enable-on-type-formatting nil
      lsp-enable-symbol-highlighting nil
      lsp-enable-file-watchers nil))

(after! direnv
  (add-hook! python-mode #'direnv-update-directory-environment ))

;; (after! lsp
;;   (lsp-register-client
;;    (make-lsp-client :new-connection (lsp-tramp-connection "~/.pyenv/shims/pyls")
;;                     :major-modes '(python-mode)
;;                     :remote? t
;;                     :server-id 'pyls-remote)))

(after! python-pytest
  (setq python-pytest-arguments '("--color" "--failed-first")))

(after! dap-mode
  (setq dap-auto-show-output nil)
  (set-popup-rule! "*dap-ui-locals*" :side 'right :width .50 :vslot 1)
  (set-popup-rule! "*dap-debug-.*" :side 'bottom :size .30 :slot 1)
  (set-popup-rule! "*dap-ui-repl*" :side 'bottom :size .30 :select t :slot 1)

  (defun my/window-visible (b-name)
    "Return whether B-NAME is visible."
    (-> (-compose 'buffer-name 'window-buffer)
        (-map (window-list))
        (-contains? b-name)))

  (defun my/show-debug-windows (session)
    "Show debug windows."
    (let ((lsp--cur-workspace (dap--debug-session-workspace session)))
        (save-excursion
        (unless (my/window-visible dap-ui--locals-buffer)
            (dap-ui-locals)))))

    (add-hook 'dap-stopped-hook 'my/show-debug-windows)

    (defun my/hide-debug-windows (session)
    "Hide debug windows when all debug sessions are dead."
    (unless (-filter 'dap--session-running (dap--get-sessions))
        (and (get-buffer dap-ui--locals-buffer)
            (kill-buffer dap-ui--locals-buffer))))

    (add-hook 'dap-terminated-hook 'my/hide-debug-windows)
  )

(map! :after dap-python
    :map python-mode-map
    :localleader
    (:desc "debug" :prefix "d"
      :desc "Hydra" :n "h" #'dap-hydra
      :desc "Run debug configuration" :n "d" #'dap-debug
      :desc "dap-ui REPL" :n "r" #'dap-ui-repl
      :desc "Edit debug template" :n "t" #'dap-debug-edit-template
      :desc "Run last debug configuration" :n "l" #'dap-debug-last
      :desc "Toggle breakpoint" :n "b" #'dap-breakpoint-toggle
    ))

(after! dap-python
    (dap-register-debug-template "dap-debug-script"
                            (list :type "python"
                                :args "-i"
                                :cwd (lsp-workspace-root)
                                :program nil
                                :environment-variables '(("PYTHONPATH" . "src"))
                                :request "launch"
                                :name "dap-debug-script"))

    (dap-register-debug-template "dap-debug-test"
                            (list :type "python"
                                :cwd (lsp-workspace-root)
                                :environment-variables '(("PYTHONPATH" . "src"))
                                :module "pytest"
                                :request "launch"
                                :name "dap-debug-test")))

;; (after! dap-mode
  ;; (defun my/dap-python--pyenv-executable-find (command)
  ;;   (concat (getenv "VIRTUAL_ENV") "/bin/python"))

    ;; (defun my/dap-python--populate-start-file-args (conf)
    ;;     "Populate CONF with the required arguments."
    ;;     (let* ((host "localhost")
    ;;             (debug-port (dap--find-available-port))
    ;;             (python-executable (my/dap-python--pyenv-executable-find dap-python-executable))
    ;;             (python-args (or (plist-get conf :args) ""))
    ;;             (program (or (plist-get conf :target-module)
    ;;                         (plist-get conf :program)
    ;;                         (buffer-file-name)))
    ;;             (module (plist-get conf :module)))

    ;;         (plist-put conf :program-to-start
    ;;                 (format "%s %s%s -m ptvsd --wait --host %s --port %s %s %s %s"
    ;;                         (concat "PYTHONPATH=" (getenv "PYTHONPATH"))
    ;;                         (or dap-python-terminal "")
    ;;                         (shell-quote-argument python-executable)
    ;;                         host
    ;;                         debug-port
    ;;                         (if module (concat "-m " (shell-quote-argument module)) "")
    ;;                         (shell-quote-argument program)
    ;;                         python-args))
    ;;         (plist-put conf :program program)
    ;;         (plist-put conf :debugServer debug-port)
    ;;         (plist-put conf :port debug-port)
    ;;         (plist-put conf :hostName host)
    ;;         (plist-put conf :host host)
    ;;         conf))

    ;; (dap-register-debug-provider "my/python" 'my/dap-python--populate-start-file-args)

    ;; (dap-register-debug-template "my/python"
    ;;                          (list :type "my/python"
    ;;                                ;; :cwd "/Users/luca/git/emptiesforecast"
    ;;                                :cwd (poetry-find-project-root)
    ;;                                :request "launch"
    ;;                                :name "Python :: Run Configuration")))

(defadvice! +dap-python-poetry-executable-find-a (orig-fn &rest args)
  "Use the Python binary from the current virtual environment."
  :around #'dap-python--pyenv-executable-find
  (if (getenv "VIRTUAL_ENV")
      (executable-find (car args))
    (apply orig-fn args)))
;; (after! dap-python
;;   (defun dap-python--pyenv-executable-find (command)
;;     (concat (getenv "VIRTUAL_ENV") "/bin/python")))

(after! dap-mode
  (set-company-backend! 'dap-ui-repl-mode 'company-dap-ui-repl)

  (add-hook 'dap-ui-repl-mode-hook
            (lambda ()
              (setq-local company-minimum-prefix-length 1)))
  )

(after! ein
  (set-popup-rule! "^\\*ein" :ignore t))

(map! (:when (featurep! :tools ein)
        (:map ein:notebook-mode-map
          :nmvo doom-localleader-key nil ;; remove binding to local-leader

          ;; :desc "Execute" :ni "S-RET" #'ein:worksheet-execute-cell

          :localleader
          :desc "Show Hydra" :n "?" #'+ein/hydra/body
          :desc "Execute and step" :n "RET" #'ein:worksheet-execute-cell-and-goto-next
          :desc "Yank cell" :n "y" #'ein:worksheet-copy-cell
          :desc "Paste cell" :n "p" #'ein:worksheet-yank-cell
          :desc "Delete cell" :n "d" #'ein:worksheet-kill-cell
          :desc "Insert cell below" :n "o" #'ein:worksheet-insert-cell-below
          :desc "Insert cell above" :n "O" #'ein:worksheet-insert-cell-above
          :desc "Next cell" :n "j" #'ein:worksheet-goto-next-input
          :desc "Previous cell" :n "k" #'ein:worksheet-goto-prev-input
          :desc "Save notebook" :n "fs" #'ein:notebook-save-notebook-command
      )))

(set-popup-rule! "^\\*R:" :ignore t)

(defun shell-command-print-separator ()
  (overlay-put (make-overlay (point-max) (point-max))
               'before-string
               (propertize "!" 'display
                           (list 'left-fringe
                                 'right-triangle))))

(advice-add 'shell-command--save-pos-or-erase :after 'shell-command-print-separator)

(after! eshell
  (set-eshell-alias!
   "fd" "+eshell/fd $1"
   "fo" "find-file-other-window $1"))
