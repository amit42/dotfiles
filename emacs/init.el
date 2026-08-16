;;; init.el --- dotfiles emacs config -*- lexical-binding: t; -*-
;;; Commentary:
;; Managed via dotfiles: edit dotfiles/emacs/, deploy with bash install.sh.
;; Same league as the nvim setup, same muscle memory (evil + Space
;; leader), same theme (reads ~/.config/dotfiles-theme like nvim and
;; wezterm do — never generated, so dotdoctor drift checks stay clean).
;;
;; Rough nvim ↔ emacs map:
;;   telescope            → vertico + consult      (SPC t f/g/b …)
;;   nvim-cmp             → corfu + cape
;;   lsp (mason servers)  → eglot (same binaries: clangd, gopls, …)
;;   gitsigns + fugitive  → diff-hl + magit        (SPC g s)
;;   lualine              → doom-modeline
;;   treesitter           → built-in treesit (Emacs 29+)
;;   which-key            → built-in which-key (Emacs 30)
;;; Code:

;; ── Startup performance ──────────────────────────────────
;; early-init.el maxed gc-cons-threshold; settle to 32MB after startup
(add-hook 'emacs-startup-hook
          (lambda () (setq gc-cons-threshold (* 32 1024 1024))))

;; ── Packages ─────────────────────────────────────────────
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))
(require 'use-package)
(setq use-package-always-ensure t)

;; ── Sane defaults ────────────────────────────────────────
(setq make-backup-files nil            ; no foo~ litter (git is the backup)
      auto-save-default nil
      create-lockfiles nil
      ring-bell-function 'ignore
      use-short-answers t              ; y/n instead of yes/no
      scroll-conservatively 101        ; no half-page jumps (vim feel)
      scroll-margin 8                  ; like nvim scrolloff
      require-final-newline t
      custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file) (load custom-file))

(global-auto-revert-mode 1)            ; pick up on-disk changes
(savehist-mode 1)                      ; minibuffer history across sessions
(save-place-mode 1)                    ; reopen files at last position
(recentf-mode 1)
(electric-pair-mode 1)                 ; autopairs
(global-display-line-numbers-mode 1)
(setq display-line-numbers-type 'relative)
(dolist (h '(org-mode-hook term-mode-hook eshell-mode-hook))
  (add-hook h (lambda () (display-line-numbers-mode 0))))

;; GUI font — terminal frames use the terminal's font
(when (display-graphic-p)
  (set-face-attribute 'default nil
                      :family "JetBrainsMono Nerd Font" :height 130))

;; ── Theme: follow ~/.config/dotfiles-theme ───────────────
;; Same pointer nvim and wezterm read. Each dotfiles theme maps to its
;; best available Emacs port; entries marked "approx" have no canonical
;; MELPA port, so the closest doom theme stands in.
(defvar my/theme-map
  '(("catppuccin-mocha" catppuccin-theme  catppuccin)
    ("tokyonight"       doom-themes       doom-tokyo-night)
    ("gruvbox"          doom-themes       doom-gruvbox)
    ("kanagawa"         kanagawa-themes   kanagawa-wave)
    ("rose-pine"        doom-themes       doom-one)        ; approx
    ("nord"             doom-themes       doom-nord)
    ("dracula"          doom-themes       doom-dracula)
    ("everforest"       doom-themes       doom-gruvbox)    ; approx
    ("onedark"          doom-themes       doom-one)))

(defun my/dotfiles-theme-name ()
  (let ((f (expand-file-name "~/.config/dotfiles-theme")))
    (if (file-readable-p f)
        (string-trim (with-temp-buffer (insert-file-contents f) (buffer-string)))
      "catppuccin-mocha")))

(let* ((entry (or (assoc (my/dotfiles-theme-name) my/theme-map)
                  (assoc "catppuccin-mocha" my/theme-map)))
       (pkg   (nth 1 entry))
       (theme (nth 2 entry)))
  (unless (package-installed-p pkg) (package-install pkg))
  (when (eq pkg 'catppuccin-theme)
    (setq catppuccin-flavor 'mocha))
  (load-theme theme t))

;; Wallpaper transparency parity: when ~/.config/dotfiles-wallpaper is
;; active (same switch as wezterm + nvim), terminal frames drop their
;; background so the wallpaper shows through.
(defun my/wallpaper-active-p ()
  (let ((f (expand-file-name "~/.config/dotfiles-wallpaper")))
    (and (file-readable-p f)
         (let ((p (string-trim (with-temp-buffer
                                 (insert-file-contents f) (buffer-string)))))
           (and (> (length p) 0) (file-exists-p (expand-file-name p)))))))

(defun my/apply-terminal-transparency (&optional frame)
  (let ((frame (or frame (selected-frame))))
    (unless (display-graphic-p frame)
      (when (my/wallpaper-active-p)
        (set-face-background 'default "unspecified-bg" frame)
        (set-face-background 'line-number "unspecified-bg" frame)))))
(add-hook 'window-setup-hook #'my/apply-terminal-transparency)
(add-hook 'after-make-frame-functions #'my/apply-terminal-transparency)

;; ── Evil: vim everywhere ─────────────────────────────────
(use-package evil
  :init
  (setq evil-want-integration t
        evil-want-keybinding nil       ; evil-collection handles modes
        evil-want-C-u-scroll t
        evil-undo-system 'undo-redo
        evil-split-window-below t
        evil-vsplit-window-right t)
  :config
  (evil-mode 1))

(use-package evil-collection             ; evil in magit, dired, org, …
  :after evil
  :config (evil-collection-init))

(use-package evil-surround               ; ys / cs / ds like nvim-surround
  :after evil
  :config (global-evil-surround-mode 1))

(use-package evil-commentary             ; gcc / gc like Comment.nvim
  :after evil
  :config (evil-commentary-mode 1))

(use-package evil-escape                 ; jk leaves insert mode
  :after evil
  :init (setq evil-escape-key-sequence "jk"
              evil-escape-delay 0.2)
  :config (evil-escape-mode 1))

;; ── Leader keys: mirror the nvim map ─────────────────────
(defvar my/leader-map (make-sparse-keymap))
(with-eval-after-load 'evil
  (evil-define-key '(normal visual) 'global (kbd "SPC") my/leader-map))
(define-key my/leader-map (kbd "w")   #'save-buffer)                  ; SPC w
(define-key my/leader-map (kbd "q")   #'evil-quit)                    ; SPC q
(define-key my/leader-map (kbd "x")   #'kill-current-buffer)          ; SPC x
(define-key my/leader-map (kbd "e")   #'dired-jump)                   ; SPC e
(define-key my/leader-map (kbd "t f") #'consult-fd)                   ; find files
(define-key my/leader-map (kbd "t g") #'consult-ripgrep)              ; live grep
(define-key my/leader-map (kbd "t b") #'consult-buffer)               ; buffers
(define-key my/leader-map (kbd "t r") #'consult-recent-file)          ; recent
(define-key my/leader-map (kbd "t /") #'consult-line)                 ; in-buffer
(define-key my/leader-map (kbd "t s") #'consult-imenu)                ; symbols
(define-key my/leader-map (kbd "t d") #'consult-flymake)              ; diagnostics
(define-key my/leader-map (kbd "g s") #'magit-status)                 ; git status
(define-key my/leader-map (kbd "l r") #'eglot-rename)                 ; rename
(define-key my/leader-map (kbd "l a") #'eglot-code-actions)           ; code action
(define-key my/leader-map (kbd "l f") #'eglot-format-buffer)          ; format

;; ── which-key (built into Emacs 30) ──────────────────────
(setq which-key-idle-delay 0.3)
(which-key-mode 1)

;; ── Minibuffer stack: the telescope equivalent ───────────
(use-package vertico
  :init (vertico-mode 1)
  :custom (vertico-cycle t))

(use-package orderless                   ; fuzzy-ish matching everywhere
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

(use-package marginalia                  ; annotations in the minibuffer
  :init (marginalia-mode 1))

(use-package consult
  :custom (consult-narrow-key "<"))

;; ── In-buffer completion: the cmp equivalent ─────────────
(use-package corfu
  :init (global-corfu-mode 1)
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.1)
  (corfu-auto-prefix 2)
  (corfu-cycle t))
(use-package corfu-terminal              ; corfu popups in -nw frames
  :unless (display-graphic-p)
  :config (corfu-terminal-mode 1))
(use-package cape
  :init
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev))

;; ── LSP: eglot (built-in), same servers as nvim ──────────
(dolist (h '(c-mode-hook c++-mode-hook c-ts-mode-hook c++-ts-mode-hook
             go-mode-hook go-ts-mode-hook
             python-mode-hook python-ts-mode-hook
             rust-mode-hook rust-ts-mode-hook))
  (add-hook h #'eglot-ensure))

;; ── Treesitter (built-in, Emacs 29+) ─────────────────────
(use-package treesit-auto                ; auto-install grammars, remap modes
  :custom (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode 1))

;; ── Git: gutter + magit ──────────────────────────────────
(use-package magit
  :commands (magit-status))

(use-package diff-hl                     ; gitsigns equivalent
  :hook ((prog-mode . diff-hl-mode)
         (magit-post-refresh . diff-hl-magit-post-refresh))
  :config
  (unless (display-graphic-p) (diff-hl-margin-mode 1)))

;; ── Modeline + icons ─────────────────────────────────────
(use-package nerd-icons)
(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom
  (doom-modeline-height 28)
  (doom-modeline-icon t))

;; ── Org mode ─────────────────────────────────────────────
;; Files live in ~/org; the todo() zsh habit stays markdown — org is for
;; real outlining/agenda work.
(use-package org
  :ensure nil                            ; built-in
  :custom
  (org-directory "~/org")
  (org-default-notes-file (expand-file-name "notes.org" org-directory))
  (org-agenda-files (list org-directory))
  (org-hide-emphasis-markers t)          ; *bold* renders bold, markers hidden
  (org-startup-indented t)               ; clean indented outline view
  (org-startup-folded 'content)
  (org-ellipsis " ▾")
  (org-todo-keywords '((sequence "TODO(t)" "DOING(i)" "|" "DONE(d)")))
  (org-log-done 'time)                   ; stamp when a task is closed
  :config
  (unless (file-directory-p org-directory) (make-directory org-directory t)))

(use-package org-modern                  ; the render-markdown of org
  :hook ((org-mode . org-modern-mode)
         (org-agenda-finalize . org-modern-agenda)))

(use-package evil-org                    ; vim keys inside org structures
  :after (evil org)
  :hook (org-mode . evil-org-mode)
  :config
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

;; org under the leader
(define-key my/leader-map (kbd "o a") #'org-agenda)                   ; SPC o a
(define-key my/leader-map (kbd "o c") #'org-capture)                  ; SPC o c
(define-key my/leader-map (kbd "o o") (lambda () (interactive)
                                        (find-file org-default-notes-file)))

;;; init.el ends here
