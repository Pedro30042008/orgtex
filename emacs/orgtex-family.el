;; SPDX-License-Identifier: MPL-2.0

;;; orgtex-family.el --- OrgTeX document family registry -*- lexical-binding: t; -*-

(defconst orgtex-family-registry
  '(("article-document" . "orgtex-article"))
  "Mapping from public OrgTeX family names to internal LaTeX classes.")

(defun orgtex-family-get-latex-class (family)
  "Return the LaTeX class associated with OrgTeX FAMILY.

Signal an error when FAMILY is not registered."
  (let ((latex-class (cdr (assoc family orgtex-family-registry))))
    (unless latex-class
      (error
       "OrgTeX: unsupported document family '%s'. Expected one of: %s"
       family
       (mapconcat #'car orgtex-family-registry ", ")))
    latex-class))

(provide 'orgtex-family)

;;; orgtex-family.el ends here
