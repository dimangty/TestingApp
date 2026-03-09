#!/usr/bin/env bash
set -euo pipefail

# Compatibility alias for qwen3/opencode-cli path rewriting:
# opencode_create_presenter_swiftymocky_tests.sh -> opencode_create_presenter_swifty_mocky_tests.sh
bash "$(dirname "$0")/opencode_create_presenter_swiftymocky_tests.sh" "$@"
