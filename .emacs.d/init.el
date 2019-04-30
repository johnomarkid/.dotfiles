;; Basics
(scroll-bar-mode -1)
(tool-bar-mode   -1)
(tooltip-mode    -1)
(menu-bar-mode   -1)
(setq visible-bell t)
(global-linum-mode 1)
(show-paren-mode 1)
(electric-pair-mode 1)

;; use spaces instead of tabs
(setq-default indent-tabs-mode nil)

;; remove trailing whitespace
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Add color formatting to *compilation* buffer
(add-hook 'compilation-filter-hook
   (lambda () (ansi-color-apply-on-region (point-min) (point-max))))

;; close all open buffers
(defun close-all-buffers ()
  (interactive)
  (mapc 'kill-buffer (buffer-list)))

;;; Setup package.el
(require 'package)
(setq package-enable-at-startup nil)
(setq package-archives '(("org"       . "http://orgmode.org/elpa/")
			 ("gnu"       . "http://elpa.gnu.org/packages/")
			 ("melpa"     . "https://melpa.org/packages/")))
(unless package--initialized (package-initialize))

;;; Setup use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile
  (require 'use-package))
(setq use-package-always-ensure t)

;;; Avoid littering the user's filesystem with backups
(setq
   backup-by-copying t      ; don't clobber symlinks
   backup-directory-alist
    '((".*" . "~/.emacs.d/saves/"))    ; don't litter my fs tree
   delete-old-versions t
   kept-new-versions 6
   kept-old-versions 2
   version-control t)       ; use versioned backups

;;; Lockfiles unfortunately cause more pain than benefit
(setq create-lockfiles nil)

;;; Offload the custom-set-variables to a separate file
;;; This keeps your init.el neater and you have the option
;;; to gitignore your custom.el if you see fit.
(setq custom-file "~/.emacs.d/custom.el")
(unless (file-exists-p custom-file)
  (write-region "" nil custom-file))
(load custom-file)

(use-package darktooth-theme
  :ensure t
  :defer t
  :init (load-theme 'darktooth))

;;(set-default-font "Ubuntu Mono Regular -16")
(set-face-attribute 'default nil
                    :family "Ubuntu Mono"
                    :height 170)

;; Need this to load bin into shell
(add-to-list 'exec-path "/usr/local/bin")

;; Shows ctrl-g bell in mode line instead of full screen
(setq ring-bell-function
   (lambda ()
     (let ((orig-fg (face-foreground 'mode-line)))
       (set-face-foreground 'mode-line "#F2804F")
       (run-with-idle-timer 0.1 nil
                            (lambda (fg) (set-face-foreground 'mode-line fg))
                            orig-fg))))

;; guide to customize evil
;; https://github.com/noctuid/evil-guide
(use-package evil
  :ensure t
  :config

  (define-key evil-normal-state-map (kbd "q") nil)

  (use-package evil-leader
    :ensure t
    :init
    (global-evil-leader-mode)
    :config
    (evil-leader/set-leader ",")
    (evil-leader/set-key
      "b" 'switch-to-buffer
      "f" 'find-file
      "," 'projectile-find-file
      "p" 'projectile-switch-project
      "g" 'counsel-ag
      "TAB" 'evil-switch-to-windows-last-buffer
      "w" 'other-window
      "m" 'magit-status
      "a" (lambda () (interactive) (find-file "~/Dropbox/all.org")))

    (evil-leader/set-key-for-mode 'js2-mode
      "t" (lambda () (interactive) (compile "npm run test")))

    (evil-leader/set-key-for-mode 'clojure-mode
      "ee" 'cider-eval-last-sexp
      "eb" 'cider-load-buffer
      "jj" 'cider-jack-in
      "t" 'cider-test-run-tests))

  (use-package evil-surround
    :ensure t
    :config
    (global-evil-surround-mode))

  (evil-mode 1))

(use-package org
  :config
  (add-hook 'org-mode-hook 'visual-line-mode))


(use-package ivy :demand
  :ensure t
  :config
  (ivy-mode 1)
          ; Use Enter on a directory to navigate into the directory, not open it with dired.
  (define-key ivy-minibuffer-map (kbd "C-m") 'ivy-alt-done)
  (setq ivy-use-virtual-buffers t
        ivy-count-format "%d/%d "))

(use-package counsel
  :ensure t
  :after ivy
  :config (counsel-mode))

(use-package swiper
  :ensure t
  :after ivy
  :bind (("C-s" . swiper)
         ("C-r" . swiper)))

(use-package projectile
  :ensure t
  :config
  (projectile-mode)
  (setq projectile-completion-system 'ivy))

(use-package magit
  :ensure t)

(use-package company
  :ensure t
  :defer 1
  :init (setq
         company-tooltip-align-annotations t
         company-tooltip-minimum-width 30)
  :config (global-company-mode)
  :bind ("M-<tab>" . company-complete))

(use-package ag
  :ensure t)

(use-package clojure-mode
  :ensure t)

(use-package cider
  :ensure t
  :defer t
  :config
  (cider-repl-toggle-pretty-printing))

(use-package restclient
  :ensure t)

(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

;; use eslint --fix when saving buffer
(defun my/use-eslint-from-node-modules ()
  (let* ((root (locate-dominating-file
	    (or (buffer-file-name) default-directory)
	    "node_modules"))
    (eslint (and root
		(expand-file-name "node_modules/.bin/eslint"
				    root))))
    (if (and eslint (file-executable-p eslint))
	eslint
	"eslint")))

(defun eslint-fix-file ()
  (interactive)
  (message "eslint --fixing the file" (buffer-file-name))
  (shell-command (concat (my/use-eslint-from-node-modules) " --fix " (buffer-file-name))))

(use-package js2-mode
  :ensure t
  :mode (("\\.js$" . js2-mode))
  :interpreter ("node" . js2-mode)
  :bind (("C-a" . back-to-indentation-or-beginning-of-line)
         ("C-M-h" . backward-kill-word))
  :config
  (progn
    (setq js2-mode-show-parse-errors nil)
    (setq js2-mode-show-strict-warnings nil)
    (add-hook 'js2-mode-hook (lambda () (setq js2-basic-offset 2)))))

(use-package js-doc
  :ensure t
  :defer t)

(use-package add-node-modules-path
  :ensure t)

(use-package flycheck
  :init (global-flycheck-mode)
  :config
  (progn
    (setq-default flycheck-disabled-checkers
              (append flycheck-disabled-checkers
                      '(javascript-jshint json-jsonlist)))
    (flycheck-add-mode 'javascript-eslint 'js2-mode)
    (add-hook 'flycheck-mode-hook 'add-node-modules-path)))

(use-package typescript-mode
  :ensure t
  :mode (("\\.ts\\'" . typescript-mode)
         ("\\.tsx\\'" . typescript-mode))
  :config
  (setq-default typescript-indent-level 2))

(use-package web-mode
  :ensure t
  :mode ("\\.html\\'")
  :config
  (setq web-mode-markup-indent-offset 2))
