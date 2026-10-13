;; SPDX-License-Identifier: MPL-2.0

;;; orgtex-export.el --- Minimal OrgTeX Org Mode export integration -*- lexical-binding: t; -*-

(require 'org)
(require 'ox-latex)

(require 'orgtex-config)
(require 'orgtex-family)

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
      (orgtex-export--apply-language)
      (org-latex-export-to-latex))))

(provide 'orgtex-export)

;;; orgtex-export.el ends here
