# OrgTeX Architecture

## 1. Purpose

OrgTeX is a modular, extensible and cross-platform document system built around
Org Mode and LaTeX.

Its main goal is to let users focus on content and document intent instead of
dealing directly with complex LaTeX configuration.

OrgTeX should make it possible to create professional documents with simple
high-level configuration while keeping LaTeX available as an advanced escape
hatch when necessary.

---

## 2. Core principles

OrgTeX follows these principles:

1. Prefer extension over modification.
2. Adding a new module should not require modifying unrelated existing modules.
3. Each module should have one clear responsibility.
4. Internal dependencies should remain as unidirectional as possible.
5. Configuration should override defaults in predictable layers.
6. The system must provide clear and human-friendly errors.
7. The system should be usable in Linux, Windows and macOS.
8. The user interface should support both Spanish and English.
9. Internal file and code names should use English.
10. User-visible labels may be translated.
11. Core document capabilities should be independent from visual themes.
12. Themes should define appearance, not document semantics.
13. Variants should describe purpose.
14. Families should describe structural document type.
15. Advanced LaTeX should remain optional for power users.

---

## 3. Naming conventions

Internal naming rules:

- English names.
- lowercase.
- kebab-case.
- no spaces.
- no accents.
- no ñ.
- descriptive names over abbreviations.
- `orgtex-` prefix when useful to avoid collisions.

Examples:

- `research-report.sty`
- `table-of-contents.sty`
- `list-of-figures.sty`
- `orgtex-article.cls`

User interface labels may be translated:

Spanish:
- Documento tipo artículo
- Tarea
- Tema académico

English:
- Article document
- Homework
- Academic theme

---

## 4. Main architecture

OrgTeX is divided into the following areas:

- core
- families
- variants
- themes
- covers
- features
- backends
- templates
- assets
- emacs integration
- CLI
- tests
- documentation

The conceptual flow is:

User
→ configuration
→ family
→ variant
→ theme
→ cover
→ features
→ core
→ backend
→ LaTeX
→ PDF

---

## 5. Core

The Core contains reusable document capabilities.

It defines what OrgTeX can do, not how a particular document should look.

Planned Core modules include:

- typography
- structure
- numbering
- text
- spacing
- breaks
- indentation
- lists
- mathematics
- quantities
- environments
- algorithms
- images
- figures
- tables
- graphs
- diagrams
- positioning
- layers
- columns
- cross-references
- notes
- links
- code
- boxes
- citations
- bibliography
- page-geometry
- page-orientation
- page-background
- headers
- footers
- pdf-metadata

### 5.1 Text capabilities

The Core should support:

- paragraphs
- bold
- italics
- underline
- strikethrough
- left alignment
- centered alignment
- right alignment
- justified text
- indentation
- local indentation
- spacing before and after text

### 5.2 Structure

The Core should support hierarchical structure such as:

- title
- subtitle
- part
- chapter
- section
- subsection
- subsubsection
- paragraph
- subparagraph

### 5.3 Lists

The Core should support:

- numbered lists
- unnumbered lists
- description lists

### 5.4 Mathematics

The Core should support mathematics at undergraduate level and beyond,
including:

- equations
- aligned equations
- systems
- matrices
- determinants
- vectors
- sets
- logic
- algebra
- calculus
- probability
- statistics
- theorems
- proofs
- scientific quantities and units

### 5.5 Images and positioning

Images should support:

- inline placement
- floating placement
- centered placement
- left and right placement
- wrapped text
- absolute placement
- anchored placement
- background placement
- foreground placement

Images should allow configuration of:

- width
- height
- scale
- margins
- padding
- caption
- layer
- alignment
- vertical offset
- horizontal offset

### 5.6 Layers

OrgTeX should support at least:

- background layer
- content layer
- foreground layer

This allows watermarks, decorative elements, stamps and overlays.

---

## 6. Numbering

Numbering must be configurable independently for content and navigation.

OrgTeX should support:

- section numbering
- chapter numbering
- subsection numbering
- equation numbering
- figure numbering
- table numbering
- graph numbering
- diagram numbering
- code numbering
- exercise numbering
- theorem numbering

Users should be able to control:

- whether numbering is enabled
- numbering depth
- where numbering begins
- initial number
- reset rules
- numbering format

The table of contents should independently control whether numbers are shown.

Example:

content:
- numbered sections

table of contents:
- unnumbered entries

or the reverse if explicitly requested.

---

## 7. Navigation and indexes

OrgTeX distinguishes navigation structures.

These are not treated as one generic "index".

Planned navigation features:

- table of contents
- list of figures
- list of tables
- list of graphs
- list of diagrams
- list of code
- list of algorithms
- alphabetical index
- glossary
- acronyms

---

## 8. Headers and footers

Headers and footers are global capabilities.

Each one is divided into:

- left slot
- center slot
- right slot

Each slot may contain:

- text
- metadata
- page number
- current chapter
- current section
- image
- logo
- icon
- combinations of elements

OrgTeX should support different page styles for:

- default pages
- first page
- odd pages
- even pages
- chapter opening pages

The Core provides the capability.

Page-layout features configure placement and activation.

Themes define appearance.

---

## 9. Page layout

OrgTeX should support:

- paper size
- custom paper size
- portrait orientation
- landscape orientation
- local orientation changes
- margins
- no margins
- asymmetric margins
- inner and outer margins
- bleed
- safe areas
- multiple columns
- local column changes
- page background color
- background images
- watermarks

The default layout may come from the family or variant.

The user may override it.

---

## 10. Families

Families describe the structural type of document.

Planned families:

- article-document
- report-document
- book
- correspondence
- business-document
- presentation
- poster
- visual-document

Families should define structural defaults, not visual style.

---

## 11. Variants

Variants describe the purpose of the document.

### article-document

Planned variants:

- simple-document
- homework
- practice
- short-report
- article
- essay
- notes
- study-guide
- formula-sheet
- worksheet

### report-document

Planned variants:

- general-report
- academic-report
- technical-report
- research-report
- project-report
- final-project
- thesis
- monograph
- manual
- technical-documentation

### book

Planned variants:

- general-book
- academic-book
- textbook
- class-notes
- reference-book
- manual
- monograph

### correspondence

Planned variants:

- formal-letter
- academic-letter
- business-letter
- personal-letter
- request-letter
- recommendation-letter
- cover-letter
- official-letter
- notice

### business-document

Planned variants:

- agreement
- contract
- proposal
- memorandum
- announcement
- statement
- policy
- meeting-minutes
- business-report
- internal-report
- external-report
- certificate

### presentation

Planned variants:

- class-presentation
- lecture
- project-presentation
- research-presentation
- thesis-defense
- conference-talk
- pitch
- interactive-presentation

### poster

Planned variants:

- academic-poster
- scientific-poster
- conference-poster
- informative-poster
- event-poster
- promotional-poster

### visual-document

Planned variants:

- infographic
- cheat-sheet
- information-sheet
- concept-map
- brochure
- handout

---

## 12. Themes

Themes define visual appearance.

Planned themes:

- academic
- formal
- minimal
- modern
- technical
- elegant
- colorful
- playful
- dark
- unam
- custom

Themes may configure:

- text color
- font
- font size
- text alignment defaults
- underline style
- list markers
- hyperlink style
- equation appearance
- image appearance
- margins defaults
- page numbering appearance
- header appearance
- footer appearance
- table of contents appearance
- cover appearance
- graph appearance
- diagram appearance
- table appearance
- code appearance
- highlighted boxes
- background color
- background images

Themes provide defaults.

Document configuration may override them.

---

## 13. Covers

Covers are separate from themes.

Planned covers:

- none
- simple
- standard
- academic
- institutional
- unam
- large-title
- image
- full-image
- minimal
- book-cover

A theme may style a cover without changing the cover type.

---

## 14. Features

Features are optional capabilities that may be enabled or disabled.

Planned feature groups:

### navigation

- table-of-contents
- list-of-figures
- list-of-tables
- list-of-graphs
- list-of-diagrams
- list-of-code
- list-of-algorithms
- alphabetical-index
- glossary
- acronyms

### page-layout

- margins
- page-size
- orientation
- background
- headers
- footers
- page-numbering
- columns
- bleed

### academic

- bibliography
- citations
- theorem-system
- appendices

### signatures

- signature-block
- multiple-signatures
- witness-block
- approval-block
- stamp-area

### notices

- confidentiality
- disclaimer
- legal-notice
- document-status

---

## 15. Cross-references

OrgTeX should support automatic references to:

- chapters
- sections
- equations
- figures
- tables
- graphs
- diagrams
- code
- algorithms
- theorems
- exercises
- appendices

References should remain valid when numbering changes.

---

## 16. Notes

OrgTeX should support:

- footnotes
- endnotes
- margin notes

---

## 17. Large documents

OrgTeX should support multi-file projects.

Example:

document.org

chapters/
- introduction.org
- theory.org
- methodology.org
- results.org
- conclusions.org

Large documents should support:

- front matter
- main matter
- back matter
- appendices

Typical front matter may include:

- cover
- dedication
- acknowledgements
- abstract
- table of contents
- lists

Typical back matter may include:

- appendices
- glossary
- bibliography
- alphabetical index

---

## 18. Business and professional documents

OrgTeX should support professional document features such as:

- company logos
- company metadata
- document identifiers
- reference numbers
- signatures
- approval blocks
- stamps
- confidentiality notices
- draft markers
- internal-use notices

OrgTeX formats these documents but does not provide legal validation of their
content.

---

## 19. Configuration precedence

Configuration should follow predictable precedence.

Proposed order:

core defaults
→ family defaults
→ variant defaults
→ theme defaults
→ document configuration
→ local overrides

Later layers override previous ones.

This rule should remain stable whenever possible.

---

## 20. Backends

OrgTeX should support multiple document backends.

Planned LaTeX wrappers:

- orgtex-article
- orgtex-report
- orgtex-book
- orgtex-letter
- orgtex-beamer
- orgtex-scrartcl
- orgtex-scrreprt
- orgtex-scrbook
- orgtex-memoir

The user should normally not need to interact directly with these classes.

---

## 21. Compilation modes

OrgTeX should eventually support:

### Native mode

Local Emacs
Local LaTeX

### Hybrid mode

Local Emacs
LaTeX inside Docker

### Container build mode

Any editor
Docker containing:
- Emacs
- Org Mode
- LaTeX
- OrgTeX

The recommended backend may be selected automatically.

---

## 22. CLI

The long-term CLI should be cross-platform.

Planned commands include:

- `orgtex new`
- `orgtex build`
- `orgtex validate`
- `orgtex doctor`
- `orgtex config`
- `orgtex themes`
- `orgtex variants`
- `orgtex version`
- `orgtex help`

The CLI should provide human-friendly errors.

Example:

Incorrect:
`orgtex buid document.org`

Expected behavior:

"Unknown command: buid"

"Did you mean: build?"

---

## 23. Validation

OrgTeX should validate documents before invoking LaTeX whenever possible.

Validation may include:

- valid family
- valid variant
- valid theme
- valid cover
- valid feature names
- required metadata
- image existence
- bibliography existence
- invalid paths
- conflicting options

The system should prefer clear OrgTeX errors over raw LaTeX errors.

Raw logs should remain available through debug or verbose modes.

---

## 24. Internationalization

Two languages must be treated independently:

### User interface language

Examples:

- Spanish
- English

### Document language

Examples:

- Spanish
- English
- other languages in the future

A Spanish OrgTeX interface must still be able to generate an English document.

---

## 25. Cross-platform support

OrgTeX aims to support:

- Linux
- Windows
- macOS

The codebase must avoid assumptions such as:

- fixed home paths
- `/home/user`
- Bash-only behavior
- Linux-only path separators
- system-wide LaTeX installation

Portable APIs should be preferred.

---

## 26. Extensibility

OrgTeX follows:

"Prefer extension over modification."

Adding a new theme should ideally require:

- creating the new theme module
- registering it

It should not require editing unrelated existing themes.

The same principle applies to:

- families
- variants
- covers
- features
- backends

The internal architecture should move toward module registries instead of large
conditional blocks.

---

## 27. Dependency direction

Dependencies should remain as simple and unidirectional as possible.

Conceptually:

core
→ families
→ variants
→ themes / features
→ document configuration
→ rendering
→ backend

Circular dependencies should be avoided.

---

## 28. Documentation

Documentation is considered part of the implementation.

Planned documentation:

- architecture
- installation
- configuration
- naming conventions
- families
- variants
- themes
- covers
- features
- backends
- CLI
- troubleshooting
- contributing

Important architectural decisions should be recorded as ADRs inside:

`docs/decisions/`

---

## 29. Testing

OrgTeX should eventually include:

- unit tests
- integration tests
- validation tests
- compilation tests
- example documents
- regression tests

Representative documents should be compiled automatically in CI.

Examples may include:

- homework
- report
- book
- presentation

---

## 30. Compatibility

OrgTeX should preserve backward compatibility whenever reasonable.

Breaking changes should be documented.

Semantic Versioning is planned:

MAJOR.MINOR.PATCH

Examples:

- 0.1.0
- 0.2.0
- 1.0.0

---

## 31. Raw LaTeX escape hatch

OrgTeX should simplify common use cases without trying to replace every LaTeX
feature.

Advanced users should be allowed to insert raw LaTeX when necessary.

The expected philosophy is:

Most use cases:
OrgTeX abstraction

Advanced or unusual use cases:
optional raw LaTeX

---

## 32. Initial development strategy

OrgTeX will be implemented incrementally.

Initial priorities:

1. Project foundation.
2. Git and documentation.
3. Basic Org to LaTeX to PDF pipeline.
4. Minimal Core.
5. First family.
6. First variant.
7. First theme.
8. First cover.
9. Validation.
10. CLI.
11. Docker backend.
12. Cross-platform distribution.

The architecture may evolve, but major decisions should be documented before
large changes are introduced.
