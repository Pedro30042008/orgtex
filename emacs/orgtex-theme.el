;; SPDX-License-Identifier: MPL-2.0

;;; orgtex-theme.el --- OrgTeX document theme registry -*- lexical-binding: t; -*-

(defconst orgtex-theme-registry
  '(("minimal"
     :package "orgtex-theme-minimal"
     :families ("article-document")))
  "Registry of public OrgTeX themes and their implementation packages.")

(defun orgtex-theme-get (theme)
  "Return the registry entry associated with OrgTeX THEME.

Signal an error when THEME is not registered."
  (let ((entry (assoc theme orgtex-theme-registry)))
    (unless entry
      (error
       "OrgTeX: unsupported document theme '%s'. Expected one of: %s"
       theme
       (mapconcat #'car orgtex-theme-registry ", ")))
    entry))

(defun orgtex-theme-get-package (theme)
  "Return the LaTeX package associated with OrgTeX THEME."
  (plist-get (cdr (orgtex-theme-get theme)) :package))

(defun orgtex-theme-supported-for-family-p (theme family)
  "Return non-nil when THEME supports FAMILY."
  (let* ((entry (orgtex-theme-get theme))
         (families (plist-get (cdr entry) :families)))
    (member family families)))

(defun orgtex-theme-validate-for-family (theme family)
  "Validate that OrgTeX THEME supports FAMILY.

Return THEME when the combination is valid.
Signal an error when the combination is unsupported."
  (unless (orgtex-theme-supported-for-family-p theme family)
    (error
     "OrgTeX: theme '%s' is not supported for family '%s'"
     theme
     family))
  theme)

(provide 'orgtex-theme)

;;; orgtex-theme.el ends here
