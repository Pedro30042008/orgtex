;; SPDX-License-Identifier: MPL-2.0

;;; orgtex-export.el --- Minimal OrgTeX Org Mode export integration -*- lexical-binding: t; -*-

(require 'org)
(require 'ox-latex)

(require 'orgtex-config)
(require 'orgtex-family)
(require 'orgtex-variant)
(require 'orgtex-theme)
(require 'orgtex-cover)

;; Use LuaLaTeX as the default OrgTeX compiler.
(setq org-latex-compiler "lualatex")

;; Register the first OrgTeX LaTeX class.
(add-to-list
 'org-latex-classes
 '("orgtex-article"
   "\\documentclass{orgtex-article}"
   ("\\section{%s}" . "\\section*{%s}")
   ("\\subsection{%s}" . "\\subsection*{%s}")
   ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
   ("\\paragraph{%s}" . "\\paragraph*{%s}")
   ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

(defun orgtex-export--apply-family ()
  "Apply the OrgTeX document family to the current Org buffer."
  (let ((family (orgtex-config-get "FAMILY")))
    (when family
      (setq-local org-latex-default-class
                  (orgtex-family-get-latex-class family)))))

(defun orgtex-export--validate-variant ()
  "Validate the OrgTeX document variant against the selected family."
  (let ((family (orgtex-config-get "FAMILY"))
        (variant (orgtex-config-get "VARIANT")))
    (when (and family variant)
      (orgtex-variant-validate-for-family variant family))))

(defun orgtex-export--ensure-local-packages ()
  "Ensure `org-latex-packages-alist' is buffer-local."
  (unless (local-variable-p 'org-latex-packages-alist)
    (setq-local org-latex-packages-alist
                (copy-tree org-latex-packages-alist))))

(defun orgtex-export--add-package (package)
  "Append LaTeX PACKAGE to the current buffer export configuration."
  (when package
    (orgtex-export--ensure-local-packages)
    (let ((entry (list "" package)))
      (unless (member entry org-latex-packages-alist)
        (setq-local
         org-latex-packages-alist
         (append org-latex-packages-alist
                 (list entry)))))))

(defun orgtex-export--apply-theme ()
  "Validate and apply the OrgTeX document theme."
  (let ((family (orgtex-config-get "FAMILY"))
        (theme (orgtex-config-get "THEME")))
    (when theme
      (when family
        (orgtex-theme-validate-for-family theme family))
      (orgtex-export--add-package
       (orgtex-theme-get-package theme)))))

(defun orgtex-export--apply-cover ()
  "Validate and apply the OrgTeX document cover."
  (let ((family (orgtex-config-get "FAMILY"))
        (cover (orgtex-config-get "COVER")))
    (when cover
      (when family
        (orgtex-cover-validate-for-family cover family))
      (orgtex-export--add-package
       (orgtex-cover-get-package cover)))))

(defun orgtex-export--apply-language ()
  "Apply the OrgTeX document language to the current Org buffer."
  (let ((language (orgtex-config-get "LANGUAGE")))
    (when language
      (setq-local org-export-default-language
                  (pcase language
                    ("es" "es")
                    ("en" "en")
                    (_ language))))))

(defun orgtex-export-file (file)
  "Export Org FILE to LaTeX using OrgTeX configuration."
  (let ((buffer (find-file-noselect file)))
    (with-current-buffer buffer
      (orgtex-config-read)
      (orgtex-export--apply-family)
      (orgtex-export--validate-variant)
      (orgtex-export--apply-theme)
      (orgtex-export--apply-cover)
      (orgtex-export--apply-language)
      (org-latex-export-to-latex))))

(provide 'orgtex-export)

;;; orgtex-export.el ends here
