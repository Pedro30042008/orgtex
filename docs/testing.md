# Testing

OrgTeX currently includes automated tests for document configuration,
document family selection, document variant validation, document theme
selection, document cover selection, and the main document generation
pipeline.

The goal of the test suite is to verify that the core OrgTeX workflow works
from an Org Mode source file to a final PDF and that invalid configuration or
unsupported document combinations are rejected correctly.

## Available test scripts

OrgTeX currently provides six individual test scripts and one aggregate test
runner:

```text
scripts/test-config.sh
scripts/test-family.sh
scripts/test-variant.sh
scripts/test-theme.sh
scripts/test-cover.sh
scripts/test-pipeline.sh
scripts/test-all.sh
```

The individual scripts test specific parts of the system.

The aggregate runner executes all current test suites and prints a final
summary.

## Document configuration test

The configuration test verifies that:

- valid `ORGTEX_` document keywords can be read;
- supported values are accepted;
- invalid values are rejected;
- configuration errors return a non-zero process status;
- configuration errors contain useful diagnostic information.

The current valid configuration is read from:

```text
tests/fixtures/org/minimal-article.org
```

The intentionally invalid configuration is stored in:

```text
tests/fixtures/org/invalid-language.org
```

The invalid fixture currently uses:

```org
#+ORGTEX_LANGUAGE: klingon
```

This value is intentionally unsupported and should cause OrgTeX validation to
fail.

### Running the configuration test

Run:

```bash
./scripts/test-config.sh
```

A successful run ends with:

```text
OrgTeX configuration tests OK
```

A successful test means that valid configuration was accepted and invalid
configuration was correctly rejected.

## Document family test

The family test verifies that public OrgTeX document family names are mapped to
the correct internal LaTeX classes.

The current family mapping is:

```text
article-document -> orgtex-article
```

The test also verifies that an unsupported family is rejected.

The intentionally invalid test family is:

```text
spaceship-document
```

### Running the family test

Run:

```bash
./scripts/test-family.sh
```

A successful run ends with:

```text
OrgTeX family tests OK
```

A successful family test means that:

```text
article-document
        ↓
orgtex-article
```

was resolved correctly and that an unknown family was rejected.

## Document variant test

The variant test verifies that public OrgTeX variants are valid for the
selected document family.

The current supported combination is:

```text
article-document
        +
simple-document
        ↓
valid
```

The test also verifies that unsupported family and variant combinations are
rejected.

The current intentionally invalid combination is:

```text
book
  +
simple-document
  ↓
invalid
```

### Running the variant test

Run:

```bash
./scripts/test-variant.sh
```

A successful run ends with:

```text
OrgTeX variant tests OK
```

A successful variant test means that `simple-document` was accepted for
`article-document` and rejected for an unsupported family.

## Document theme test

The theme test verifies that public OrgTeX theme names are mapped to their
internal LaTeX implementation packages.

The current theme mapping is:

```text
minimal -> orgtex-theme-minimal
```

The current supported combination is:

```text
article-document
        +
minimal
        ↓
valid
```

The current intentionally invalid combination is:

```text
book
  +
minimal
  ↓
invalid
```

### Running the theme test

Run:

```bash
./scripts/test-theme.sh
```

A successful run ends with:

```text
OrgTeX theme tests OK
```

A successful theme test means that `minimal` was resolved to
`orgtex-theme-minimal`, accepted for `article-document`, and rejected for an
unsupported family.

## Document cover test

The cover test verifies that public OrgTeX cover names are mapped to their
internal LaTeX implementation packages.

The current cover mappings are:

```text
simple -> orgtex-cover-simple
none   -> no LaTeX package
```

The `none` cover is a valid logical cover selection, but it intentionally does
not load a LaTeX package.

The current supported combination is:

```text
article-document
        +
simple
        ↓
valid
```

The current intentionally invalid combination is:

```text
book
  +
simple
  ↓
invalid
```

### Running the cover test

Run:

```bash
./scripts/test-cover.sh
```

A successful run ends with:

```text
OrgTeX cover tests OK
```

A successful cover test means that:

```text
simple
```

was resolved to:

```text
orgtex-cover-simple
```

that:

```text
none
```

was resolved to:

```text
nil
```

and that unsupported family and cover combinations were rejected.

## End-to-end pipeline test

The pipeline test verifies that:

- Org Mode can export a document using OrgTeX;
- OrgTeX document configuration can be loaded during export;
- `ORGTEX_FAMILY` selects the correct internal LaTeX class;
- `ORGTEX_VARIANT` is validated against the selected family;
- `ORGTEX_THEME` selects and loads the correct LaTeX theme package;
- `ORGTEX_COVER` selects and loads the correct LaTeX cover package;
- the generated LaTeX document uses the expected OrgTeX class;
- the generated LaTeX document loads the expected OrgTeX theme;
- the generated LaTeX document loads the expected OrgTeX cover;
- the theme is loaded before the cover;
- the OrgTeX article backend loads the OrgTeX core package;
- LuaLaTeX can compile the generated document successfully;
- the final PDF is written to the build directory;
- the final LaTeX log does not contain persistent warnings.

The pipeline is:

```text
Org document
    ↓
Org Mode
    ↓
OrgTeX configuration
    ↓
OrgTeX family registry
    ↓
OrgTeX variant validation
    ↓
OrgTeX theme registry
    ↓
OrgTeX cover registry
    ↓
OrgTeX export integration
    ↓
orgtex-article.cls
    ↓
orgtex-base.sty
    ↓
orgtex-theme-minimal.sty
    ↓
orgtex-cover-simple.sty
    ↓
LuaLaTeX
    ↓
PDF
```

### Test file

The current pipeline test uses:

```text
tests/fixtures/org/minimal-article.org
```

The document currently declares:

```org
#+ORGTEX_FAMILY: article-document
#+ORGTEX_VARIANT: simple-document
#+ORGTEX_THEME: minimal
#+ORGTEX_COVER: simple
#+ORGTEX_LANGUAGE: es
```

The user-facing Org document does not need to declare:

```org
#+LATEX_CLASS: orgtex-article
```

OrgTeX resolves the LaTeX class internally.

The generated LaTeX file is:

```text
tests/fixtures/org/minimal-article.tex
```

The generated `.tex` file is ignored by Git because it is a build artifact.

The pipeline verifies that the generated LaTeX source contains:

```latex
\documentclass{orgtex-article}
```

followed by:

```latex
\usepackage{orgtex-theme-minimal}
\usepackage{orgtex-cover-simple}
```

The final PDF and auxiliary files are written to:

```text
build/tests/org/
```

The entire `build/` directory is ignored by Git.

### Running the pipeline test

Run:

```bash
./scripts/test-pipeline.sh
```

The script:

- checks that Emacs, `latexmk`, LuaLaTeX, and `grep` are available;
- removes previous test output;
- exports the Org fixture to LaTeX;
- verifies the generated LaTeX class;
- verifies the generated LaTeX theme package;
- verifies the generated LaTeX cover package;
- compiles the generated LaTeX document;
- verifies that the expected PDF was generated;
- checks the final LaTeX log for persistent warnings.

A successful run ends with:

```text
OrgTeX pipeline OK
```

The generated PDF is written to:

```text
build/tests/org/minimal-article.pdf
```

## Running all current tests

Run the complete OrgTeX test suite with:

```bash
./scripts/test-all.sh
```

The runner executes:

```text
test-config.sh
test-family.sh
test-variant.sh
test-theme.sh
test-cover.sh
test-pipeline.sh
```

It continues running even if one test fails and prints a final summary.

A successful run ends with:

```text
========================================
OrgTeX test summary
========================================
Passed: 6
Failed: 0
Total:  6

OrgTeX test suite OK
```

Individual tests can still be executed separately when working on a specific
part of the system.

For example:

```bash
./scripts/test-cover.sh
```

or:

```bash
./scripts/test-theme.sh
```

All tests should pass before merging changes that affect configuration, family
selection, variant validation, theme selection, cover selection, or the export
pipeline.

## Manual pipeline

The automated pipeline script performs the same steps that can be executed
manually while debugging.

### 1. Clean previous output

```bash
rm -rf build/tests/org
mkdir -p build/tests/org
rm -f tests/fixtures/org/minimal-article.tex
```

### 2. Export Org to LaTeX

```bash
emacs -Q --batch \
  -L emacs \
  -l emacs/orgtex-export.el \
  --eval '(orgtex-export-file "tests/fixtures/org/minimal-article.org")'
```

### 3. Verify the selected LaTeX class

```bash
grep -n "documentclass" tests/fixtures/org/minimal-article.tex
```

The generated document should contain:

```latex
\documentclass{orgtex-article}
```

### 4. Verify theme and cover selection

```bash
grep -n "orgtex-theme-minimal\|orgtex-cover-simple" \
  tests/fixtures/org/minimal-article.tex
```

The generated document should contain:

```latex
\usepackage{orgtex-theme-minimal}
\usepackage{orgtex-cover-simple}
```

in that order.

### 5. Compile LaTeX to PDF

```bash
TEXINPUTS="$PWD/latex/core//:$PWD/latex/backends//:$PWD/latex/themes//:$PWD/latex/covers//:" \
latexmk \
  -lualatex \
  -interaction=nonstopmode \
  -outdir=build/tests/org \
  tests/fixtures/org/minimal-article.tex
```

### 6. Verify the PDF

```bash
test -f build/tests/org/minimal-article.pdf && echo "OrgTeX pipeline OK"
```

### 7. Check the final log

```bash
grep -En '^[[:space:]]*(LaTeX Warning:|Package .* Warning:|warning[[:space:]]+\()' \
  build/tests/org/minimal-article.log
```

If this command produces no output after the final compilation, the current
test is clean.

## Expected warnings

LaTeX may report warnings during the first compilation pass when labels,
references, or PDF metadata change.

`latexmk` handles the required additional passes automatically.

What matters is that the final compilation log does not contain persistent
warnings.

## Current limitations

The configuration tests currently validate supported values, but they do not
yet detect unknown or misspelled `ORGTEX_` keyword names.

For example:

```org
#+ORGTEX_LENGUAGE: es
```

is not yet rejected automatically.

Language handling is also currently minimal. A dedicated language registry may
be introduced later as multilingual support grows.

Only the `article-document` family is currently registered.

Only the `simple-document` variant is currently registered, and it currently
supports only `article-document`.

Only the `minimal` theme is currently registered, and it currently supports
only `article-document`.

Only the `simple` and `none` covers are currently registered, and they currently
support only `article-document`.

The `simple` cover currently uses the document title, author, and date as its
content.

Additional document families, variants, themes, and covers will be added
incrementally as their implementations and behavior are developed and tested.

## Future testing

As OrgTeX grows, the test infrastructure should expand to cover:

- unknown configuration keyword names;
- duplicate configuration keys;
- missing required configuration;
- additional document families;
- additional document variants;
- additional document themes;
- additional document covers;
- invalid family and variant combinations;
- invalid family and theme combinations;
- invalid family and cover combinations;
- invalid family/backend mappings;
- configuration precedence;
- cover metadata and assets;
- cross-references;
- tables and figures;
- mathematics;
- multilingual documents;
- native and containerized compilation;
- automated continuous integration;
- continuous integration using the aggregate test runner.
