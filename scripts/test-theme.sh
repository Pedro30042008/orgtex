#!/usr/bin/env bash

# SPDX-License-Identifier: MPL-2.0

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

fail() {
    echo "OrgTeX theme test failed: $1" >&2
    exit 1
}

require_command() {
    command -v "$1" >/dev/null 2>&1 \
        || fail "required command '$1' was not found."
}

echo "Checking theme test dependencies..."

require_command emacs

echo "Testing valid OrgTeX theme..."

VALID_OUTPUT="$(
    emacs -Q --batch \
        -L "$PROJECT_ROOT/emacs" \
        -l "$PROJECT_ROOT/emacs/orgtex-theme.el" \
        --eval '(prin1 (orgtex-theme-get-package "minimal"))'
)"

echo "$VALID_OUTPUT"

[[ "$VALID_OUTPUT" == '"orgtex-theme-minimal"' ]] \
    || fail "minimal did not resolve to orgtex-theme-minimal."

echo "Testing valid theme and family combination..."

COMBINATION_OUTPUT="$(
    emacs -Q --batch \
        -L "$PROJECT_ROOT/emacs" \
        -l "$PROJECT_ROOT/emacs/orgtex-theme.el" \
        --eval '(prin1 (orgtex-theme-validate-for-family "minimal" "article-document"))'
)"

echo "$COMBINATION_OUTPUT"

[[ "$COMBINATION_OUTPUT" == '"minimal"' ]] \
    || fail "minimal was not accepted for article-document."

echo "Testing invalid theme and family combination..."

set +e

INVALID_OUTPUT="$(
    emacs -Q --batch \
        -L "$PROJECT_ROOT/emacs" \
        -l "$PROJECT_ROOT/emacs/orgtex-theme.el" \
        --eval '(orgtex-theme-validate-for-family "minimal" "book")' \
        2>&1
)"

INVALID_STATUS=$?

set -e

[[ "$INVALID_STATUS" -ne 0 ]] \
    || fail "unsupported theme and family combination was accepted."

[[ "$INVALID_OUTPUT" == *"not supported for family"* ]] \
    || fail "invalid theme combination did not report the expected error."

[[ "$INVALID_OUTPUT" == *"minimal"* ]] \
    || fail "invalid theme error did not include the theme name."

[[ "$INVALID_OUTPUT" == *"book"* ]] \
    || fail "invalid theme error did not include the family name."

echo
echo "OrgTeX theme tests OK"
