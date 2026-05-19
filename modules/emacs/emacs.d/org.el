;; -*- lexical-binding: t; -*-

;; Put general org mode tweaks here.
(use-package org-mode
  :defer t
  :custom
  (org-hide-emphasis-markers t)

  ;; Improve the rendering and size of org latex previews.
  (org-preview-latex-default-process 'dvisvgm)

  :hook
  (org-mode . visual-line-mode)
  (org-mode . org-indent-mode)
  (org-mode . org-fragtog-mode)

  ;; Decrease default latex fragment size.
  (org-mode . (lambda ()
                (setq org-format-latex-options
                      (plist-put org-format-latex-options :scale 0.8))))
  (latex-mode . 'turn-on-cdlatex))



;; Superstar is a package for pretty org mode bullet points.
(use-package org-superstar
  :hook (org-mode))

(use-package tex
  :ensure auctex)

(use-package anki-editor
  :custom (anki-editor-latex-style 'mathjax))
