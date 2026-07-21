;; -*- lexical-binding: t; -*-

;; Embark provides actions on buffer targets.
(use-package embark
  :bind
  ("C-;"   . embark-act)
  ("M-."   . embark-dwim)
  ("C-h B" . embark-bindings)

  ;; Add custom variable for embark indicator.
  :custom (embark-indicators '(embark-minimal-indicator
			       embark-highlight-indicator
			       embark-isearch-highlight-indicator)))

;; Add embark consult integration.
(use-package embark-consult
  :hook (embark-collect-mode . consult-preview-at-point-mode))

;; Add multiple cursor functionality to Emacs.
(use-package multiple-cursors
  :bind
  ("C-c M" . 'mc/edit-lines)

  ("C->" . 'mc/mark-next-like-this)
  ("C-<" . 'mc/mark-previous-like-this)
  ("C-c C-<" . 'mc/mark-all-like-this))

;; Wgrep is a powerful grep editing plugin.
(use-package wgrep)

;; This package provides semantic region expansion.
(use-package expand-region
  :bind ("C-=" . er/expand-region))

;; An undo-tree for Emacs.
(use-package vundo
  :bind ("C-c u" . vundo))

