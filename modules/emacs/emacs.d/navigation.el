;; -*- lexical-binding: t; -*-

;; Use consult for better searching interfaces.
(use-package consult
  :bind
  ;; Buffer switching using consult.
  ("C-x b" . consult-buffer)            ; Orig. switch-to-buffer.

  ("M-y" . consult-yank-pop)            ; Orig. yank-pop.

  ("M-g f"   . consult-flymake)
  ("M-g M-g" . consult-goto-line)       ; Orig. goto-line.
  ("M-g g"   . consult-goto-line)       ; Orig. goto-line.
  ("M-g m"   . consult-mark)
  ("M-g i"   . consult-imenu)
  ("M-g I"   . consult-imenu-multi)
  ("M-g o"   . consult-outline)

  ;; Seaching commands.
  ("M-s d" . consult-fd)
  ("M-s c" . consult-locate)
  ("M-s r" . consult-ripgrep)
  ("M-s l" . consult-line)
  ("M-s L" . consult-line-multi)
  ("M-s k" . consult-keep-lines)
  ("M-s u" . consult-focus-lines)

  ;; Commands for fast register access.
  ("M-#" . consult-register-load)
  ("M-'" . consult-register-store)
  ("C-M-#" . consult-register)

  ("C-c h" . consult-history)
  ("C-c K" . consult-kmacro)
  ("C-c i" . consult-info)

  (:map isearch-mode-map

  ;; These keybindings help consult-line detect isearch.
  ("M-s l" . consult-line)
  ("M-s L" . consult-line-multi)))

;; Avy allows for fast jumping in buffers.
(use-package avy
  :config
  ;; Define avy embark actions from https://karthinks.com/software/avy-can-do-anything/.
  (defun my/avy-action-embark (pt)
    (unwind-protect
        (save-excursion
          (goto-char pt)
          (embark-act))
      (select-window (cdr (ring-ref avy-ring 0))))
    t)

  (defun my/avy-action-multilple-cursors (pt)
    "Add a multi-cursor using an avy jump."
    (save-excursion
      (goto-char pt)
      (mc/create-fake-cursor-at-point pt))

    (setq avy--old-cands nil)           ; Reset avy candidate list.

    ;; Enable multiple cursor mode after placing the fake cursor.
    (multiple-cursors-mode 1)

    t)

  (add-to-list 'avy-dispatch-alist '(?. . my/avy-action-embark))
  (add-to-list 'avy-dispatch-alist '(?c . my/avy-action-multilple-cursors))

  :bind
  ("C-:" . avy-goto-char-2)

  ("M-g e" . avy-goto-word-0)
  ("M-g w" . avy-goto-word-1)
  ("M-g l" . avy-goto-line)
  ("M-j" . avy-goto-char-timer)

  :custom (avy-timeout-seconds 0.3))

;; Enable package for automatic split resizing.
(use-package zoom
  :config (zoom-mode)

  :custom
  (zoom-ignored-major-modes '(dired-mode
                              dirvish-mode dirvish-directory-view-mode
                              dirvish-misc-mode dirvish-special-preview-mode))
  (zoom-size (lambda ()
               (cond
                ((derived-mode-p 'eat-mode) '(0.618 . 0.382))
                (t                          '(0.618 . 0.707))))))

;; Puni allows for smarter parenthesis behavior.
(use-package puni
  :defer t
  :init (puni-global-mode)
  :bind
  ;; Useful puni actions.
  ("C-c s" . puni-squeeze)
  ("C-c d r" . puni-raise)
  ("C-c d c" . puni-convolute)
  ("C-c d d" . puni-splice)
  ("C-c d s" . puni-split)
  ("C-c d t" . puni-transpose)

  ;; Commands to Wrap expressions.
  ("C-c w r" . puni-wrap-round)
  ("C-c w s"  . puni-wrap-square)
  ("C-c w c"  . puni-wrap-curly)
  ("C-c w a"  . puni-wrap-angle)

  ;; Add slurp and barf commands to Emacs.
  ("M-<right>" . puni-slurp-forward)
  ("M-<left>"  . puni-slurp-backward)
  ("M-<up>"    . puni-barf-forward)
  ("M-<down>"  . puni-barf-backward))

(use-package tab-bar
  :custom
  (tab-bar-show t)
  (tab-bar-close-button-show nil)
  (tab-bar-new-button-show nil)
  (tab-bar-tab-hints t)
  (tab-bar-select-tab-modifiers '(meta))
  (tab-bar-separator " ")
  (tab-bar-format '(tab-bar-format-tabs tab-bar-separator))
  :config
  (tab-bar-mode)
  (tab-bar-history-mode))

;; Activities provide workspaces to emacs.
(use-package activities
  :init
  (activities-mode)
  (activities-tabs-mode)

  :bind
  (:map personal-map
        ("a n" . activities-new)
        ("a d" . activities-define)
        ("a a" . activities-resume)
        ("a z" . activities-suspend)
        ("a C-k" . activities-kill)
        ("a RET" . activities-switch)
        ("a b" . activities-switch-buffer)
        ("a g" . activities-revert)
        ("a l" . activities-list)))

;; Beframe provides buffer isolation to frames.
(use-package beframe
  ;; Don't add *scratch* to global list.
  :custom (beframe-global-buffers '("*Messages*" "*Warnings*"))

  :config
  (beframe-mode)
  ;; Got the following configuration from https://protesilaos.com/emacs/beframe.
  (with-eval-after-load 'consult
    (defface beframe-buffer
      '((t :inherit font-lock-string-face))
      "Face for `consult' framed buffers.")

    (defun my/beframe-buffer-names-sorted (&optional frame)
      "Return the list of buffers from `beframe-buffer-names' sorted by visibility.
With optional argument FRAME, return the list of buffers of FRAME."
      (beframe-buffer-names frame :sort #'beframe-buffer-sort-visibility))

    (defvar beframe-consult-source
      `( :name     "Frame-specific buffers (current frame)"
         :narrow   ?F
         :category buffer
         :face     beframe-buffer
         :history  beframe-history
         :items    ,#'my/beframe-buffer-names-sorted
         :action   ,#'switch-to-buffer
         :state    ,#'consult--buffer-state))

    (add-to-list 'consult-buffer-sources 'beframe-consult-source)))

;; Swap dired mode's default behavior to not open a new buffer every time.
(use-package dired
  :init (put 'dired-find-alternate-file 'disabled nil)
  :bind (:map dired-mode-map
              ("RET" . dired-find-alternate-file)
              ("a"   . dired-find-file)
              ("^"   . (lambda () (interactive) (find-alternate-file "..")))))

(use-package dirvish
  :config (dirvish-override-dired-mode))
