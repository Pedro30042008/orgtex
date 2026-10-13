;; SPDX-License-Identifier: MPL-2.0

;;; orgtex-config.el --- OrgTeX document configuration -*- lexical-binding: t; -*-

(require 'org)
(require 'org-element)

(defconst orgtex-config-supported-keywords
  '("FAMILY"
    "VARIANT"
    "THEME"
    "COVER"
    "LANGUAGE")
  "Supported OrgTeX document configuration keyword names.")

(defun orgtex-config--keyword-name (name)
  "Return the complete Org keyword name for NAME."
  (concat "ORGTEX_" name))

(defun orgtex-config--supported-keyword-p (name)
  "Return non-nil when OrgTeX configuration NAME is supported."
  (member name orgtex-config-supported-keywords))

(defun orgtex-config--validate-name (name)
  "Validate OrgTeX configuration keyword NAME.

Return NAME when it is supported.
Signal an error when NAME is unknown."
  (unless (orgtex-config--supported-keyword-p name)
    (error
     "OrgTeX: unknown configuration keyword ORGTEX_%s. Expected one of: %s"
     name
     (mapconcat
      (lambda (keyword)
        (concat "ORGTEX_" keyword))
      orgtex-config-supported-keywords
      ", ")))
  name)

(defun orgtex-config--read-keyword (name)
  "Read OrgTeX keyword NAME from the current Org buffer.

Return the keyword value as a string, or nil when the keyword is absent."
  (orgtex-config--validate-name name)
  (let* ((keyword (orgtex-config--keyword-name name))
         (result (org-collect-keywords (list keyword)))
         (entry (assoc keyword result)))
    (when entry
      (car (cdr entry)))))

(defun orgtex-config--document-keywords ()
  "Return all ORGTEX_ keyword names present in the current Org buffer.

The returned names do not include the ORGTEX_ prefix."
  (let (keywords)
    (org-element-map
        (org-element-parse-buffer)
        'keyword
      (lambda (element)
        (let ((key (upcase (org-element-property :key element))))
          (when (string-prefix-p "ORGTEX_" key)
            (push (substring key (length "ORGTEX_"))
                  keywords)))))
    (delete-dups (nreverse keywords))))

(defun orgtex-config--validate-document-keywords ()
  "Validate all ORGTEX_ keyword names in the current Org buffer.

Signal an error when an unknown or misspelled keyword is present."
  (dolist (name (orgtex-config--document-keywords))
    (orgtex-config--validate-name name)))

(defun orgtex-config-get (name)
  "Read OrgTeX configuration NAME from the current Org buffer.

NAME must be the keyword suffix without the ORGTEX_ prefix.

For example:

  (orgtex-config-get \"LANGUAGE\")

This function validates the keyword name but does not validate its value.
Value validation belongs to the specialized OrgTeX registries."
  (orgtex-config--read-keyword name))

(defun orgtex-config-read ()
  "Read the supported OrgTeX configuration from the current Org buffer.

Return an association list containing the configuration values that are
present in the document.

Unknown ORGTEX_ keyword names are rejected. Values are returned without
semantic validation because specialized OrgTeX registries are responsible for
validating them."
  (orgtex-config--validate-document-keywords)
  (let (config)
    (dolist (name orgtex-config-supported-keywords)
      (let ((value (orgtex-config-get name)))
        (when value
          (push (cons name value) config))))
    (nreverse config)))

(provide 'orgtex-config)

;;; orgtex-config.el ends here
