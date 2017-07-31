(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/"))

(add-to-list 'package-archives
	     '("org" . "http://orgmode.org/elpa/") t)

(setq custom-file "~/.cache/emacs/custom.el")
(setq org-default-notes-file "~/documents/basket.org")
(define-key global-map "\C-cc" 'org-capture)
(package-initialize)

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

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(setq use-package-always-ensure t)

(use-package try)

(use-package which-key
  :diminish (which-key-mode nil)
  :config (which-key-mode))

(use-package evil
  :config (evil-mode))

(use-package undo-tree
  :diminish (undo-tree-mode " 🔄")
  :init
  (global-undo-tree-mode))


(use-package diminish)

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

(require 'notmuch)

(use-package all-the-icons)

;; Local Variables:
;; flycheck-disabled-checkers: (emacs-lisp-checkdoc)
;; End:
