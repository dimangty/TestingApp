#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="${1:-.}"
PRESENTER_NAME="${2:-}"
OUT_FILE="${3:-}"

if [[ -z "$PRESENTER_NAME" ]]; then
  echo "Usage: bash scripts/opencode_create_presenter_tests.sh <root_dir> <PresenterName> [output_file]"
  exit 1
fi

ROOT_DIR="${ROOT_DIR%/}"

if [[ "$PRESENTER_NAME" == "LoginScreenPresenter" ]]; then
  if [[ -n "$OUT_FILE" ]]; then
    bash "$ROOT_DIR/scripts/opencode_create_login_presenter_tests.sh" "$ROOT_DIR" >/dev/null
    mkdir -p "$(dirname "$OUT_FILE")"
    cp "$ROOT_DIR/TestingTaskTests/LoginScreenPresenterTests.swift" "$OUT_FILE"
    echo "DONE: $OUT_FILE"
  else
    bash "$ROOT_DIR/scripts/opencode_create_login_presenter_tests.sh" "$ROOT_DIR"
  fi
  exit 0
fi

if [[ -z "$OUT_FILE" ]]; then
  OUT_FILE="$ROOT_DIR/TestingTaskTests/${PRESENTER_NAME}Tests.swift"
fi

SOURCE_FILE="$(find "$ROOT_DIR/TestingTask/Core/Sources" -type f -name "${PRESENTER_NAME}.swift" | head -n 1)"
if [[ -z "$SOURCE_FILE" ]]; then
  echo "ERROR: Presenter source not found for ${PRESENTER_NAME}"
  exit 1
fi

METHODS=()
while IFS= read -r method; do
  [[ -n "$method" ]] && METHODS+=("$method")
done < <(
  grep -E '[[:space:]]func[[:space:]]+[A-Za-z_][A-Za-z0-9_]*[[:space:]]*\(' "$SOURCE_FILE" \
    | grep -Ev '^[[:space:]]*private[[:space:]]+.*func[[:space:]]+' \
    | sed -E 's/.*func[[:space:]]+([A-Za-z_][A-Za-z0-9_]*)[[:space:]]*\(.*/\1/' \
    | grep -Ev '^init$' \
    | sort -u \
    || true
)

if [[ ${#METHODS[@]} -eq 0 ]]; then
  METHODS=("viewLoaded")
fi

mkdir -p "$(dirname "$OUT_FILE")"

{
  cat <<SWIFT_HEADER
import XCTest
import SwiftyMocky
@testable import TestingTask

final class ${PRESENTER_NAME}Tests: XCTestCase {
    private var presenter: ${PRESENTER_NAME}!

    override func setUp() {
        super.setUp()
        presenter = makePresenter()
    }

SWIFT_HEADER

  for method in "${METHODS[@]}"; do
    sanitized_method="$(echo "$method" | sed 's/[^A-Za-z0-9_]/_/g')"
    cat <<SWIFT_METHOD
    func test_${sanitized_method}_TODO() {
        // TODO: Implement behavior checks for ${PRESENTER_NAME}.${method}()
        XCTFail("TODO: implement ${PRESENTER_NAME}.${method} test")
    }

SWIFT_METHOD
  done

  cat <<SWIFT_FOOTER
}

private extension ${PRESENTER_NAME}Tests {
    func makePresenter() -> ${PRESENTER_NAME} {
        fatalError("TODO: initialize ${PRESENTER_NAME} with mocks and dependencies")
    }
}
SWIFT_FOOTER
} >"$OUT_FILE"

echo "DONE: $OUT_FILE"
