# Testing

OrgTeX currently includes automated tests for document configuration,
document family selection, document variant validation, document theme
selection, and the main document generation pipeline.

The goal of the test suite is to verify that the core OrgTeX workflow works
from an Org Mode source file to a final PDF and that invalid configuration or
unsupported document combinations are rejected correctly.

## Available test scripts

OrgTeX currently provides five test scripts:

```text
scripts/test-config.sh
scripts/test-family.sh
scripts/test-variant.sh
scripts/test-theme.sh
scripts/test-pipeline.sh
```

Each script tests a different part of the system.

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

A successful variant test means that:

```text
simple-document
```

was accepted for:

```text
article-document
```

and rejected for an unsupported family.

## Document theme test

The theme test verifies that public OrgTeX theme names are mapped to their
internal LaTeX implementation packages.

The current theme mapping is:

```text
minimal -> orgtex-theme-minimal
```

The test also verifies that the theme is valid for the selected document
family.

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

A successful theme test means that:

```text
minimal
```

was resolved to:

```text
orgtex-theme-minimal
```

and was accepted for `article-document` while being rejected for an
unsupported family.

## End-to-end pipeline test

The pipeline test verifies that:

- Org Mode can export a document using OrgTeX;
- OrgTeX document configuration can be loaded during export;
- `ORGTEX_FAMILY` selects the correct internal LaTeX class;
- `ORGTEX_VARIANT` is validated against the selected family;
- `ORGTEX_THEME` selects and loads the correct LaTeX theme package;
- the generated LaTeX document uses the expected OrgTeX class;
- the generated LaTeX document loads the expected OrgTeX theme;
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
OrgTeX export integration
    ↓
orgtex-article.cls
    ↓
orgtex-base.sty
    ↓
orgtex-theme-minimal.sty
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

and:

```latex
\usepackage{orgtex-theme-minimal}
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

The script can also be executed from outside the repository because it
automatically resolves the project root.

## Running all current tests

Run all current automated tests with:

```bash
./scripts/test-config.sh
./scripts/test-family.sh
./scripts/test-variant.sh
./scripts/test-theme.sh
./scripts/test-pipeline.sh
```

All five commands should complete successfully before merging changes that
affect configuration, family selection, variant validation, theme selection, or
the export pipeline.

## Manual pipeline

The automated pipeline script performs the same steps that were previously
executed manually.

The manual process is useful for debugging individual stages of the pipeline.

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

### 4. Verify the selected theme

```bash
grep -n "orgtex-theme-minimal" tests/fixtures/org/minimal-article.tex
```

The generated document should contain:

```latex
\usepackage{orgtex-theme-minimal}
```

### 5. Compile LaTeX to PDF

```bash
TEXINPUTS="$PWD/latex/core//:$PWD/latex/backends//:$PWD/latex/themes//:" \
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
grep -n "Warning" build/tests/org/minimal-article.log
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

Additional document families, variants, and themes will be added incrementally
as their implementations and behavior are developed and tested.

## Future testing

As OrgTeX grows, the test infrastructure should expand to cover:

- unknown configuration keyword names;
- duplicate configuration keys;
- missing required configuration;
- additional document families;
- additional document variants;
- additional document themes;
- invalid family and variant combinations;
- invalid family and theme combinations;
- invalid family/backend mappings;
- covers;
- configuration precedence;
- invalid configuration handling;
- cross-references;
- tables and figures;
- mathematics;
- multilingual documents;
- native and containerized compilation;
- automated continuous integration.
