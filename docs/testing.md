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
