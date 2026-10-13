;; SPDX-License-Identifier: MPL-2.0

;;; orgtex-export.el --- Minimal OrgTeX Org Mode export integration -*- lexical-binding: t; -*-

(require 'org)
(require 'ox-latex)

(require 'orgtex-config)
(require 'orgtex-family)
(require 'orgtex-variant)
(require 'orgtex-theme)

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

(defun orgtex-export--apply-theme ()
  "Validate and apply the OrgTeX document theme."
  (let ((family (orgtex-config-get "FAMILY"))
        (theme (orgtex-config-get "THEME")))
    (when theme
      (when family
        (orgtex-theme-validate-for-family theme family))

      (let ((package (orgtex-theme-get-package theme)))
        ;; Work with a buffer-local copy so OrgTeX does not modify the
        ;; user's global Org Mode LaTeX package configuration.
        (setq-local org-latex-packages-alist
                    (copy-tree org-latex-packages-alist))

        (add-to-list
         'org-latex-packages-alist
         (list "" package))))))

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
      (orgtex-export--apply-language)
      (org-latex-export-to-latex))))

(provide 'orgtex-export)

;;; orgtex-export.el ends here
