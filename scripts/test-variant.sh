#!/usr/bin/env bash

# SPDX-License-Identifier: MPL-2.0

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

fail() {
    echo "OrgTeX variant test failed: $1" >&2
    exit 1
}

require_command() {
    command -v "$1" >/dev/null 2>&1 \
        || fail "required command '$1' was not found."
}

echo "Checking variant test dependencies..."

require_command emacs

echo "Testing valid OrgTeX variant..."

VALID_OUTPUT="$(
    emacs -Q --batch \
        -L "$PROJECT_ROOT/emacs" \
        -l "$PROJECT_ROOT/emacs/orgtex-variant.el" \
        --eval '(prin1 (orgtex-variant-validate-for-family "simple-document" "article-document"))'
)"

echo "$VALID_OUTPUT"

[[ "$VALID_OUTPUT" == '"simple-document"' ]] \
    || fail "simple-document was not accepted for article-document."

echo "Testing invalid OrgTeX variant..."

set +e

INVALID_OUTPUT="$(
    emacs -Q --batch \
        -L "$PROJECT_ROOT/emacs" \
        -l "$PROJECT_ROOT/emacs/orgtex-variant.el" \
        --eval '(orgtex-variant-validate-for-family "simple-document" "book")' \
        2>&1
)"

INVALID_STATUS=$?

set -e

[[ "$INVALID_STATUS" -ne 0 ]] \
    || fail "unsupported family and variant combination was accepted."

[[ "$INVALID_OUTPUT" == *"not supported for family"* ]] \
    || fail "invalid variant combination did not report the expected error."

[[ "$INVALID_OUTPUT" == *"simple-document"* ]] \
    || fail "invalid variant error did not include the variant name."

[[ "$INVALID_OUTPUT" == *"book"* ]] \
    || fail "invalid variant error did not include the family name."

echo
echo "OrgTeX variant tests OK"
