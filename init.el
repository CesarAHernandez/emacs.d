;; require package

(require 'package)

;; add melpa stable
(add-to-list 'package-archives
         '("melpa-stable" . "https://stable.melpa.org/packages/"))

;; add melpa
(add-to-list 'package-archives
         '("melpa" . "http://melpa.milkbox.net/packages/"))

;; Initialise packages
(package-initialize)

(defvar mymacs-frame-font (list "Dank Mono-12" (list "tahoma" '(#x600 . #x6ff)))
  "Default font to be used on mymacs frame")
;; get latest package information
(package-refresh-contents)(require 'use-package)
(setq use-package-always-ensure t)


;; disable the annoying bell ring
(setq ring-bell-function 'ignore)

;; ;; disable startup screen
;; (setq inhibit-startup-screen t)

;; nice scrolling
(setq scroll-margin 0
      scroll-conservatively 100000
      scroll-preserve-screen-position 1)

(load-theme 'tangotango t)

(menu-bar-mode 0)
(toggle-scroll-bar 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)
;; more useful frame title, that show either a file or a
;; buffer name (if the buffer isn't visiting a file)
(setq frame-title-format
      '((:eval (if (buffer-file-name)
                   (abbreviate-file-name (buffer-file-name))
                 "%b"))))
;; Emacs modes typically provide a standard means to change the
;; indentation width -- eg. c-basic-offset: use that to adjust your
;; personal indentation width, while maintaining the style (and
;; meaning) of any files you load.
(setq-default indent-tabs-mode nil)   ;; don't use tabs to indent
(setq-default tab-width 4)            ;; but maintain correct appearance

;; Newline at end of file
(setq require-final-newline t)

;; Wrap lines at 80 characters
(setq-default fill-column 80)

;; delete the selection with a keypress
(delete-selection-mode t)

;; store all backup and autosave files in the tmp dir
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; Stopping the cursor on cammel case words
(global-subword-mode 1)

;; Moving temperary files to /tmp
(setq backup-directory-alist
    `((".*" . ,temporary-file-directory)))

(setq auto-save-file-name-transforms
    `((".*" ,temporary-file-directory t)))

;; Enable current line highlight
(global-hl-line-mode 1)

;; Show matching parens immediatly
(setq show-paren-delay 0)
(show-paren-mode 1)


;; Save some typing
(fset 'yes-or-no-p 'y-or-n-p)

;; Removes initial message from the scratch buffer
(setq-default initial-scratch-message "")


;; Removes the start up message
(setq-default inhibit-startup-message t)

;; Moves 1 line at a time with the scroll wheel
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))

;; Does not accelerate the scroll with the scroll wheel
(setq mouse-wheel-progressive-speed nil)

;; Scrools the window under the mouse
(setq mouse-wheel-follow-mouse 't) 

;; Scrolls 1 line at a time with the keyboard
(setq scroll-step 1)

;; Show the line number in mode line
(line-number-mode t)

;; Show the column number in mode line
(column-number-mode t)

;; Show the file size in mode line
(size-indication-mode t)

;; revert buffers automatically when underlying files are changed externally
(global-auto-revert-mode t)

(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

;; LOADING PACKAGES AND CONFIGURATION

;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ EVIL ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
(use-package evil
  :init
  (setq evil-want-integration nil) ;; required by evil-collection
  (setq evil-want-keybinding nil)
  :config
  (evil-mode +1)
  (evil-leader/set-key
    "wh" 'evil-window-left
    "wj" 'evil-window-down
    "wl" 'evil-window-right
    "wk" 'evil-window-up))
  ;; vim-like keybindings everywhere in emacs
  (use-package evil-collection
    :after evil
    :config
    (evil-collection-init))

  ;; Seting leader
  (use-package evil-leader
    :config
    (global-evil-leader-mode)
    (evil-leader/set-leader ","))

  (use-package evil-matchit
    :config
    (global-evil-matchit-mode 1))

  (use-package evil-nerd-commenter
    :config
    (global-evil-leader-mode)
    (define-key evil-normal-state-map "gc" 'evilnc-comment-operator))

  ;; Change the esc to 'jk' 
  (use-package key-chord
    :ensure t
    :commands evil-normal-state
    :init
    (setq key-chord-two-key-delay 0.5)
    (key-chord-mode 1)
    (key-chord-define evil-insert-state-map "jk" 'evil-normal-state))

;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ NEOTREE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;;TODO: Use all the icons for macs and not windows
(use-package all-the-icons)
(defun mymacs/neotree-collapse ()
  "Collapse a neotree node."
  (interactive)
  (let ((node (neo-buffer--get-filename-current-line)))
    (when node
      (when (file-directory-p node)
        (neo-buffer--set-expand node nil)
        (neo-buffer--refresh t))
      (when neo-auto-indent-point
        (neo-point-auto-indent)))))

(defun mymacs/neotree-collapse-or-up ()
  "Collapse an expanded directory node or go to the parent node."
  (interactive)
  (let ((node (neo-buffer--get-filename-current-line)))
    (when node
      (if (file-directory-p node)
          (if (neo-buffer--expanded-node-p node)
              (mymacs/neotree-collapse)
            (neotree-select-up-node))
        (neotree-select-up-node))))) 

(use-package neotree
  :after all-the-icons
  :config
  (setq
   neo-autorefresh nil
   neo-mode-line-type 'none
   neo-window-width 25
   neo-banner-message nil
   neo-show-hidden-files nil
   neo-keymap-style 'concise
   neo-hidden-regexp-list
        '(;; vcs folders
          "^\\.\\(git\\|hg\\|svn\\)$"
          ;; compiled files
          "\\.\\(pyc\\|o\\|elc\\|lock\\|css.map\\)$"
          ;; generated files, caches or local pkgs
          "^\\(node_modules\\|vendor\\|.\\(project\\|cask\\|yardoc\\|sass-cache\\)\\)$"
          ;; org-mode folders
          "^\\.\\(sync\\|export\\|attach\\)$"
          "~$"
          "^#.*#$"))
  (evil-leader/set-key
    "d" 'neotree-toggle)

  (evil-define-key 'normal neotree-mode-map (kbd "RET") 'neotree-enter)
  (evil-define-key 'normal neotree-mode-map (kbd "TAB") 'neotree-stretch-toggle)
  (evil-define-key 'normal neotree-mode-map (kbd "q") 'neotree-hide)
  (evil-define-key 'normal neotree-mode-map (kbd "l") 'neotree-enter)
  (evil-define-key 'normal neotree-mode-map (kbd "h") 'mymacs/neotree-collapse-or-up))

;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ COMPANY ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
(use-package company
  :config
  (setq
   company-minimum-prefix-length 0
   company-idle-delay 0
   company-dabbrev-downcase nil
   company-dabbrev-ignore-case nil
   company-dabbrev-code-other-buffers t
   company-tooltip-flip-when-above t
   company-frontends '(company-pseudo-tooltip-frontend company-echo-metadata-frontend)
   company-backends '(company-capf)
   company-global-modes '(not eshell-mode comint-mode erc-mode message-mode help-mode))

  (global-company-mode +1))
(use-package company-quickhelp
  :config
  (setq company-quickhelp-delay 0)
  (company-quickhelp-mode 1))
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ WHICH KEY ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
(use-package which-key
 	:config
 	(which-key-mode +1))
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ SMARTPARENS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

(use-package smartparens
  :config
  (smartparens-global-mode 1)
  (require 'smartparens-config))
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ HELM ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
(use-package helm
  :demand t
  :init
  (setq helm-candidate-number-limit 50
        helm-display-header-line nil
        helm-ff-auto-update-initial-value nil
        helm-find-files-doc-header nil
        helm-split-window-in-side-p t
        helm-buffers-fuzzy-matching t
        helm-move-to-line-cycle-in-source t)

  :config
  (require 'helm-config)
  (helm-mode 1)

  (global-set-key (kbd "M-x") 'helm-M-x)
  (global-set-key (kbd "M-y") 'helm-show-kill-ring)
  (global-set-key (kbd "C-x b") 'helm-mini)
  (global-set-key (kbd "C-x C-b") 'helm-buffers-list)
  (global-set-key (kbd "C-x C-f") 'helm-find-files)
  (global-set-key (kbd "C-h f") 'helm-apropos)
  (global-set-key (kbd "C-h r") 'helm-info-emacs)

  (which-key-declare-prefixes ", h" "Helm")
  (evil-leader/set-key
    "ff" 'helm-find-files
    "fr" 'helm-recentf
    ;; Needs ag (silver-searcher) to be installed
    "hp" 'helm-do-grep-ag
    "hf" 'helm-occur
    "hw" 'helm-wikipedia-suggest))

(use-package helm-dash
  :config
  (evil-leader/set-key "hd" 'helm-dash-at-point))

;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ YAS SNIPPET ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
(use-package yasnippet
  :config
  (yas-global-mode 1)
  ;; Disabled it due to problems on company's normal work
  ;; (add-to-list 'company-backends '(company-yasnippet)))
  )

  (use-package helm-c-yasnippet
  :config
  (global-set-key (kbd "C-c y") 'helm-yas-complete))

;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ORG MODE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
(which-key-declare-prefixes ", o" "Org Mode")

(evil-leader/set-key
  "oa" 'org-agenda
  "ol" 'org-store-link
  "ob" 'org-iswitchb)

(org-babel-do-load-languages 'org-babel-load-languages
    '((shell . t)
      (dot . t)
      (python . t)
      (gnuplot . t)
      (org . t)
      (ditaa . t)
      (latex . t)))

;; (el-get-bundle org-wiki
;;   :url "https://raw.githubusercontent.com/caiorss/org-wiki/master/org-wiki.el"
;;   :description "Emacs' desktop wiki built with org-mode"
;;   :features org-wiki)

;; (setq org-wiki-location "~/Work/Wiki")
;; (setq org-wiki-server-host "127.0.0.1") ;; Listen only localhost 
;; (setq org-wiki-server-port "8181")

;; (require 'org-wiki)
;; (which-key-declare-prefixes ", ow" "Org Wiki")
;; (evil-leader/set-key
;;   "owh" 'org-wiki-help
;;   "owi" 'org-wiki-index
;;   "owo" 'org-wiki-helm
;;   "owb" 'org-wiki-switch
;;   "owx" 'org-wiki-close
;;   "owl" 'org-wiki-link
;;   "ows" 'org-wiki-server-toggle
;;   "owe" 'org-wiki-export-html-sync)

;; (setq org-confirm-babel-evaluate nil)

;; Some useful configs from http://ergoemacs.org/emacs/emacs_org_mode_customization.html
(progn
  ;; org-mode setup
  ;; when opening a org file, don't collapse headings
  ;; (setq org-startup-folded nil)
  ;; wrap long lines. don't let it disappear to the right
  (setq org-startup-truncated nil)
  ;; when in a url link, enter key should open it
  (setq org-return-follows-link t)
  ;; make org-mode” syntax color embedded source code
  (setq org-src-fontify-natively t))

  (use-package org-bullets
  :config
  (add-hook 'org-mode-hook #'org-bullets-mode))

  (use-package evil-org
  :config
  (add-hook 'org-mode-hook (lambda () (evil-org-mode +1))))

;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ HTMLIZE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
(use-package htmlize
  :defer t)    

;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ UNDO TREE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
(use-package undo-tree
  :diminish undo-tree-mode
  :config
  (progn
    (global-undo-tree-mode)
    (setq undo-tree-visualizer-timestamps t)
    (setq undo-tree-visualizer-diff t))) 

;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ TELEPHONE LINE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
(use-package telephone-line
  :config
  (telephone-line-defsegment* mymacs-telephone-line-buffer-info ()
    (when (and (eq 'python-mode major-mode)
               (bound-and-true-p pyvenv-virtual-env-name))
      (telephone-line-raw (format "pyvenv: %s" pyvenv-virtual-env-name) t)))

  (setq telephone-line-lhs
        '((evil   . (telephone-line-evil-tag-segment))
          (accent . (telephone-line-major-mode-segment))
          (evil   . (telephone-line-buffer-segment))
          (nil    . (telephone-line-minor-mode-segment))))
  
  (setq telephone-line-rhs
        '((nil    . (telephone-line-misc-info-segment))
          (evil   . (mymacs-telephone-line-buffer-info))
          (accent . (telephone-line-vc-segment
                     telephone-line-erc-modified-channels-segment
                     telephone-line-process-segment))
          (evil   . (telephone-line-airline-position-segment))))

  (require 'telephone-line)
  (require 'telephone-line-config)
  (telephone-line-mode t))

;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ MODE ICONS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
(use-package mode-icons
  :config
  (mode-icons-mode))
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ VOLATILE HIGHLIGHT ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;; Flashed current change on block of text
(use-package volatile-highlights
  :config
  (volatile-highlights-mode t))

;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ EMOJIFY ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
(use-package emojify
  :config
  (add-hook 'after-init-hook #'global-emojify-mode))

;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ AVY ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
(use-package avy
  :config
  (evil-leader/set-key
    "," 'avy-goto-word-or-subword-1))

;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ BEACON ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
(use-package beacon
  :config
  (beacon-mode +1))

;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ IEDIT ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
(use-package iedit
  :config
  (which-key-declare-prefixes ", s" "Search")
  (evil-leader/set-key "se" 'iedit-mode))
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ MAGIT ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
(use-package evil-magit)

(use-package magit
  :config
  (which-key-declare-prefixes ", g" "Version Control")
  (evil-leader/set-key "gs" 'magit-status))

;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ WHICH FUNC ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
(use-package which-func
  :config
  (setq which-func-unknown "n/a")
  (which-function-mode))

;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ EXEC PATH FROM SHELL ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
(use-package exec-path-from-shell
  :config
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)))

;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ FZF Search ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  (use-package fzf
    :ensure t)
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ PROJECTILE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
(defun neotree-find-project-root ()
  (interactive)
  (if (neo-global--window-exists-p)
      (neotree-hide)
    (let ((origin-buffer-file-name (buffer-file-name)))
      (neotree-find (projectile-project-root))
      (neotree-find origin-buffer-file-name))))

(use-package projectile
  :after helm
  :config
  (setq projectile-completion-system 'helm)

  (evil-leader/set-key
    "pt" 'neotree-find-project-root))

(setq projectile-project-search-path '("C:\\Users\\tinh5\\OneDrive\\Documents\\Projects"))
(use-package helm-projectile
  :after
  helm
  projectile
  :config
  (evil-leader/set-key
    "fp" 'helm-projectile))

;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ FLY CHECK ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

(use-package fringe-helper)
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ FLY CHECK ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
(use-package flycheck
  :init
  (global-flycheck-mode)
  :config
  (setq flycheck-indication-mode 'right-fringe)
  (fringe-helper-define 'flycheck-fringe-bitmap-double-arrow 'center
                        "...X...."
                        "..XX...."
                        ".XXX...."
                        "XXXX...."
                        ".XXX...."
                        "..XX...."
                        "...X....")
  (add-hook 'prog-mode-hook 'flycheck-mode))

(use-package flycheck-pos-tip
  :after flycheck
  :config
  (setq flycheck-pos-tip-timeout 10
        flycheck-display-errors-delay 0.5)
  (flycheck-pos-tip-mode +1))

;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ RAINBOW DELIMETERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
(use-package rainbow-delimiters
  :config
  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))

;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ JS2 MODE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
(defun javascript-doc ()
  "Dfine Javascript docs for helm-dash."
  (interactive)
  (setq-local helm-dash-docsets '("JavaScript")))

(defun mymacs/js2-mode-hook ()
  (javascript-doc)
  (setq flycheck-checker 'javascript-standard))

(use-package js2-mode
  :mode "\\.js$"
  :interpreter "node"
  :config
  (setq js2-skip-preprocessor-directives t
        js2-highlight-external-variables nil
        js2-mode-show-parse-errors nil
        js2-mode-show-strict-warnings nil)

  (setq-default js2-basic-offset 2)

  (add-hook 'js2-mode-hook 'mymacs/js2-mode-hook))

(use-package xref-js2)

;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ TERN ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
(use-package tern
  :init (add-hook 'js2-mode-hook #'tern-mode)
  :config
  (setq tern-command '("tern")))

(use-package company-tern
  :after
  tern
  company
  :config
  (add-to-list 'company-backends 'company-tern))

;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ PRETTIER ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
(use-package prettier-js
  :commands prettier-js-mode
  :diminish prettier-js-mode

  :preface
  (eval-when-compile
    (defvar prettier-js-args)
    (defvar prettier-js-diff-command))

  :init
  (setq prettier-js-args
        '("--trailing-comma" "all"
          "--tab-width" "4"))
  (when (executable-find "gdiff")
    (setq prettier-js-diff-command "gdiff"))
  (add-hook 'css-mode-hook 'prettier-js-mode)
  (add-hook 'js2-mode-hook 'prettier-js-mode)
  (add-hook 'rjsx-mode-hook 'prettier-js-mode)
  (add-hook 'json-mode-hook 'prettier-js-mode)
  (add-hook 'markdown-mode-hook 'prettier-js-mode))
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ RJSX MODE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

(use-package rjsx-mode
  :mode "\\.jsx$"
  :mode "components/.+\\.js$"
  :init
  ;; auto-detect JSX file
  ;; source: https://github.com/hlissner/.emacs.d/blob/master/modules/lang/javascript/config.el
  (push (cons (lambda ()
                (and buffer-file-name
                     (equal (file-name-extension buffer-file-name) "js")
                     (re-search-forward "\\(^\\s-*import React\\|\\( from \\|require(\\)[\"']react\\)"
                                        magic-mode-regexp-match-limit t)
                     (progn
                       (goto-char (match-beginning 1))
                       (not (sp-point-in-string-or-comment)))))
              'rjsx-mode)
        magic-mode-alist))

;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ KEYBINDINGS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
(defun kill-current-buffer ()
  "Kill current buffer"
  (interactive)
  (kill-buffer (current-buffer)))

(which-key-declare-prefixes ", w" "Windows")
(which-key-declare-prefixes ", b" "Buffers")
(which-key-declare-prefixes ", t" "Text")
(which-key-declare-prefixes ", f" "Files")
(evil-leader/set-key
  "fs" 'save-buffer
  "w/" 'split-window-right
  "w-" 'split-window-below
  "wd" 'delete-window
  "bd" 'kill-current-buffer
  "tr" 'align-regexp)

;; Font size
(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)

;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ MISC ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
(use-package gitignore-mode)
(use-package gitconfig-mode)

;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ FONT ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

(defun mymacs/check-font-exists (font)
  "Check if FONT is installed on the system."
  (if (find-font (font-spec :name font))
      t
    nil))

(defun mymacs/set-font (font &optional range)
  "Set FONT if it is installed or message otherwise."
  (when window-system
    (if (mymacs/check-font-exists font)
        (if range
            (set-fontset-font "fontset-default" range font)
          (set-frame-font font)) 
      (message "Font %s doesn't exists" font))))

(defun mymacs-set-user-fonts ()
  "Set user defined fonts from mymacs-frame-font."
  (interactive)

  (dolist (font mymacs-frame-font)
    (if (stringp font)
        (mymacs/set-font font))
    (if (listp font)
        (mymacs/set-font (nth 0 font) (nth 1 font)))))

(mymacs-set-user-fonts)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (neotree evil-leader key-chord evil-surround evil-goggles evil-expat evil-visualstar evil-replace-with-register evil-exchange evil-commentary evil-lion evil-collection evil use-package tangotango-theme))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(evil-goggles-change-face ((t (:inherit diff-removed))))
 '(evil-goggles-delete-face ((t (:inherit diff-removed))))
 '(evil-goggles-paste-face ((t (:inherit diff-added))))
 '(evil-goggles-undo-redo-add-face ((t (:inherit diff-added))))
 '(evil-goggles-undo-redo-change-face ((t (:inherit diff-changed))))
 '(evil-goggles-undo-redo-remove-face ((t (:inherit diff-removed))))
 '(evil-goggles-yank-face ((t (:inherit diff-changed)))))
