# Testing

OrgTeX currently includes a minimal end-to-end pipeline test.

The goal of this test is to verify that the main document generation path works from an Org Mode source file to a final PDF.

## Minimal Org pipeline

This test verifies that:

- Org Mode can export a document using the `orgtex-article` class.
- The generated LaTeX document loads the OrgTeX article backend.
- The OrgTeX article backend loads the OrgTeX core package.
- LuaLaTeX can compile the generated document successfully.
- The final PDF is written to the build directory.

The pipeline is:

```text
Org document
    ↓
Org Mode
    ↓
OrgTeX export integration
    ↓
orgtex-article.cls
    ↓
orgtex-base.sty
    ↓
LuaLaTeX
    ↓
PDF
```

## Test files

The current test uses:

```text
tests/fixtures/org/minimal-article.org
```

The generated LaTeX file is:

```text
tests/fixtures/org/minimal-article.tex
```

The generated `.tex` file is ignored by Git because it is a build artifact.

The final PDF and auxiliary files are written to:

```text
build/tests/org/
```

The entire `build/` directory is ignored by Git.

## Running the test

The recommended way to run the current end-to-end test is:

```bash
./scripts/test-pipeline.sh
```

The script:

- checks that Emacs, `latexmk`, and LuaLaTeX are available;
- removes previous test output;
- exports the Org fixture to LaTeX;
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

The script can also be executed from outside the repository because it automatically resolves the project root.

## Manual pipeline

The automated script performs the same steps that were previously executed manually.

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
  -l emacs/orgtex-export.el \
  --eval '(orgtex-export-file "tests/fixtures/org/minimal-article.org")'
```

### 3. Compile LaTeX to PDF

```bash
TEXINPUTS="$PWD/latex/core//:$PWD/latex/backends//:" \
latexmk \
  -lualatex \
  -interaction=nonstopmode \
  -outdir=build/tests/org \
  tests/fixtures/org/minimal-article.tex
```

### 4. Verify the PDF

```bash
test -f build/tests/org/minimal-article.pdf && echo "OrgTeX pipeline OK"
```

### 5. Check the final log

```bash
grep -n "Warning" build/tests/org/minimal-article.log
```

If this command produces no output after the final compilation, the current test is clean.

## Expected warnings

LaTeX may report warnings during the first compilation pass when labels, references, or PDF metadata change.

`latexmk` handles the required additional passes automatically.

What matters is that the final compilation log does not contain persistent warnings.

## Future testing

The current test runner is intentionally minimal.

As OrgTeX grows, the test infrastructure should expand to cover:

- additional document families;
- themes and covers;
- document variants;
- configuration precedence;
- invalid configuration handling;
- cross-references;
- tables and figures;
- mathematics;
- multilingual documents;
- native and containerized compilation;
- automated continuous integration.
