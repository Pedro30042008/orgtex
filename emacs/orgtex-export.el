;; SPDX-License-Identifier: MPL-2.0

;;; orgtex-export.el --- Minimal OrgTeX Org Mode export integration -*- lexical-binding: t; -*-

(require 'org)
(require 'ox-latex)

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

(defun orgtex-export-file (file)
  "Export Org FILE to LaTeX using OrgTeX configuration."
  (let ((buffer (find-file-noselect file)))
    (with-current-buffer buffer
      (org-latex-export-to-latex))))

(provide 'orgtex-export)

;;; orgtex-export.el ends here
