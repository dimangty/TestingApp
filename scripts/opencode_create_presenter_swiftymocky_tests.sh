#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="${1:-.}"
PRESENTER_NAME="${2:-}"
FRAMEWORK_RAW="${3:-xctest}"
OUT_FILE="${4:-}"

if [[ -z "$PRESENTER_NAME" ]]; then
  echo "Usage: bash scripts/opencode_create_presenter_swiftymocky_tests.sh <root_dir> <PresenterName> [xctest|swifttesting] [output_file]"
  exit 1
fi

ROOT_DIR="${ROOT_DIR%/}"
FRAMEWORK="$(echo "$FRAMEWORK_RAW" | tr '[:upper:]' '[:lower:]')"

case "$FRAMEWORK" in
  xctest|unit|unittest)
    bash "$ROOT_DIR/scripts/opencode_create_presenter_tests.sh" "$ROOT_DIR" "$PRESENTER_NAME" "$OUT_FILE"
    ;;
  swifttesting|swift-testing|testing)
    bash "$ROOT_DIR/scripts/opencode_create_presenter_swifttesting_tests.sh" "$ROOT_DIR" "$PRESENTER_NAME" "$OUT_FILE"
    ;;
  *)
    echo "ERROR: Unknown framework '$FRAMEWORK_RAW'. Use xctest or swifttesting."
    exit 1
    ;;
esac
