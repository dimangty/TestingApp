#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="${1:-.}"

if [[ ! -d "$ROOT_DIR" ]]; then
  echo "Root directory not found: $ROOT_DIR" >&2
  exit 1
fi

cd "$ROOT_DIR"

if [[ ! -f "Mockfile" ]]; then
  echo "Mockfile not found in $PWD" >&2
  exit 1
fi

SCREEN_MOCKABLES="TestingTaskTests/ScreenMockables.swift"
if [[ ! -f "$SCREEN_MOCKABLES" ]]; then
  mkdir -p "$(dirname "$SCREEN_MOCKABLES")"
  cat >"$SCREEN_MOCKABLES" <<'EOF'
import Foundation
import UIKit
@testable import TestingTask

// Add wrappers for protocols used in tests.
// Example:
// //sourcery: AutoMockable
// protocol LoginScreenViewInputMockable: LoginScreenViewInput {}
EOF
  echo "Created $SCREEN_MOCKABLES. Add required wrappers, then run this script again."
  exit 2
fi

if [[ -x "/tmp/SwiftyMocky/bin/swiftymocky" ]]; then
  SWIFTYMOCKY_BIN="/tmp/SwiftyMocky/bin/swiftymocky"
elif command -v swiftymocky >/dev/null 2>&1; then
  SWIFTYMOCKY_BIN="$(command -v swiftymocky)"
else
  echo "SwiftyMocky binary not found. Expected /tmp/SwiftyMocky/bin/swiftymocky or swiftymocky in PATH." >&2
  exit 1
fi

echo "Using SwiftyMocky: $SWIFTYMOCKY_BIN"
"$SWIFTYMOCKY_BIN" generate

if [[ ! -f "TestingTaskTests/Support/Generated/Mock.generated.swift" ]]; then
  echo "Generation finished but Mock.generated.swift was not found." >&2
  exit 1
fi

echo "SwiftyMocky generation completed."
echo "Review these files:"
echo "- TestingTaskTests/ScreenMockables.swift"
echo "- TestingTaskTests/Support/Generated/Mock.generated.swift"
