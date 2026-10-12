# ADR 0001: Use MPL-2.0 as the OrgTeX license

## Status

Accepted

## Context

OrgTeX is intended to be free and open-source software while also supporting
a modular ecosystem of extensions, plugins and integrations.

The project should ensure that modifications made directly to OrgTeX source
files remain open when redistributed, without requiring independent modules
and extensions to use the same license.

## Decision

OrgTeX will use the Mozilla Public License 2.0 (MPL-2.0).

## Reasons

- File-level copyleft.
- Modifications to covered OrgTeX files remain open when distributed.
- Separate modules may use different licenses.
- Suitable for plugin-based and modular architectures.
- Commercial use is allowed.
- Patent grants are explicitly addressed.
- The license is widely recognized as an open-source license.

## Consequences

Contributors and distributors must comply with MPL-2.0 requirements for
covered source files.

Third-party dependencies and assets may use different compatible licenses and
must be documented separately.
