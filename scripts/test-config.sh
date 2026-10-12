#!/usr/bin/env bash

# SPDX-License-Identifier: MPL-2.0

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

VALID_ORG="$PROJECT_ROOT/tests/fixtures/org/minimal-article.org"
INVALID_ORG="$PROJECT_ROOT/tests/fixtures/org/invalid-language.org"

fail() {
    echo "OrgTeX config test failed: $1" >&2
    exit 1
}

require_command() {
    command -v "$1" >/dev/null 2>&1 \
        || fail "required command '$1' was not found."
}

echo "Checking configuration test dependencies..."

require_command emacs

echo "Testing valid OrgTeX configuration..."

VALID_OUTPUT="$(
    emacs -Q --batch \
        -L "$PROJECT_ROOT/emacs" \
        -l "$PROJECT_ROOT/emacs/orgtex-config.el" \
        --eval "(with-current-buffer
                    (find-file-noselect \"$VALID_ORG\")
                  (prin1 (orgtex-config-read)))"
)"

echo "$VALID_OUTPUT"

[[ "$VALID_OUTPUT" == *'("FAMILY" . "article-document")'* ]] \
    || fail "valid FAMILY configuration was not read correctly."

[[ "$VALID_OUTPUT" == *'("VARIANT" . "simple-document")'* ]] \
    || fail "valid VARIANT configuration was not read correctly."

[[ "$VALID_OUTPUT" == *'("THEME" . "minimal")'* ]] \
    || fail "valid THEME configuration was not read correctly."

[[ "$VALID_OUTPUT" == *'("LANGUAGE" . "es")'* ]] \
    || fail "valid LANGUAGE configuration was not read correctly."

echo "Testing invalid OrgTeX configuration..."

set +e

INVALID_OUTPUT="$(
    emacs -Q --batch \
        -L "$PROJECT_ROOT/emacs" \
        -l "$PROJECT_ROOT/emacs/orgtex-config.el" \
        --eval "(with-current-buffer
                    (find-file-noselect \"$INVALID_ORG\")
                  (orgtex-config-read))" \
        2>&1
)"

INVALID_STATUS=$?

set -e

[[ "$INVALID_STATUS" -ne 0 ]] \
    || fail "invalid configuration was accepted unexpectedly."

[[ "$INVALID_OUTPUT" == *"invalid value"* ]] \
    || fail "invalid configuration did not report the expected error."

[[ "$INVALID_OUTPUT" == *"klingon"* ]] \
    || fail "invalid configuration error did not include the invalid value."

echo
echo "OrgTeX configuration tests OK"
