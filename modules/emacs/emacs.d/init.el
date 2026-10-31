;; -*- lexical-binding: t; -*-

(use-package emacs
  :init
  ;; Disable toolbar, menu bar, and scroll bar.
  (tool-bar-mode   -1)
  (scroll-bar-mode -1)
  (menu-bar-mode   -1)

  ;; Disable left-right fringes and add a uniform border width.
  (set-fringe-mode 0)
  (add-to-list 'default-frame-alist '(internal-border-width . 7))

  ;; Windmove gives easy keybindings to navigate across windows.
  (windmove-default-keybindings)
  (windmove-swap-states-default-keybindings '(control shift))

  ;; Helper function to get user files.
  (defun user-file (file-path)
    (expand-file-name (concat user-emacs-directory file-path)))

  ;; Braille is not rendered well in Emacs terminals with my font,
  ;; so this function overrides the font used for braille characters.
  (defun my/setup-braille-font (&optional frame)
    "Set Caskaydia as the braille fallback for the given FRAME."

    (let ((font "CaskaydiaMono Nerd Font Mono"))
     (set-fontset-font t 'braille (font-spec :family font) frame 'prepend)))

  (my/setup-braille-font)
  (set-face-attribute 'default nil :family "FiraCode Nerd Font Mono" :height 105)

  (load "auctex.el" nil t t)
  (setq TeX-auto-save t)
  (setq TeX-parse-self t)

  :bind
  ;; Custom prefix map.
  (:prefix-map personal-map
               :prefix "C-z"
               :prefix-docstring "Personal keybindings prefix"
               ("z" . suspend-frame))

  :custom
  (tab-always-indent 'complete) ; Enable indentation + completion using the TAB key.
  (indent-tabs-mode nil)       ; Do not indent with the tab character.

  (custom-file
   (expand-file-name
    (concat user-emacs-directory "custom.el"))) ; Write variables into a separate file.

  (explicit-shell-file-name (executable-find "nu"))          ; Find nushell executable for interactive
  (native-comp-compiler-options '("-O3" "-march=x86-64-v3" "-mtune=native"))

  :hook
  (prog-mode-hook . display-line-numbers-mode)
  (prog-mode-hook . electric-pair-mode)

  (after-make-frame-functions . my/setup-braille-font)
  (after-make-frame-functions
   . (lambda (frame) (set-frame-parameter frame 'alpha-background 85))))

;; Configure packages related to more efficient navigation.
(load-file (user-file "navigation.el"))

;; Completion frameworks.
(load-file (user-file "completion.el"))

;; Configuration that improves the Emacs editing experience.
(load-file (user-file "edition.el"))

;; Lsp and programming language support related configuration.
(load-file (user-file "lsp.el"))

;; Load magit configuration.
(load-file (user-file "magit.el"))

;; Emacs configuration which helps with documentation.
(load-file (user-file "documentation.el"))

;; Configuration that primarily concerns itself with keybindings.
(load-file (user-file "keybinds.el"))

;; Org mode tweaks.
(load-file (user-file "org.el"))

;; Random configurations that do not fit the previous categories but provide minor improvements.
(load-file (user-file "qol.el"))

