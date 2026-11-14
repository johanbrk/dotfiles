;; -*- lexical-binding: t; -*-

(use-package emacs
  :init
  ;; Add smart open line, the idea and code came from this site:
  ;; https://emacsredux.com/blog/2013/03/26/smarter-open-line/.
  (defun my/smart-open-line ()
    "A smarter open line that inserts indentation."
    (interactive)
    (move-end-of-line nil)
    (newline-and-indent))

  ;; Scroll the text half a page up.
  (defun my/scroll-half-up (&optional arg)
    "Move half a page up. If an argument is supplied it is passed to 'scroll-up-command'."
    (interactive)
    (if arg
        (scroll-up-command arg)
        (scroll-up-command (round (/ (window-body-height) 2.618)))))

  ;; Scroll the text half a page down.
  (defun my/scroll-half-down (&optional arg)
    "Move half a page down. If an argument is supplied it is passed to 'scroll-down-command'."
    (interactive)
    (if arg
      (scroll-down-command arg)
      (scroll-down-command (round (/ (window-body-height) 2.618)))))

  ;; This is something that I found myself doing frequently.
  ;; It just checks the grammar for a single line of text.
  (defun my/spellcheck-til-line-end ()
    "Spell check from the current cursor position until the end of the line."

    (interactive)
    (push-mark)
    (activate-mark)
    (move-end-of-line nil)
    (ispell-region (region-beginning) (region-end)))

  :bind
  ("M-o" . my/smart-open-line)             ; Vim-like open line.

  ("C-v" . my/scroll-half-up)
  ("M-v" . my/scroll-half-down)

  ("C-c c" . my/spellcheck-til-line-end)
  ("M-RET" . eat))

;; Load transient package for custom keybind modes.
(use-package transient)

;; Add kitty terminal protocol extension for terminal compatibility.
(use-package kkp
  :config (global-kkp-mode t))

