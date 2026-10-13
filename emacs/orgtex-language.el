;; SPDX-License-Identifier: MPL-2.0

;;; orgtex-language.el --- OrgTeX language registry -*- lexical-binding: t; -*-

(defconst orgtex-language-registry
  '(("es"
     :org-language "es")
    ("en"
     :org-language "en"))
  "Registry of public OrgTeX languages and their Org Mode mappings.")

(defun orgtex-language-get (language)
  "Return the registry entry associated with OrgTeX LANGUAGE.

Signal an error when LANGUAGE is not registered."
  (let ((entry (assoc language orgtex-language-registry)))
    (unless entry
      (error
       "OrgTeX: unsupported document language '%s'. Expected one of: %s"
       language
       (mapconcat #'car orgtex-language-registry ", ")))
    entry))

(defun orgtex-language-get-org-language (language)
  "Return the Org Mode language associated with OrgTeX LANGUAGE."
  (plist-get
   (cdr (orgtex-language-get language))
   :org-language))

(provide 'orgtex-language)

;;; orgtex-language.el ends here
