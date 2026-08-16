;;; early-init.el --- loaded before the GUI and package system -*- lexical-binding: t; -*-
;;; Commentary:
;; Managed via dotfiles: edit dotfiles/emacs/, deploy with install.sh.
;; Runs before init.el and before the first frame — the right place to
;; kill UI chrome (prevents a visible flash) and defer GC for startup.
;;; Code:

;; Defer garbage collection during startup; init.el restores it
(setq gc-cons-threshold most-positive-fixnum)

;; We drive package.el ourselves in init.el
(setq package-enable-at-startup nil)

;; No menu bar, tool bar, scroll bars, or startup screen — terminal-first
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)
(setq inhibit-startup-screen t
      inhibit-startup-echo-area-message user-login-name)

;; Quieter native compilation (Emacs 29+)
(when (boundp 'native-comp-async-report-warnings-errors)
  (setq native-comp-async-report-warnings-errors 'silent))

;;; early-init.el ends here
