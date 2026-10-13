#!/usr/bin/env bash

# SPDX-License-Identifier: MPL-2.0

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

TESTS=(
    "test-config.sh"
    "test-family.sh"
    "test-variant.sh"
    "test-theme.sh"
    "test-cover.sh"
    "test-language.sh"
    "test-pipeline.sh"
)

PASSED=0
FAILED=0
FAILED_TESTS=()

echo "========================================"
echo "OrgTeX test suite"
echo "========================================"
echo

for test_script in "${TESTS[@]}"; do
    echo "----------------------------------------"
    echo "Running: $test_script"
    echo "----------------------------------------"

    if "$SCRIPT_DIR/$test_script"; then
        ((PASSED += 1))
        echo
        echo "PASS: $test_script"
    else
        ((FAILED += 1))
        FAILED_TESTS+=("$test_script")
        echo
        echo "FAIL: $test_script"
    fi

    echo
done

echo "========================================"
echo "OrgTeX test summary"
echo "========================================"
echo "Passed: $PASSED"
echo "Failed: $FAILED"
echo "Total:  ${#TESTS[@]}"

if (( FAILED > 0 )); then
    echo
    echo "Failed test suites:"

    for test_script in "${FAILED_TESTS[@]}"; do
        echo "  - $test_script"
    done

    echo
    echo "OrgTeX test suite FAILED"
    exit 1
fi

echo
echo "OrgTeX test suite OK"
