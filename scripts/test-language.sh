#!/usr/bin/env bash

# SPDX-License-Identifier: MPL-2.0

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

INVALID_ORG="$PROJECT_ROOT/tests/fixtures/org/invalid-language.org"

fail() {
    echo "OrgTeX language test failed: $1" >&2
    exit 1
}

require_command() {
    command -v "$1" >/dev/null 2>&1 \
        || fail "required command '$1' was not found."
}

echo "Checking language test dependencies..."

require_command emacs

echo "Testing Spanish OrgTeX language..."

SPANISH_OUTPUT="$(
    emacs -Q --batch \
        -L "$PROJECT_ROOT/emacs" \
        -l "$PROJECT_ROOT/emacs/orgtex-language.el" \
        --eval '(prin1 (orgtex-language-get-org-language "es"))'
)"

echo "$SPANISH_OUTPUT"

[[ "$SPANISH_OUTPUT" == '"es"' ]] \
    || fail "es did not resolve to the expected Org Mode language."

echo "Testing English OrgTeX language..."

ENGLISH_OUTPUT="$(
    emacs -Q --batch \
        -L "$PROJECT_ROOT/emacs" \
        -l "$PROJECT_ROOT/emacs/orgtex-language.el" \
        --eval '(prin1 (orgtex-language-get-org-language "en"))'
)"

echo "$ENGLISH_OUTPUT"

[[ "$ENGLISH_OUTPUT" == '"en"' ]] \
    || fail "en did not resolve to the expected Org Mode language."

echo "Testing invalid OrgTeX language registry value..."

set +e

INVALID_REGISTRY_OUTPUT="$(
    emacs -Q --batch \
        -L "$PROJECT_ROOT/emacs" \
        -l "$PROJECT_ROOT/emacs/orgtex-language.el" \
        --eval '(orgtex-language-get-org-language "klingon")' \
        2>&1
)"

INVALID_REGISTRY_STATUS=$?

set -e

[[ "$INVALID_REGISTRY_STATUS" -ne 0 ]] \
    || fail "unsupported language was accepted unexpectedly."

[[ "$INVALID_REGISTRY_OUTPUT" == *"unsupported document language"* ]] \
    || fail "invalid language did not report the expected error."

[[ "$INVALID_REGISTRY_OUTPUT" == *"klingon"* ]] \
    || fail "invalid language error did not include the invalid value."

echo "Testing invalid language through OrgTeX export..."

set +e

INVALID_EXPORT_OUTPUT="$(
    emacs -Q --batch \
        -L "$PROJECT_ROOT/emacs" \
        -l "$PROJECT_ROOT/emacs/orgtex-export.el" \
        --eval "(orgtex-export-file \"$INVALID_ORG\")" \
        2>&1
)"

INVALID_EXPORT_STATUS=$?

set -e

[[ "$INVALID_EXPORT_STATUS" -ne 0 ]] \
    || fail "invalid document language was accepted during export."

[[ "$INVALID_EXPORT_OUTPUT" == *"unsupported document language"* ]] \
    || fail "export did not report the expected language error."

[[ "$INVALID_EXPORT_OUTPUT" == *"klingon"* ]] \
    || fail "export language error did not include the invalid value."

echo
echo "OrgTeX language tests OK"
