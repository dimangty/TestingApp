#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="${1:-.}"

bash "${ROOT_DIR%/}/skills/ios-presenter-unit-test-writer/scripts/create_login_presenter_tests.sh" "$ROOT_DIR"
