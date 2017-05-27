(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/")
	     )

(package-initialize)

(tool-bar-mode -1)
(menu-bar-mode -1)

(setq inhibit-startup-message t)
(setq frame-title-format '("%b — Emacs "))

(push "~/.emacs.d/base16-material" custom-theme-load-path)
(push "~/.emacs.d/base16-material" load-path)
(load-theme 'base16-material t)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(use-package try
  :ensure t)

(use-package which-key
  :ensure t
  :config (which-key-mode))

(use-package evil
  :ensure t
  :config (evil-mode))

(use-package undo-tree
  :diminish (undo-tree-mode "<")
  :ensure t
  :init
  (global-undo-tree-mode))


(use-package diminish
  :ensure t
)

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
  :ensure t
  :config
  (ivy-mode))

(use-package company
  :ensure t
  :config
  (company-mode))

(use-package flycheck
  :ensure t
  :config
  (global-flycheck-mode t))

(use-package jedi
  :ensure t
)

(use-package company-jedi
  :ensure t
  :config
  (defun my/python-mode-hook () (add-to-list 'company-backends 'company-jedi))
  (add-hook 'python-mode-hook 'my/python-mode-hook)
    :ensure t
    :init
    (add-hook 'python-mode-hook 'jedi:setup)
    (add-hook 'python-mode-hook 'jedi:ac-setup))

(use-package elpy
  :ensure t
  :config
  (elpy-enable))

(use-package virtualenvwrapper
  :ensure t
  :config
  (venv-initialize-interactive-shells)
  (venv-initialize-eshell))

(use-package yasnippet
  :ensure t
  :init
  (yas-global-mode 1))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (jedi which-key virtualenvwrapper use-package try telephone-line flycheck evil elpy company-jedi))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
