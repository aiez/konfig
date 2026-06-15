;; Emacs config: evil + org-babel + Common Lisp (SLY) + magit (launch: emacs -Q -l this)

;; package archives + use-package (auto-install anything missing)
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)
(unless package-archive-contents (package-refresh-contents))
(setq use-package-always-ensure t)

;; core editor: menu bar kept, tool/scroll bars off, line numbers, bigger font, dark theme (nvim mocha)
;; tool-bar-mode/scroll-bar-mode are VOID in terminal builds -- guard or init aborts.
(menu-bar-mode 1)
(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(xterm-mouse-mode 1)  ; mouse clicks (incl. menu bar) in terminal emacs
(setq inhibit-startup-screen t ring-bell-function 'ignore)
(global-display-line-numbers-mode 1)
(set-face-attribute 'default nil :height 140)
(use-package catppuccin-theme :config (load-theme 'catppuccin t))

;; vim keys everywhere
(use-package evil :init (setq evil-want-keybinding nil) :config (evil-mode 1))
(use-package evil-collection :after evil :config (evil-collection-init))

;; minibuffer: vertical candidate list + inline annotations
(use-package vertico :config (vertico-mode 1))
(use-package marginalia :config (marginalia-mode 1))

;; org + babel: run python/shell/lisp blocks inline with C-c C-c, pass data between langs
(use-package org)
(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t) (shell . t) (lisp . t) (emacs-lisp . t)))
(setq org-confirm-babel-evaluate nil)

;; Common Lisp REPL (needs sbcl on PATH): M-x sly
(use-package sly :init (setq inferior-lisp-program "sbcl"))

;; git porcelain: M-x magit-status
(use-package magit)

;; per-repo overrides (loaded last so they win). silent if missing.
(load (expand-file-name "init.local.el" default-directory) t)
