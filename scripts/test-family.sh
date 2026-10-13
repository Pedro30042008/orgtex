#!/usr/bin/env bash

# SPDX-License-Identifier: MPL-2.0

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

fail() {
    echo "OrgTeX family test failed: $1" >&2
    exit 1
}

require_command() {
    command -v "$1" >/dev/null 2>&1 \
        || fail "required command '$1' was not found."
}

echo "Checking family test dependencies..."

require_command emacs

echo "Testing valid OrgTeX family..."

VALID_OUTPUT="$(
    emacs -Q --batch \
        -L "$PROJECT_ROOT/emacs" \
        -l "$PROJECT_ROOT/emacs/orgtex-family.el" \
        --eval '(prin1 (orgtex-family-get-latex-class "article-document"))'
)"

echo "$VALID_OUTPUT"

[[ "$VALID_OUTPUT" == '"orgtex-article"' ]] \
    || fail "article-document did not resolve to orgtex-article."

echo "Testing invalid OrgTeX family..."

set +e

INVALID_OUTPUT="$(
    emacs -Q --batch \
        -L "$PROJECT_ROOT/emacs" \
        -l "$PROJECT_ROOT/emacs/orgtex-family.el" \
        --eval '(orgtex-family-get-latex-class "spaceship-document")' \
        2>&1
)"

INVALID_STATUS=$?

set -e

[[ "$INVALID_STATUS" -ne 0 ]] \
    || fail "invalid family was accepted unexpectedly."

[[ "$INVALID_OUTPUT" == *"unsupported document family"* ]] \
    || fail "invalid family did not report the expected error."

[[ "$INVALID_OUTPUT" == *"spaceship-document"* ]] \
    || fail "invalid family error did not include the invalid family."

echo
echo "OrgTeX family tests OK"
