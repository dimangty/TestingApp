#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="${1:-.}"

bash "${ROOT_DIR%/}/skills/ios-selected-presenter-swifttesting-writer/scripts/create_login_presenter_swifttesting_tests.sh" "$ROOT_DIR"
