#!/usr/bin/env bash

# SPDX-License-Identifier: MPL-2.0

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

SIMPLE_COVER_PACKAGE="$PROJECT_ROOT/latex/covers/orgtex-cover-simple.sty"

fail() {
    echo "OrgTeX cover test failed: $1" >&2
    exit 1
}

require_command() {
    command -v "$1" >/dev/null 2>&1 \
        || fail "required command '$1' was not found."
}

echo "Checking cover test dependencies..."

require_command emacs
require_command grep

echo "Testing valid OrgTeX cover..."

VALID_OUTPUT="$(
    emacs -Q --batch \
        -L "$PROJECT_ROOT/emacs" \
        -l "$PROJECT_ROOT/emacs/orgtex-cover.el" \
        --eval '(prin1 (orgtex-cover-get-package "simple"))'
)"

echo "$VALID_OUTPUT"

[[ "$VALID_OUTPUT" == '"orgtex-cover-simple"' ]] \
    || fail "simple did not resolve to orgtex-cover-simple."

echo "Testing cover without LaTeX package..."

NONE_OUTPUT="$(
    emacs -Q --batch \
        -L "$PROJECT_ROOT/emacs" \
        -l "$PROJECT_ROOT/emacs/orgtex-cover.el" \
        --eval '(prin1 (orgtex-cover-get-package "none"))'
)"

echo "$NONE_OUTPUT"

[[ "$NONE_OUTPUT" == "nil" ]] \
    || fail "none did not resolve to nil."

echo "Testing valid cover and family combination..."

COMBINATION_OUTPUT="$(
    emacs -Q --batch \
        -L "$PROJECT_ROOT/emacs" \
        -l "$PROJECT_ROOT/emacs/orgtex-cover.el" \
        --eval '(prin1 (orgtex-cover-validate-for-family "simple" "article-document"))'
)"

echo "$COMBINATION_OUTPUT"

[[ "$COMBINATION_OUTPUT" == '"simple"' ]] \
    || fail "simple was not accepted for article-document."

echo "Testing invalid cover and family combination..."

set +e

INVALID_OUTPUT="$(
    emacs -Q --batch \
        -L "$PROJECT_ROOT/emacs" \
        -l "$PROJECT_ROOT/emacs/orgtex-cover.el" \
        --eval '(orgtex-cover-validate-for-family "simple" "book")' \
        2>&1
)"

INVALID_STATUS=$?

set -e

[[ "$INVALID_STATUS" -ne 0 ]] \
    || fail "unsupported cover and family combination was accepted."

[[ "$INVALID_OUTPUT" == *"not supported for family"* ]] \
    || fail "invalid cover combination did not report the expected error."

[[ "$INVALID_OUTPUT" == *"simple"* ]] \
    || fail "invalid cover error did not include the cover name."

[[ "$INVALID_OUTPUT" == *"book"* ]] \
    || fail "invalid cover error did not include the family name."

echo "Testing simple cover title behavior..."

[[ -f "$SIMPLE_COVER_PACKAGE" ]] \
    || fail "simple cover LaTeX package was not found."

grep -Fq '\renewcommand{\maketitle}{\orgtexsimplecover}' \
    "$SIMPLE_COVER_PACKAGE" \
    || fail "simple cover does not replace the standard LaTeX title."

if grep -Fq '\AtBeginDocument' "$SIMPLE_COVER_PACKAGE"; then
    fail "simple cover must not create an additional title page with AtBeginDocument."
fi

echo
echo "OrgTeX cover tests OK"
