;; -*- lexical-binding: t; -*-

;; Use eglot as my lsp manager.
(use-package eglot
  :hook					; Add language hooks.
  (haskell-ts-mode . eglot-ensure)
  (nix-ts-mode     . eglot-ensure)
  (python-ts-mode  . eglot-ensure)

  :custom
  (eglot-autoshutdown t) ; shutdown language server after closing last file.
  (eglot-confirm-server-initiated-edits nil)) ; allow edits without confirmation.

;; Envrc automatically loads direnv environments in a per-buffer basis.
(use-package envrc
  :hook (after-init . envrc-global-mode))

;; Haskell mode configuration.
(use-package haskell-ts-mode)

;; Fira Code font for Emacs.
;; Remember to run fira-code-mode-install-fonts so that ligatures are rendered.
(use-package fira-code-mode
  :hook
  (prog-mode
   . (lambda () (when (display-graphic-p)
             (fira-code-mode 1))))

  :custom (fira-code-mode-disabled-ligatures '("x")))

;; More language modes.
(use-package nix-ts-mode :mode "\\.nix\\'")
(use-package idris2-mode)
(use-package racket-mode)

(use-package fennel-mode)

;; Install mode for lean4 proof assistant.
;; Fix: Emacs use-package declarations are order sensitive.
(use-package nael
  :vc ( :lisp-dir "nael"
        :url "https://codeberg.org/mekeor/nael.git")
  ;; Add hooks for lean4 files.
  :hook
  (nael-mode . eglot-ensure)
  (nael-mode . abbrev-mode))

(use-package pdf-tools)

;; Uiua mode.
(use-package uiua-ts-mode :mode "\\.ua\\'")

;; Remove Fira Code fonts when programming in BQN.
(use-package bqn-mode
  :hook (bqn-mode . (lambda () (fira-code-mode 0))))

;; Mode for kanata keyboard configuration.
(use-package kanata-kbd-mode
  :vc (:url "https://github.com/chmouel/kanata-kbd-mode/" :rev :newest))

(use-package j-mode
  ;; Change the binary name for the J programming language.
  :custom (j-console-cmd "jconsole")

  ;; Change default font colors for J.
  :custom-face
  (j-other-face ((t (:inherit font-lock-punctuation-face :foreground unspecified))))
  (j-verb-face ((t (:inherit font-lock-function-name-face :foreground unspecified))))
  (j-adverb-face ((t (:inherit font-lock-builtin-face :foreground unspecified))))
  (j-conjunction-face ((t (:inherit font-lock-keyword-face :foreground unspecified)))))

