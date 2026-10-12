# ADR 0003: Use Org keywords for document configuration

## Status

Accepted

## Context

OrgTeX needs a portable and readable way for each Org document to declare
document-specific configuration.

Examples of document configuration include:

- document family;
- document variant;
- theme;
- cover;
- document language;
- numbering options;
- layout options;
- optional features.

The configuration format should remain compatible with normal Org Mode files
and should not depend on a specific operating system, local filesystem layout,
or machine-specific installation details.

OrgTeX is intended to support Linux, Windows, macOS, and containerized
workflows. Therefore, document configuration must describe document intent
rather than environment-specific implementation details.

## Decision

OrgTeX will use custom Org Mode keywords with the `ORGTEX_` prefix for
document-specific configuration.

Example:

```org
#+ORGTEX_FAMILY: article-document
#+ORGTEX_VARIANT: simple-document
#+ORGTEX_THEME: minimal
#+ORGTEX_LANGUAGE: es
```

These keywords will be parsed by OrgTeX and translated into the appropriate
internal configuration.

OrgTeX document keywords must describe the document itself and must remain
independent from the user's operating system or local installation.

For example, this is valid:

```org
#+ORGTEX_ENGINE: lualatex
```

This is not appropriate document configuration:

```org
#+ORGTEX_LATEX_PATH: /usr/bin/lualatex
```

Machine-specific information such as executable paths, Docker availability,
installed programs, or operating-system-specific settings belongs to the
environment configuration layer, not to the document configuration layer.

## Rationale

Using Org keywords provides several advantages:

- configuration remains inside the Org document;
- documents stay readable as normal Org Mode files;
- configuration is easy to edit manually;
- OrgTeX-specific metadata is clearly namespaced;
- no additional YAML, JSON, or TOML file is required for basic documents;
- documents remain portable across supported operating systems;
- the future OrgTeX CLI can generate and modify the same configuration format;
- unknown OrgTeX keywords do not prevent the file from being opened as a normal
  Org document.

## Configuration scope

Document keywords are intended for settings such as:

```text
family
variant
theme
cover
language
engine
numbering
layout
features
```

Environment-specific settings must be handled separately.

Examples of environment configuration include:

```text
Emacs executable location
LaTeX executable location
Docker availability
local installation paths
operating system
user-specific cache directories
```

## Compatibility

OrgTeX document configuration should remain portable between supported
environments.

A document created on Linux should not require changes to its OrgTeX document
keywords in order to compile on Windows, macOS, or in a supported container
environment.

The environment layer is responsible for locating and invoking the tools
required by the document.

## Consequences

OrgTeX must provide:

- a parser for `ORGTEX_` keywords;
- validation for supported keyword names and values;
- useful errors for invalid configuration;
- stable names for public configuration keywords;
- a clear distinction between document configuration and environment
  configuration.

Future configuration mechanisms may supplement Org keywords for advanced or
project-wide use cases, but Org keywords remain the primary per-document
configuration interface.
