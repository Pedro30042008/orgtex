;; SPDX-License-Identifier: MPL-2.0

;;; orgtex-variant.el --- OrgTeX document variant registry -*- lexical-binding: t; -*-

(defconst orgtex-variant-registry
  '(("simple-document"
     :families ("article-document")))
  "Registry of public OrgTeX document variants and their supported families.")

(defun orgtex-variant-get (variant)
  "Return the registry entry associated with OrgTeX VARIANT.

Signal an error when VARIANT is not registered."
  (let ((entry (assoc variant orgtex-variant-registry)))
    (unless entry
      (error
       "OrgTeX: unsupported document variant '%s'. Expected one of: %s"
       variant
       (mapconcat #'car orgtex-variant-registry ", ")))
    entry))

(defun orgtex-variant-supported-for-family-p (variant family)
  "Return non-nil when VARIANT supports FAMILY."
  (let* ((entry (orgtex-variant-get variant))
         (families (plist-get (cdr entry) :families)))
    (member family families)))

(defun orgtex-variant-validate-for-family (variant family)
  "Validate that OrgTeX VARIANT supports FAMILY.

Return VARIANT when the combination is valid.
Signal an error when the combination is unsupported."
  (unless (orgtex-variant-supported-for-family-p variant family)
    (error
     "OrgTeX: variant '%s' is not supported for family '%s'"
     variant
     family))
  variant)

(provide 'orgtex-variant)

;;; orgtex-variant.el ends here
