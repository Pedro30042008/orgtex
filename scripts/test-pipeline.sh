#!/usr/bin/env bash

# SPDX-License-Identifier: MPL-2.0

set -euo pipefail

# ----------------------------------------------------------
# Paths
# ----------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

ORG_SOURCE="$PROJECT_ROOT/tests/fixtures/org/minimal-article.org"
TEX_SOURCE="$PROJECT_ROOT/tests/fixtures/org/minimal-article.tex"
BUILD_DIR="$PROJECT_ROOT/build/tests/org"
PDF_OUTPUT="$BUILD_DIR/minimal-article.pdf"
LOG_OUTPUT="$BUILD_DIR/minimal-article.log"

# ----------------------------------------------------------
# Helpers
# ----------------------------------------------------------

fail() {
    echo "OrgTeX test failed: $1" >&2
    exit 1
}

require_command() {
    command -v "$1" >/dev/null 2>&1 \
        || fail "required command '$1' was not found."
}

# ----------------------------------------------------------
# Dependency checks
# ----------------------------------------------------------

echo "Checking test dependencies..."

require_command emacs
require_command latexmk
require_command lualatex
require_command grep

# ----------------------------------------------------------
# Clean previous output
# ----------------------------------------------------------

echo "Cleaning previous test output..."

rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"
rm -f "$TEX_SOURCE"

# ----------------------------------------------------------
# Org -> LaTeX
# ----------------------------------------------------------

echo "Exporting Org document to LaTeX..."

emacs -Q --batch \
    -L "$PROJECT_ROOT/emacs" \
    -l "$PROJECT_ROOT/emacs/orgtex-export.el" \
    --eval "(orgtex-export-file \"$ORG_SOURCE\")"

[[ -f "$TEX_SOURCE" ]] \
    || fail "Org Mode did not generate the expected LaTeX file."

# ----------------------------------------------------------
# Generated LaTeX verification
# ----------------------------------------------------------

echo "Verifying generated LaTeX configuration..."

grep -Fq '\documentclass{orgtex-article}' "$TEX_SOURCE" \
    || fail "generated LaTeX does not use the expected orgtex-article class."

grep -Fq '\usepackage{orgtex-theme-minimal}' "$TEX_SOURCE" \
    || fail "generated LaTeX does not load the expected minimal theme."

grep -Fq '\usepackage{orgtex-cover-simple}' "$TEX_SOURCE" \
    || fail "generated LaTeX does not load the expected simple cover."

THEME_MATCH="$(
    grep -nFm1 '\usepackage{orgtex-theme-minimal}' "$TEX_SOURCE"
)"

COVER_MATCH="$(
    grep -nFm1 '\usepackage{orgtex-cover-simple}' "$TEX_SOURCE"
)"

THEME_LINE="${THEME_MATCH%%:*}"
COVER_LINE="${COVER_MATCH%%:*}"

[[ "$THEME_LINE" -lt "$COVER_LINE" ]] \
    || fail "generated LaTeX does not load the theme before the cover."

MAKETITLE_COUNT="$(
    grep -Fc '\maketitle' "$TEX_SOURCE" || true
)"

[[ "$MAKETITLE_COUNT" -eq 1 ]] \
    || fail "generated LaTeX must contain exactly one \\maketitle command."

# ----------------------------------------------------------
# LaTeX -> PDF
# ----------------------------------------------------------

echo "Compiling LaTeX document with LuaLaTeX..."

TEXINPUTS="$PROJECT_ROOT/latex/core//:$PROJECT_ROOT/latex/backends//:$PROJECT_ROOT/latex/themes//:$PROJECT_ROOT/latex/covers//:" \
latexmk \
    -lualatex \
    -interaction=nonstopmode \
    -outdir="$BUILD_DIR" \
    "$TEX_SOURCE"

# ----------------------------------------------------------
# Final verification
# ----------------------------------------------------------

[[ -f "$PDF_OUTPUT" ]] \
    || fail "the expected PDF was not generated."

if grep -En '^[[:space:]]*(LaTeX Warning:|Package .* Warning:|warning[[:space:]]+\()' "$LOG_OUTPUT"; then
    fail "persistent LaTeX warnings were found in the final log."
fi

echo
echo "OrgTeX pipeline OK"
echo "PDF: $PDF_OUTPUT"
