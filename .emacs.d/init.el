;;; init.el --- GNU Emacs configuration of Ding Jingen. -*- lexical-binding: t -*-

(when (eq system-type 'darwin)
  (set-frame-font "-*-Monaco-normal-normal-normal-*-14-*-*-*-m-0-iso10646-1"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; User Site Local

(require 'package)
(setq
 package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                    ("org" . "http://orgmode.org/elpa/")
                    ("melpa-stable" . "http://stable.melpa.org/packages/")
                    ("melpa" . "http://melpa.org/packages/"))
 package-archive-priorities '(("org" . 15)
                              ("gnu" . 10)
                              ("melpa-stable" . 5)
                              ("melpa" . 0)))


(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-verbose t)
(setq use-package-always-ensure t)
;; (setq url-gateway-method 'socks)
;; (setq socks-server '("Default server" "127.0.0.1" 7891 5))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This section is for global settings for built-in emacs parameters
(setq
 inhibit-startup-screen t
 initial-scratch-message nil
 enable-local-variables t
 create-lockfiles nil
 make-backup-files nil
 load-prefer-newer t
 custom-file (expand-file-name "custom.el" user-emacs-directory)
 column-number-mode t
 scroll-error-top-bottom t
 scroll-margin 15
 gc-cons-threshold 20000000
 user-full-name "Ding Jingen"
 user-mail-address "dingje.gm@gmail.com")

;; buffer local variables
(setq-default
 indent-tabs-mode nil
 tab-width 4)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This section is for global settings for built-in packages that autoload
(setq
 help-window-select t
 show-paren-delay 0.5
 dabbrev-case-fold-search nil
 tags-case-fold-search nil
 tags-revert-without-query t
 tags-add-tables nil
 compilation-scroll-output 'first-error
 source-directory (getenv "EMACS_SOURCE")
 org-confirm-babel-evaluate nil
 nxml-slash-auto-complete-flag t
 sentence-end-double-space nil
 browse-url-browser-function 'browse-url-generic
 browse-url-generic-program "~/bin/chromium"
 ediff-window-setup-function 'ediff-setup-windows-plain)

(setq-default
 c-basic-offset 4)

(add-hook 'prog-mode-hook
          (lambda () (setq show-trailing-whitespace t)))

;; protects against accidental mouse movements
;; http://stackoverflow.com/a/3024055/1041691
(add-hook 'mouse-leave-buffer-hook
          (lambda () (when (and (>= (recursion-depth) 1)
                                (active-minibuffer-window))
                       (abort-recursive-edit))))

;; *scratch* is immortal
(add-hook 'kill-buffer-query-functions
          (lambda () (not (member (buffer-name) '("*scratch*" "scratch.el")))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This section is for setup functions that are built-in to emacs
(defalias 'yes-or-no-p 'y-or-n-p)
(menu-bar-mode 1)
(when window-system
  (tool-bar-mode -1)
  (scroll-bar-mode -1))
(global-auto-revert-mode t)

(electric-indent-mode 0)
(remove-hook 'post-self-insert-hook
             'electric-indent-post-self-insert-function)
(remove-hook 'find-file-hooks 'vc-find-file-hook)

(global-auto-composition-mode 0)
(auto-encryption-mode 0)
(tooltip-mode 0)

(make-variable-buffer-local 'tags-file-name)
(make-variable-buffer-local 'show-paren-mode)

(add-to-list 'auto-mode-alist '("\\.log\\'" . auto-revert-tail-mode))
(defun add-to-load-path (path)
  "Add PATH to LOAD-PATH if PATH exists."
  (when (file-exists-p path)
    (add-to-list 'load-path path)))
(add-to-load-path (expand-file-name "lisp" user-emacs-directory))

(add-to-list 'auto-mode-alist '("\\.xml\\'" . nxml-mode))
;; WORKAROUND http://debbugs.gnu.org/cgi/bugreport.cgi?bug=16449
(add-hook 'nxml-mode-hook (lambda () (flyspell-mode -1)))

(use-package ibuffer
  :ensure nil
  :bind ("C-x C-b". ibuffer))

(use-package subword
  :ensure nil
  :diminish subword-mode
  :config (global-subword-mode t))

(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This section is for generic interactive convenience methods.
;; Arguably could be uploaded to MELPA as package 'fommil-utils.
;; References included where shamelessly stolen.
(defun indent-buffer ()
  "Indent the entire buffer."
  (interactive)
  (save-excursion
    (delete-trailing-whitespace)
    (indent-region (point-min) (point-max) nil)
    (untabify (point-min) (point-max))))

;; make comment while coding
;; http://www.idiap.ch/~fleuret/files/fleuret.emacs.el
(defun ff/comment-and-go-down (arg)
  "Comments and goes down ARG lines."
  (interactive "p")
  (condition-case nil
      (comment-region (point-at-bol) (point-at-eol)) (error nil))
  (next-line 1)
  (if (> arg 1) (ff/comment-and-go-down (1- arg))))

(defun ff/uncomment-and-go-up (arg)
  "Uncomments and goes up ARG lines."
  (interactive "p")
  (condition-case nil
      (uncomment-region (point-at-bol) (point-at-eol)) (error nil))
  (next-line -1)
  (if (> arg 1) (ff/uncomment-and-go-up (1- arg))))
                                        ;(global-set-key [remap <S-down>] 'ff/comment-and-go-down)
                                        ;(global-set-key [remap <S-up>] 'ff/uncomment-and-go-up)
(define-key global-map [(S-up)] nil)
(define-key global-map [(S-down)] nil)
(global-set-key (kbd "<S-down>") 'ff/comment-and-go-down)
(global-set-key (kbd "<S-up>") 'ff/uncomment-and-go-up)

(defun exit ()
  "Short hand for DEATH TO ALL PUNY BUFFERS!"
  (interactive)
  (if (daemonp)
      (message "You silly")
    (save-buffers-kill-emacs)))

(defun safe-kill-emacs ()
  "Only exit Emacs if this is a small session, otherwise prompt."
  (interactive)
  (if (daemonp)
      ;; intentionally not save-buffers-kill-terminal as it has an
      ;; impact on other client sessions.
      (delete-frame)
    ;; would be better to filter non-hidden buffers
    (let ((count-buffers (length (buffer-list))))
      (if (< count-buffers 11)
          (save-buffers-kill-emacs)
        (message-box "use 'M-x exit'")))))

(defun dot-emacs ()
  "Go directly to .emacs, do not pass Go, do not collect $200."
  (interactive)
  (message "Stop procrastinating and do some work!")
  (find-file "~/.emacs.d/init.el"))

(defun my/smarter-move-beginning-of-line (arg)
  "Move point back to indentation of beginning of line.

Move point to the first non-whitespace character on this line.
If point is already there, move to the beginning of the line.
Effectively toggle between the first non-whitespace character and
the beginning of the line.

If ARG is not nil or 1, move forward ARG - 1 lines first.  If
point reaches the beginning or end of the buffer, stop there."
  (interactive "^p")
  (setq arg (or arg 1))

  ;; Move lines first
  (when (/= arg 1)
    (let ((line-move-visual nil))
      (forward-line (1- arg))))

  (let ((orig-point (point)))
    (back-to-indentation)
    (when (= orig-point (point))
      (move-beginning-of-line 1))))

;; remap C-a to `smarter-move-beginning-of-line'
(global-set-key [remap move-beginning-of-line]
                'my/smarter-move-beginning-of-line)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This section is for global modes that should be loaded in order to
;; make them immediately available.
(use-package persistent-scratch
  :config (persistent-scratch-setup-default))

(use-package projectile
  :demand
  ;; nice to have it on the modeline
  :init
  (setq
   projectile-use-git-grep t
   projectile-completion-system 'ivy)
  :config
  (projectile-global-mode)
  (add-hook 'projectile-grep-finished-hook
            ;; not going to the first hit?
            (lambda () (pop-to-buffer next-error-last-buffer)))
  :bind
  (("s-f" . projectile-find-file)
   ("s-F" . projectile-ag)))

(use-package undo-tree
  ;; :diminish undo-tree-mode
  :config
  (progn
    (global-undo-tree-mode)
    (setq undo-tree-visualizer-timestamps t)
    (setq undo-tree-visualizer-diff t))
  :bind ("s-/" . undo-tree-visualize))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This section is for loading and tweaking generic modes that are
;; used in a variety of contexts, but can be lazily loaded based on
;; context or when explicitly called by the user.
(use-package highlight-symbol
  :diminish highlight-symbol-mode
  :commands highlight-symbol
  :bind ("s-h" . highlight-symbol))

(use-package expand-region
  :commands 'er/expand-region
  :bind ("C-=" . er/expand-region))

(use-package popup-imenu
  :commands popup-imenu
  :bind ("M-i" . popup-imenu))

(use-package ag
  :commands ag
  :init
  (setq ag-reuse-window 't)
  :config
  (add-hook 'ag-search-finished-hook
            (lambda () (pop-to-buffer next-error-last-buffer))))

;; ivy
(use-package ivy
  :diminish ivy-mode
  :ensure t
  :config
  (ivy-mode)
  (setq ivy-display-style 'fancy
        ivy-use-virtual-buffers t
        enable-recursive-minibuffers t
        ivy-use-selectable-prompt t))


;; company
(use-package company
  :ensure t
  :diminish company-mode
  :config
  ;; Global
  (setq
   company-dabbrev-ignore-case nil
   company-dabbrev-code-ignore-case nil
   company-dabbrev-downcase nil
   company-idle-delay 0
   company-minimum-prefix-length 1
   company-show-numbers t
   company-tooltip-limit 20)


  ;; Facing
  (unless (face-attribute 'company-tooltip :background)
    (set-face-attribute 'company-tooltip nil :background "black" :foreground "gray40")
    (set-face-attribute 'company-tooltip-selection nil :inherit 'company-tooltip :background "gray15")
    (set-face-attribute 'company-preview nil :background "black")
    (set-face-attribute 'company-preview-common nil :inherit 'company-preview :foreground "gray40")
    (set-face-attribute 'company-scrollbar-bg nil :inherit 'company-tooltip :background "gray20")
    (set-face-attribute 'company-scrollbar-fg nil :background "gray40"))

  ;; dabbrev is too slow, use C-TAB explicitly
  (delete 'company-dabbrev company-backends)
  ;; Default backends
  ;; (setq company-backends '((company-files)))

  ;; Activating globally
  (global-company-mode t)
  :bind ("C-;" . company-complete-common)
  )


(use-package company-quickhelp
  :ensure t
  :after company
  :config
  (company-quickhelp-mode 1))

;; helm
(use-package helm
  :ensure t
  :config
  (setq helm-scroll-amount 4 ; scroll 4 lines other window using M-<next>/M-<prior>
        helm-quick-update t ; do not display invisible candidates
        helm-idle-delay 0.01 ; be idle for this many seconds, before updating in delayed sources.
        helm-input-idle-delay 0.01 ; be idle for this many seconds, before updating candidate buffer
        helm-show-completion-display-function #'helm-show-completion-default-display-function
        helm-split-window-default-side 'below ;; open helm buffer in another window
        helm-split-window-inside-p t ;; open helm buffer inside current window, not occupy whole other window
        helm-candidate-number-limit 200 ; limit the number of displayed canidates
        helm-move-to-line-cycle-in-source t ; move to end or beginning of source when reaching top or bottom of source.
        helm-ff-file-name-history-use-recentf t
        helm-echo-input-in-header-line t)
  (setq helm-autoresize-max-height 0)
  (setq helm-autoresize-min-height 20)
  (global-set-key (kbd "M-x") 'helm-M-x)
  (global-set-key (kbd "C-x C-f") 'helm-find-files)
  )


(when nil
  (use-package company
    :diminish company-mode
    :commands company-mode
    :init
    (setq
     company-dabbrev-ignore-case nil
     company-dabbrev-code-ignore-case nil
     company-dabbrev-downcase nil
     company-idle-delay 0
     company-minimum-prefix-length 4)
    :config
    ;; dabbrev is too slow, use C-TAB explicitly
    (delete 'company-dabbrev company-backends)
    ;; disables TAB in company-mode, freeing it for yasnippet
    (define-key company-active-map [tab] nil)
    (define-key company-active-map (kbd "TAB") nil))
  )

(use-package rainbow-mode
  :diminish rainbow-mode
  :commands rainbow-mode)

(use-package flycheck
  :diminish flycheck-mode
  :commands flycheck-mode)

(use-package yasnippet
  :diminish yas-minor-mode
  :commands yas-minor-mode
  :config
  (yas-reload-all)
  (define-key yas-minor-mode-map [tab] #'yas-expand))

(use-package whitespace
  :commands whitespace-mode
  :diminish whitespace-mode
  :init
  ;; BUG: https://emacs.stackexchange.com/questions/7743
  (put 'whitespace-line-column 'safe-local-variable #'integerp)
  (setq whitespace-style '(face trailing tabs lines-tail)
        ;; github source code viewer overflows ~120 chars
        whitespace-line-column 120))
(defun whitespace-mode-with-local-variables ()
  "A variant of `whitespace-mode' that can see local variables."
  ;; WORKAROUND https://emacs.stackexchange.com/questions/7743
  (add-hook 'hack-local-variables-hook 'whitespace-mode nil t))

(use-package rainbow-delimiters
  :diminish rainbow-delimiters-mode
  :commands rainbow-delimiters-mode)

(use-package smartparens
  :diminish smartparens-mode
  :commands
  smartparens-strict-mode
  smartparens-mode
  sp-restrict-to-pairs-interactive
  sp-local-pair
  :init
  (setq sp-interactive-dwim t)
  :config
  (require 'smartparens-config)
  (sp-use-smartparens-bindings)
  (sp-pair "(" ")" :wrap "C-(") ;; how do people live without this?
  (sp-pair "[" "]" :wrap "s-[") ;; C-[ sends ESC
  (sp-pair "{" "}" :wrap "C-{")
  (sp-pair "<" ">" :wrap "C-<")

  ;; nice whitespace / indentation when creating statements
  (sp-local-pair '(c-mode java-mode) "(" nil :post-handlers '(("||\n[i]" "RET")))
  (sp-local-pair '(c-mode java-mode) "{" nil :post-handlers '(("||\n[i]" "RET")))
  (sp-local-pair '(java-mode) "<" nil :post-handlers '(("||\n[i]" "RET")))

  ;; WORKAROUND https://github.com/Fuco1/smartparens/issues/543
  (bind-key "C-<left>" nil smartparens-mode-map)
  (bind-key "C-<right>" nil smartparens-mode-map)

  (bind-key "s-{" 'sp-rewrap-sexp smartparens-mode-map)

  (bind-key "s-<delete>" 'sp-kill-sexp smartparens-mode-map)
  (bind-key "s-<backspace>" 'sp-backward-kill-sexp smartparens-mode-map)
  (bind-key "s-<home>" 'sp-beginning-of-sexp smartparens-mode-map)
  (bind-key "s-<end>" 'sp-end-of-sexp smartparens-mode-map)
  (bind-key "s-<left>" 'sp-beginning-of-previous-sexp smartparens-mode-map)
  (bind-key "s-<right>" 'sp-next-sexp smartparens-mode-map)
  (bind-key "s-<up>" 'sp-backward-up-sexp smartparens-mode-map)
  (bind-key "s-<down>" 'sp-down-sexp smartparens-mode-map))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This section is for overriding common emacs keybindings with tweaks.
(global-unset-key (kbd "C-z")) ;; I hate you so much C-z
(global-set-key (kbd "C-x C-c") 'safe-kill-emacs)
(global-set-key (kbd "C-<backspace>") 'contextual-backspace)
(global-set-key (kbd "RET") 'newline-and-indent)
(global-set-key (kbd "M-.") 'projectile-find-tag)
(global-set-key (kbd "M-,") 'pop-tag-mark)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This section is for defining commonly invoked commands that deserve
;; a short binding instead of their packager's preferred binding.
(global-set-key (kbd "C-<tab>") 'company-or-dabbrev-complete)
(global-set-key (kbd "s-s") 'replace-string)
(global-set-key (kbd "<f5>") 'revert-buffer-no-confirm)
(global-set-key (kbd "M-Q") 'unfill-paragraph)
(global-set-key (kbd "<f6>") 'dot-emacs)

;;..............................................................................
;; elisp
(use-package lisp-mode
  :ensure nil
  :commands emacs-lisp-mode
  :config
  (bind-key "RET" 'comment-indent-new-line emacs-lisp-mode-map)
  (bind-key "C-c c" 'compile emacs-lisp-mode-map)

  ;; barf / slurp need some experimentation
  (bind-key "M-<left>" 'sp-forward-slurp-sexp emacs-lisp-mode-map)
  (bind-key "M-<right>" 'sp-forward-barf-sexp emacs-lisp-mode-map))

(use-package eldoc
  :ensure nil
  :diminish eldoc-mode
  :commands eldoc-mode)

(use-package focus
  :commands focus-mode)

(use-package pcre2el
  :commands rxt-toggle-elisp-rx
  :init (bind-key "C-c / t" 'rxt-toggle-elisp-rx emacs-lisp-mode-map))

(use-package re-builder
  :ensure nil
  ;; C-c C-u errors, C-c C-w copy, C-c C-q exit
  :init (bind-key "C-c r" 're-builder emacs-lisp-mode-map))

(add-hook 'emacs-lisp-mode-hook
          (lambda ()
            (setq show-trailing-whitespace t)

            (show-paren-mode t)
            (whitespace-mode-with-local-variables)
            (focus-mode t)
            (rainbow-mode t)
            (prettify-symbols-mode t)
            (eldoc-mode t)
            (flycheck-mode t)
            (yas-minor-mode t)
            (company-mode t)
            (smartparens-strict-mode t)
            (rainbow-delimiters-mode t)))

;;..............................................................................
;; Java
(use-package lsp-mode
  :init (setq lsp-prefer-flymake nil)
  :hook
  (java-mode . lsp)
  (scala-mode . lsp)
  ;; (python-mode . lsp)
  )

(when nil
;;
;; Emacs Java IDE using Eclipse JDT Language Server
;; (https://github.com/emacs-lsp/lsp-java).
;; Dependencies:
;; - ht (already present)
;; - request
;;   - deferred
;;
;; 2018-07-18: switch to defer with timeout instead of demand
(use-package lsp-java
  :defer 3
  :init
  (progn
    (require 'lsp-ui-flycheck)
    (require 'lsp-ui-sideline)
    (add-hook 'java-mode-hook 'lsp)
    (add-hook 'java-mode-hook 'smartparens-strict-mode)
    (add-hook 'java-mode-hook #'flycheck-mode)
    (add-hook 'java-mode-hook #'company-mode)
    (add-hook 'java-mode-hook (lambda () (lsp-ui-flycheck-enable t)))
    (add-hook 'java-mode-hook #'lsp-ui-sideline-mode))

  :config
  ;; this is a bummer, having to add each project individually :-(
  (setq lsp-java--workspace-folders
        (list
         (expand-file-name "/tmp/my-test"))))
)

(use-package java-snippets
  :init
  (add-hook 'java-mode-hook #'yas-minor-mode))

(use-package lsp-ui
  :ensure t
  :config
  (setq lsp-ui-doc-position 'at-point
        lsp-ui-sideline-enable t
        lsp-ui-sideline-show-symbol t
        lsp-ui-sideline-show-hover t
        lsp-ui-sideline-show-code-actions t
        lsp-ui-sideline-update-mode 'point))
(when nil
  (use-package lsp-ui
    :hook (lsp-mode . lsp-ui-mode)
    :config
    (setq lsp-ui-doc-position 'at-point
          lsp-ui-doc-enable nil
          lsp-ui-doc-header t
          lsp-ui-doc-max-width 120
          lsp-ui-doc-max-height 30
          lsp-ui-doc-use-childframe t
          lsp-ui-doc-use-webkit t
          lsp-ui-sideline-enable nil
          lsp-ui-sideline-show-symbol nil
          ;; lsp-ui-sideline-show-hover t
          ;; lsp-ui-sideline-showcode-actions t
          ;; lsp-ui-sideline-update-mode 'point
          lsp-prefer-flymake nil))
  )

;; (use-package company-lsp
;; :after company
;; :init
;; (add-to-list 'company-backends #'company-lsp)

;; :config
;; (setq company-lsp-enable-snippet t
;; company-lsp-cache-candidates t))
(use-package company-lsp)

(when nil
(use-package dap-mode
  :ensure t
  :after lsp-mode
  :config
  (dap-mode t)
  (dap-ui-mode t))

(use-package dap-java
  :ensure nil
  :after (lsp-java)
  :config
  (global-set-key (kbd "<f7>") 'dap-step-in)
  (global-set-key (kbd "<f8>") 'dap-next)
  (global-set-key (kbd "<f9>") 'dap-continue)
  )

  )

;;..............................................................................
;; Python
;; global config
(use-package python
  :mode
  ("\\.py\\'" . python-mode)
  ("\\.wsgi$" . python-mode)

  :init
  (setq-default indent-tabs-mode nil)

  :config
  (setq python-indent-offset 4)
  (setq python-shell-completion-native-enable nil))

;; Anaconda configuration
(use-package anaconda-mode
  :ensure t
  :after python
  :hook
  (python-mode . anaconda-mode)
  (python-mode . anaconda-eldoc-mode))

(use-package company-anaconda
  :ensure t
  :hook
  (python-mode . (lambda () (add-to-list (make-local-variable 'company-backends)
                                         '(company-anaconda :with company-capf)))))

;;
(use-package pipenv
  :ensure t
  :hook
  ((python-mode . pipenv-mode))

  :init
  (setq pipenv-projectile-after-switch-function
        #'pipenv-projectile-after-switch-extended))

(use-package pyvenv
  :ensure t)

(use-package ein
  :ensure t
  :config

  ;; (setq ein:complete-on-dot -1)
  (setq ein:complete-on-dot 1)
  (setq ein:completion-backend 'ein:use-company-backend)

  (setq smartparens-mode t)

  (cond
   ((eq system-type 'darwin) (setq ein:console-args '("--gui=osx" "--matplotlib=osx" "--colors=Linux")))
   ((eq system-type 'gnu/linux) (setq ein:console-args '("--gui=gtk3" "--matplotlib=gtk3" "--colors=Linux"))))

  (setq ein:query-timeout 1000)

  (defun load-ein ()
    (ein:notebooklist-load)
    (interactive)
    (ein:notebooklist-open)))

;;..............................................................................
;; lsp-scala
;;
(use-package scala-mode
  :mode "\\.s\\(cala\\|bt\\)$"
  :config
  (setq lsp-scala-server-command "/usr/local/bin/metals-emacs"))

(use-package sbt-mode
  :commands sbt-start sbt-command
  :config
  ;; WORKAROUND: https://github.com/ensime/emacs-sbt-mode/issues/31
  (substitute-key-definition
   ;; allows using SPACE when in the minibuffer
   'minibuffer-complete-word
   'self-insert-command
   minibuffer-local-completion-map))

(use-package nxml
  :mode ("\\.\\(xml\\|xsl\\|rng\\|xhtml\\|page\\|zul\\)\\'" . nxml-mode)
  :defer t
  :init
  (setq nxml-slash-auto-complete-flag t) ;输入</完成结束标记
  (setq nxml-char-ref-display-glyph-flag nil)
  :config
  ;; (bind-key "C-<return>" 'nxml-complete nxml-mode-map)
  :bind (:map nxml-mode-map
              ("<C-return>" . nxml-completion))
  :hook
  (nxml-mode . yas-minor-mode)

  )

;; pdf tool
(use-package pdf-tools
  ;; :pin manual
  :ensure t
  :after hydra
  :config

  ;; Install what need to be installed !
  (pdf-tools-install t t t)
  ;; open pdfs scaled to fit page
  (setq-default pdf-view-display-size 'fit-page)
  ;; automatically annotate highlights
  (setq pdf-annot-activate-created-annotations t)
  ;; use normal isearch
  (define-key pdf-view-mode-map (kbd "C-s") 'isearch-forward)
  ;; more fine-grained zooming
  (setq pdf-view-resize-factor 1.1)

  ;;
  (add-hook 'pdf-view-mode-hook
            (lambda ()
              (pdf-misc-size-indication-minor-mode)
              ;; (pdf-view-midnight-minor-mode)
              (pdf-links-minor-mode)
              (pdf-isearch-minor-mode)
              (cua-mode 0)
              ))

  (add-to-list 'auto-mode-alist (cons "\\.pdf$" 'pdf-view-mode))

  ;; Keys
  (bind-keys :map pdf-view-mode-map
             ("/" . hydra-pdftools/body)
             ("<s-spc>" .  pdf-view-scroll-down-or-next-page)
             ("g"  . pdf-view-first-page)
             ("G"  . pdf-view-last-page)
             ("l"  . image-forward-hscroll)
             ("h"  . image-backward-hscroll)
             ("j"  . pdf-view-next-page)
             ("k"  . pdf-view-previous-page)
             ("e"  . pdf-view-goto-page)
             ("u"  . pdf-view-revert-buffer)
             ("al" . pdf-annot-list-annotations)
             ("ad" . pdf-annot-delete)
             ("aa" . pdf-annot-attachment-dired)
             ("am" . pdf-annot-add-markup-annotation)
             ("at" . pdf-annot-add-text-annotation)
             ("y"  . pdf-view-kill-ring-save)
             ("i"  . pdf-misc-display-metadata)
             ("s"  . pdf-occur)
             ("b"  . pdf-view-set-slice-from-bounding-box)
             ("r"  . pdf-view-reset-slice))

  (defhydra hydra-pdftools (:color blue :hint nil)
    "
      PDF tools

   Move  History   Scale/Fit                  Annotations     Search/Link     Do
------------------------------------------------------------------------------------------------
     ^^_g_^^      _B_    ^↧^    _+_    ^ ^     _al_: list    _s_: search    _u_: revert buffer
     ^^^↑^^^      ^↑^    _H_    ^↑^  ↦ _W_ ↤   _am_: markup  _o_: outline   _i_: info
     ^^_p_^^      ^ ^    ^↥^    _0_    ^ ^     _at_: text    _F_: link      _d_: dark mode
     ^^^↑^^^      ^↓^  ╭─^─^─┐  ^↓^  ╭─^ ^─┐   _ad_: delete  _f_: search link
_h_ ←pag_e_→ _l_  _N_  │ _P_ │  _-_    _b_     _aa_: dired
     ^^^↓^^^      ^ ^  ╰─^─^─╯  ^ ^  ╰─^ ^─╯   _y_:  yank
     ^^_n_^^      ^ ^  _r_eset slice box
     ^^^↓^^^
     ^^_G_^^
"
    ("\\" hydra-master/body "back")
    ("<ESC>" nil "quit")
    ("al" pdf-annot-list-annotations)
    ("ad" pdf-annot-delete)
    ("aa" pdf-annot-attachment-dired)
    ("am" pdf-annot-add-markup-annotation)
    ("at" pdf-annot-add-text-annotation)
    ("y"  pdf-view-kill-ring-save)
    ("+" pdf-view-enlarge :color red)
    ("-" pdf-view-shrink :color red)
    ("0" pdf-view-scale-reset)
    ("H" pdf-view-fit-height-to-window)
    ("W" pdf-view-fit-width-to-window)
    ("P" pdf-view-fit-page-to-window)
    ("n" pdf-view-next-page-command :color red)
    ("p" pdf-view-previous-page-command :color red)
    ("d" pdf-view-dark-minor-mode)
    ("b" pdf-view-set-slice-from-bounding-box)
    ("r" pdf-view-reset-slice)
    ("g" pdf-view-first-page)
    ("G" pdf-view-last-page)
    ("e" pdf-view-goto-page)
    ("o" pdf-outline)
    ("s" pdf-occur)
    ("i" pdf-misc-display-metadata)
    ("u" pdf-view-revert-buffer)
    ("F" pdf-links-action-perfom)
    ("f" pdf-links-isearch-link)
    ("B" pdf-history-backward :color red)
    ("N" pdf-history-forward :color red)
    ("l" image-forward-hscroll :color red)
    ("h" image-backward-hscroll :color red)))

(use-package pdf-view-restore
  :after pdf-tools
  :config
  ;; (setq pdf-view-restore-filename "~/.emacs.d/.pdf-view-restore")
  (add-hook 'pdf-view-mode-hook 'pdf-view-restore-mode))

(use-package quelpa-use-package
  :ensure t
  :init
  (setq quelpa-update-melpa-p nil))

(use-package origami
  :ensure quelpa
  :quelpa (origami :repo "seblemaguer/origami.el" :fetcher github)
  :custom
  (origami-show-fold-header t)

  :custom-face
  (origami-fold-replacement-face ((t (:inherit magit-diff-context-highlight))))
  (origami-fold-fringe-face ((t (:inherit magit-diff-context-highlight))))

  :init
  (defhydra origami-hydra (:color blue :hint none)
    "
      _:_: recursively toggle node       _a_: toggle all nodes    _t_: toggle node
      _o_: show only current node        _u_: undo                _r_: redo
      _R_: reset
      "
    (":" origami-recursively-toggle-node)
    ("a" origami-toggle-all-nodes)
    ("t" origami-toggle-node)
    ("o" origami-show-only-node)
    ("u" origami-undo)
    ("r" origami-redo)
    ("R" origami-reset))

  :bind (:map origami-mode-map
              ("C-:" . origami-hydra/body))
  :config
  (face-spec-reset-face 'origami-fold-header-face))

;; irc client
(use-package circe
  :ensure t
  :bind ("<S-f2>" . circe-init)
  :init
  (add-hook 'circe-chat-mode-hook 'disable-global-facilities)

  :config

  ;; Defining the networks
  (setq circe-network-options
        '(("bitlbee"
           :nick "jevenus"
           :server-buffer-name "⇄ bitlbee"
           :nickserv-password my-irc-password
           :nickserv-mask "\\(bitlbee\\|root\\)!\\(bitlbee\\|root\\)@"
           :nickserv-identify-challenge "use the \x02identify\x02 command to identify yourself"
           :nickserv-identify-command "PRIVMSG NickServ :IDENTIFY {nick} {password}"
           :nickserv-identify-confirmation "Password accepted, settings and accounts loaded"
           :channels ("&bitlbee")
           :host "localhost"
           :service "6667")

          ("Freenode"
           :tls t
           :nick "jevenus"
           :channels (:after-auth "#limsi")
           :nickserv-password my-irc-password
           :server-buffer-name "⇄ freenode")

          ("gitter"
           :tls t
           :nick "jevenus"
           :sasl-username "jevenus"
           :sasl-password my-irc-password
           :server-buffer-name "⇄ gitter"
           :host"irc.gitter.im"
           :service "6667")
          ))

  ;; Completion
  (setq circe-use-cycle-completion t)

  ;; Spam information reduction
  (setq circe-reduce-lurker-spam t)

  ;; Tracking
  (setq lui-track-bar-behavior 'before-switch-to-buffer)
  (enable-lui-track-bar)

  ;; spell checking
  (add-hook 'circe-channel-mode-hook 'turn-on-flyspell)
  (setq lui-max-buffer-size 30000
        lui-flyspell-p t
        lui-flyspell-alist '(("limsi" "francais")
                             ("IvanaDidirkova" "francais")
                             ("." "american")))

  ;; Formatting
  (enable-circe-color-nicks)

  (setq lui-time-stamp-position 'right-margin
        lui-time-stamp-format "%H:%M"
        lui-fill-type nil)

  (defun my-lui-setup ()
    (setq
     fringes-outside-margins t
     right-margin-width 5
     word-wrap t
     wrap-prefix "    "))
  (add-hook 'lui-mode-hook 'my-lui-setup)

  ;; Connection
  (defun circe-network-connected-p (network)
    "Return non-nil if there's any Circe server-buffer whose
  `circe-server-netwok' is NETWORK."
    (catch 'return
      (dolist (buffer (circe-server-buffers))
        (with-current-buffer buffer
          (if (string= network circe-server-network)
              (throw 'return t))))))

  (defun circe-maybe-connect (network)
    "Connect to NETWORK, but ask user for confirmation if it's
  already been connected to."
    (interactive "sNetwork: ")
    (if (or (not (circe-network-connected-p network))
            (y-or-n-p (format "Already connected to %s, reconnect?" network)))
        (circe network)))

  (defun my-irc-password (server)
    "Return the password for the `SERVER'."
    (my:auth-source-get-passwd :host server))

  ;; Shortcut
  (defun circe-init ()
    "Connect to IRC"
    (interactive)
    (if (circe-network-connected-p "bitlbee")
        (switch-to-buffer "&bitlbee")
      (progn
        (circe-maybe-connect "Freenode")
        (circe-maybe-connect "bitlbee"))))
  )

;; dictionary
;;
;;
(use-package osx-dictionary
  :config
  (bind-key "C-c d" 'osx-dictionary-search-word-at-point)
  )
(use-package youdao-dictionary
  :config
  (setq url-automatic-caching t)
  (bind-key "C-c y" 'youdao-dictionary-search-at-point)
  )

;; emojify
;;
(use-package emojify
  :ensure t
  :config

  (use-package company-emoji
    :ensure t)

  ;; (setq emojify-user-emojis
  ;; '(("(heart)" . (("name" . "Heart")
  ;; ("image" . "~/.emacs.d/emojis/emojione-v2.2.6-22/2665.png")
  ;; ("style" . "github")))))

  ;; If emojify is already loaded refresh emoji data
  (when (featurep 'emojify)
    (emojify-set-emoji-data)))

(use-package flycheck-status-emoji
  :ensure t
  :after emojify)

;; Dash
(defun jcf-dash-installed-p ()
  "Return t if Dash is installed on this machine, or nil otherwise."
  (let ((lsregister "/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister"))
    (and (file-executable-p lsregister)
         (not (string-equal
               ""
               (shell-command-to-string
                (concat lsregister " -dump|grep com.kapeli.dash")))))))

(defvar jcf-dash-installed?
  (jcf-dash-installed-p))

(use-package dash-at-point
  :if jcf-dash-installed?
  :bind
  ("C-c D" . dash-at-point))

(use-package zop-to-char
  :ensure t
  :bind (("M-z" . zop-up-to-char)
         ("M-Z" . zop-to-char)))

(when nil
(use-package flyspell
  :config
  ;; (setq ispell-program-name "/usr/local/bin/aspell" ; use aspell instead of ispell
        ;; ispell-extra-args '("--sug-mode=ultra"))
  ;; (add-hook 'text-mode-hook #'flyspell-mode)
  (add-hook 'prog-mode-hook #'flyspell-prog-mode)
  )
  )


(use-package major-mode-hydra
  :bind
  ("C-M-m" . major-mode-hydra))

(use-package ibuffer
  :config (setq ibuffer-expert t)
  :bind ("C-x C-b" . ibuffer))

(use-package nyan-mode
  :init (nyan-mode 1))

(use-package smex
  :init (smex-initialize)
  :bind ("M-x" . smex))


;; (use-package powerline
;; :config
;; (powerline-center-theme))

(use-package nimbus-theme
  :disabled
  :defer)

(use-package leuven-theme
  :disabled
  :defer)

(use-package buffer-flip
  :bind
  (("s-v" . buffer-flip)
   :map buffer-flip-map
   ("s-v" . buffer-flip-forward)
   ("s-V" . buffer-flip-backward)
   ("C-g" . buffer-flip-abort)))

(use-package theme-changer
  :init
  (setq calendar-latitude 40)
  (setq calendar-longitude 116.4))


;; Invoke M-x without the Alt key
(global-set-key "\C-x\C-m" 'execute-extended-command)
(global-set-key "\C-c\C-m" 'execute-extended-command)

;; prefer backword-kill-word over backspace
(global-set-key "\C-w" 'backward-kill-word)
(global-set-key "\C-x\C-k" 'kill-region)
(global-set-key "\C-c\C-k" 'kill-region)


(use-package server
  ;; :unless (noninteractive)
  :no-require
  :hook (after-init . server-start))

;; (find-file "~/Documents/org/gtd.org")
(setq org-agenda-files
      '("~/Library/Mobile Documents/iCloud~com~appsonthemove~beorg/Documents/org/todo.org"))
(require 'org-tempo)
;; (server-start)
;; (toggle-debug-on-error)
;;; init.el ends here