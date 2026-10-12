;; SPDX-License-Identifier: MPL-2.0

;;; orgtex-config.el --- OrgTeX document configuration -*- lexical-binding: t; -*-

(require 'org)

(defconst orgtex-config-supported-values
  '(("FAMILY"   . ("article-document"))
    ("VARIANT"  . ("simple-document"))
    ("THEME"    . ("minimal"))
    ("LANGUAGE" . ("es" "en")))
  "Supported OrgTeX document configuration values.")

(defun orgtex-config--keyword-name (name)
  "Return the complete Org keyword name for NAME."
  (concat "ORGTEX_" name))

(defun orgtex-config--read-keyword (name)
  "Read OrgTeX keyword NAME from the current Org buffer.

Return the keyword value as a string, or nil when the keyword is absent."
  (let* ((keyword (orgtex-config--keyword-name name))
         (result (org-collect-keywords (list keyword)))
         (entry (assoc keyword result)))
    (when entry
      (car (cdr entry)))))

(defun orgtex-config--validate-value (name value)
  "Validate VALUE for OrgTeX configuration NAME.

Return VALUE when it is valid.
Signal an error when VALUE is unsupported."
  (let ((allowed (cdr (assoc name orgtex-config-supported-values))))
    (unless allowed
      (error "OrgTeX: unknown configuration keyword ORGTEX_%s" name))
    (unless (member value allowed)
      (error
       "OrgTeX: invalid value '%s' for ORGTEX_%s. Expected one of: %s"
       value
       name
       (mapconcat #'identity allowed ", ")))
    value))

(defun orgtex-config-get (name)
  "Read and validate OrgTeX configuration NAME from the current buffer.

NAME must be the keyword suffix without the ORGTEX_ prefix.

For example:

  (orgtex-config-get \"LANGUAGE\")"
  (let ((value (orgtex-config--read-keyword name)))
    (when value
      (orgtex-config--validate-value name value))))

(defun orgtex-config-read ()
  "Read the supported OrgTeX configuration from the current Org buffer.

Return an association list containing the configuration values that are
present in the document."
  (let (config)
    (dolist (entry orgtex-config-supported-values)
      (let* ((name (car entry))
             (value (orgtex-config-get name)))
        (when value
          (push (cons name value) config))))
    (nreverse config)))

(provide 'orgtex-config)

;;; orgtex-config.el ends here
