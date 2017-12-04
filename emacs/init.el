(setq custom-file "~/.cache/emacs/custom.el")
(setq org-default-notes-file "~/documents/basket.org")
(define-key global-map "\C-cc" 'org-capture)

(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

(setq savehist-file "~/.cache/emacs/history")
(savehist-mode 1)
(setq history-length t)
(setq history-delete-duplicates t)
(setq savehist-save-minibuffer-history 1)

(setq backup-directory-alist '(("." . "~/.cache/emacs/backups")))
(setq delete-old-versions -1)
(setq version-control t)
(setq vc-make-backup-files t)
(setq auto-save-file-name-transforms '((".*" "~/.cache/emacs/auto-save-list/" t)))

(defalias 'yes-or-no-p 'y-or-n-p)

(setq inhibit-startup-message t)
(setq frame-title-format '("%b — Emacs "))
(add-to-list 'default-frame-alist
	     '(font . "Potipoti-10"))
(set-fontset-font "fontset-default" nil
                  (font-spec :size 10 :name "Symbola"))

(push "~/.emacs.d/base16-material" custom-theme-load-path)
(push "~/.emacs.d/base16-material" load-path)
(load-theme 'base16-material t)

(require 'package)
(package-initialize)

(let ((bootstrap-file (concat user-emacs-directory "straight/bootstrap.el"))
      (bootstrap-version 2))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)
(setq use-package-always-ensure t)

(use-package diminish)

(use-package which-key
  :diminish (which-key-mode nil)
  :config
  (setq which-key-allow-evil-operator t
   which-key-show-operator-state-maps t)
  (which-key-mode))

(use-package try)
(use-package evil
  :config (evil-mode)
    (push "~/.emacs.d/evil-collection" load-path)
    (when (require 'evil-collection nil t)
    (evil-collection-init))
  )

(use-package undo-tree
  :diminish (undo-tree-mode " 🔄")
  :init
  (global-undo-tree-mode))


(use-package telephone-line-config
  :init
  (setq telephone-line-primary-left-separator 'telephone-line-halfcos-left
        telephone-line-secondary-left-separator 'telephone-line-halfcos-hollow-left
        telephone-line-primary-right-separator 'telephone-line-halfcos-right
        telephone-line-secondary-right-separator 'telephone-line-halfcos-hollow-right)
  :ensure telephone-line
  :config (telephone-line-evil-config))

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

(use-package lua-mode)

(use-package magit)
(use-package evil-magit)


(use-package all-the-icons)

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

(define-key notmuch-show-mode-map "j" 'next-line)
(define-key notmuch-show-mode-map "k" 'previous-line)
(define-key notmuch-search-mode-map "j" 'next-line)
(define-key notmuch-search-mode-map "k" 'previous-line)
(define-key notmuch-show-mode-map ":" 'evil-ex)
(define-key notmuch-search-mode-map ":" 'evil-ex)

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

(evil-ex-define-cmd "mmi" 'notmuch-inbox)
(evil-ex-define-cmd "mmu" 'notmuch-unread)
(evil-ex-define-cmd "mml" 'notmuch-unread)

(setq
 message-sendmail-envelope-from 'header
 message-send-mail-function 'message-send-mail-with-sendmail
 sendmail-program "/usr/bin/msmtp"
 notmuch-address-command "~/mail/notmuch-addrlookup"
 notmuch-always-prompt-for-sender t
 )

;; Local Variables:
;; flycheck-disabled-checkers: (emacs-lisp-checkdoc)
;; End:
