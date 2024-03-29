(defun my/get-emacs-subdir (dir)
  "Return a path under the Emacs dir in $XDG_CACHE_HOME"
  (setq cache-dir (concat (file-name-as-directory (if (getenv "XDG_CACHE_HOME")
						      (getenv "XDG_CACHE_HOME")
						    "~/.cache")) "emacs" ))

  (concat (file-name-as-directory cache-dir) dir))

(setq org-default-notes-file "~/documents/basket.org")
(setq org-latex-pdf-process
      '("latexmk -gg -xelatex %f"))
(define-key global-map "\C-cc" 'org-capture)

(setq org-export-latex-listings 'minted)

(setq tramp-default-method "ssh")
(setq vc-follow-links t
      vc-follow-symlinks t)

(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

(setq custom-file (my/get-emacs-subdir "custom.el")
      my/backup-dir (my/get-emacs-subdir "backups/")
      my/auto-save-file-path (my/get-emacs-subdir "auto-save-list/")
      )

(setq savehist-file (my/get-emacs-subdir "history")
      history-length t
      history-delete-duplicates t
      savehist-save-minibuffer-history 1
      backup-directory-alist `(,(cons "." my/backup-dir))
      delete-old-versions -1
      version-control t
      vc-make-backup-files t
      auto-save-file-name-transforms `((".*" ,my/auto-save-file-path t))
)

(savehist-mode 1)

(defalias 'yes-or-no-p 'y-or-n-p)

(setq inhibit-startup-message t)
(setq initial-scratch-message nil)
(setq frame-title-format '("%b — Emacs "))
(add-to-list 'default-frame-alist
	     '(font . "Source Code Pro-12"))
(set-fontset-font "fontset-default" nil
                  (font-spec :size 10 :name "Symbola"))

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)
(setq straight-use-package-by-default t)

(use-package diminish)

(use-package which-key
  :diminish (which-key-mode nil)
  :config
  (setq which-key-allow-evil-operator t
   which-key-show-operator-state-maps t)
  (which-key-mode))

(use-package try)
(use-package evil
  :init (setq evil-want-integration t)
  :config (evil-mode)
  (use-package evil-collection)
    :init (setq evil-want-keybinding nil)
    :config (evil-collection-init))

(use-package undo-tree
  :diminish (undo-tree-mode " 🔄")
  :init
  (global-undo-tree-mode))

(use-package rainbow-delimiters
  :config
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))

(use-package nov
  :config
  (add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode)))

(use-package highlight-parentheses
  :config
  (highlight-parentheses-mode))

(use-package telephone-line-config
  :init
  (setq telephone-line-primary-left-separator 'telephone-line-halfcos-left
        telephone-line-secondary-left-separator 'telephone-line-halfcos-hollow-left
        telephone-line-primary-right-separator 'telephone-line-halfcos-right
        telephone-line-secondary-right-separator 'telephone-line-halfcos-hollow-right)
  :straight (telephone-line
	     :type git :host github :repo "dbordak/telephone-line")
  :config (telephone-line-evil-config))

(use-package hydra)
(use-package ivy
  :diminish (ivy-mode nil)
  :config
  (ivy-mode))

(use-package company
  :config
  (company-mode))

(use-package flycheck
  :config
  (global-flycheck-mode t)
  (use-package flycheck-status-emoji
    :config (flycheck-status-emoji-mode)))

(use-package jedi)

(use-package company-jedi
  :config
  (defun my/python-mode-hook () (add-to-list 'company-backends 'company-jedi))
  (add-hook 'python-mode-hook 'my/python-mode-hook)
    :init
    (add-hook 'python-mode-hook 'jedi:setup)
    (add-hook 'python-mode-hook 'jedi:ac-setup))

(use-package elpy
  :config
  (elpy-enable))

(use-package virtualenvwrapper
  :config
  (venv-initialize-interactive-shells)
  (venv-initialize-eshell))

(use-package yasnippet
:init
(yas-global-mode 1))

(use-package tide
  :config
  (defun setup-tide-mode ()
    "Setup function for tide."
    (interactive)
    (tide-setup)
    (flycheck-mode +1)
    (setq flycheck-check-syntax-automatically '(save mode-enabled))
    (eldoc-mode +1)
    (tide-hl-identifier-mode +1)
    (company-mode +1))

  (add-hook 'js-mode-hook #'setup-tide-mode)
  )

(use-package lua-mode
  :config
  (defun my/lua-mode-hook () (setq indent-tabs-mode nil))
  (add-hook 'lua-mode-hook 'my/lua-mode-hook)
  (autoload 'lua-mode "lua-mode" "Lua editing mode." t)
  (add-to-list 'auto-mode-alist '("\\.lua$" . lua-mode))
  (add-to-list 'interpreter-mode-alist '("lua" . lua-mode)))

(use-package counsel-dash
  :config (setq counsel-dash-docsets-path "~/.local/share/counsel-dash"))
(use-package magit)

(use-package all-the-icons)

(use-package org-ref
  :init (setq org-ref-completion-library 'org-ref-ivy-cite)
  :config (require 'org-ref-isbn))

(use-package ox-reveal)

(use-package xresources-theme
  :straight (xresources-theme
	     :type git
	     :host github
	     :repo "cqql/xresources-theme"))

(use-package neotree)

(use-package base16-theme)
(defun my/frame-init (&optional frame)
  (load-theme 'base16-decaf t)
  (set-mouse-color "white"))
(add-hook 'window-setup-hook 'my/frame-init)
(add-hook 'after-make-frame-functions 'my/frame-init)

(use-package mastodon
  :config (setq mastodon-instance-url "https://bsd.network"))

(require 'notmuch)
(require 'notmuch-address)

(defun notmuch-unread ()
  "Shows unread mail"
  (interactive)
  (notmuch-search "tag:unread"))

(defun notmuch-inbox ()
  "Shows unread mail"
  (interactive)
  (notmuch-search "tag:inbox AND NOT tag:killed"))

(defun notmuch-search-lists ()
  "Shows unread mail"
  (interactive)
  (notmuch-search "tag:lists"))

(define-key notmuch-show-mode-map "d" (lambda ()
    "toggle deleted tag for message"
    (interactive)
    (if (member "deleted" (notmuch-show-get-tags))
	    (notmuch-show-tag (list "-deleted"))
	(notmuch-show-tag (list "+deleted")))))

(define-key notmuch-search-mode-map "d" (lambda ()
    "toggle deleted tag for message"
    (interactive)
    (if (member "deleted" (notmuch-search-get-tags))
	    (notmuch-search-tag (list "-deleted"))
	(notmuch-search-tag (list "+deleted")))))

(require 'widget)
(defun my/notmuch-create-search-link (search-expression label)
  "Create a link that searches `search-expression` and displays as label `label`"
  (widget-create 'link
		 :notify (lexical-let '(s search-expression)
			   (lambda (&rest ignore) (notmuch-search s)))
		 :button-prefix ""
		 :button-suffix ""
		 label)
  (widget-insert "\n"))

(defun my/notmuch-create-my-search-links ()
(mapcar '(lambda (link-info)
	   (funcall #'my/notmuch-create-search-link
		    (car link-info) (cdr link-info)))
	'(("tag:inbox" . "Inbox")
	  ("date:today" . "Today")
	  ("tag:lists" . "Lists")
	  ("tag:list/lua-l-lists.lua.org" . "Lua-l")
	  ("tag:list/misc.openbsd.org" . "OpenBSD")
	  ("tag:list/ports.openbsd.org" . "OpenBSD/Ports")
	  ("tag:list/misc.opensmtpd.org" . "OpenSMTPD")
	  ("tag:list/notmuch.notmuchmail.org" . "Notmuch")
	  )))

(setq
 message-sendmail-envelope-from 'header
 message-send-mail-function 'message-send-mail-with-sendmail
 notmuch-hello-logo nil
 notmuch-search-oldest-first nil
 notmuch-always-prompt-for-sender t
 notmuch-hello-sections #'(my/notmuch-create-my-search-links)
)
;; Local Variables:
;; flycheck-disabled-checkers: (emacs-lisp-checkdoc)
;; End:
