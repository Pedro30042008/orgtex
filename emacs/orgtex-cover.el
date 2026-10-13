;; SPDX-License-Identifier: MPL-2.0

;;; orgtex-cover.el --- OrgTeX document cover registry -*- lexical-binding: t; -*-

(defconst orgtex-cover-registry
  '(("none"
     :package nil
     :families ("article-document"))
    ("simple"
     :package "orgtex-cover-simple"
     :families ("article-document")))
  "Registry of public OrgTeX covers and their implementation packages.")

(defun orgtex-cover-get (cover)
  "Return the registry entry associated with OrgTeX COVER.

Signal an error when COVER is not registered."
  (let ((entry (assoc cover orgtex-cover-registry)))
    (unless entry
      (error
       "OrgTeX: unsupported document cover '%s'. Expected one of: %s"
       cover
       (mapconcat #'car orgtex-cover-registry ", ")))
    entry))

(defun orgtex-cover-get-package (cover)
  "Return the LaTeX package associated with OrgTeX COVER.

Return nil when COVER does not require a LaTeX package."
  (plist-get (cdr (orgtex-cover-get cover)) :package))

(defun orgtex-cover-supported-for-family-p (cover family)
  "Return non-nil when COVER supports FAMILY."
  (let* ((entry (orgtex-cover-get cover))
         (families (plist-get (cdr entry) :families)))
    (member family families)))

(defun orgtex-cover-validate-for-family (cover family)
  "Validate that OrgTeX COVER supports FAMILY.

Return COVER when the combination is valid.
Signal an error when the combination is unsupported."
  (unless (orgtex-cover-supported-for-family-p cover family)
    (error
     "OrgTeX: cover '%s' is not supported for family '%s'"
     cover
     family))
  cover)

(provide 'orgtex-cover)

;;; orgtex-cover.el ends here
