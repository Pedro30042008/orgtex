#!/usr/bin/env bash

# SPDX-License-Identifier: MPL-2.0

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

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

echo
echo "OrgTeX cover tests OK"
