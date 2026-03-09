#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="${1:-.}"
OUT_FILE="${2:-}"

if [[ ! -d "$ROOT_DIR" ]]; then
  echo "Root directory not found: $ROOT_DIR" >&2
  exit 1
fi

cd "$ROOT_DIR"

if [[ ! -d "TestingTask" ]] || [[ ! -d "TestingTaskTests" ]] || [[ ! -d "TestingTaskUITests" ]]; then
  echo "Expected TestingTask, TestingTaskTests, and TestingTaskUITests directories in: $PWD" >&2
  exit 1
fi

if [[ -n "$OUT_FILE" ]]; then
  mkdir -p "$(dirname "$OUT_FILE")"
  exec >"$OUT_FILE"
fi

echo "# TestingTask Coverage Backlog"
echo
echo "Generated at: $(date -u +"%Y-%m-%d %H:%M:%S UTC")"
echo "Root: $PWD"
echo

presenter_total=0
presenter_missing=0
service_total=0
service_missing=0
ui_total=0

echo "## Presenter Unit Tests"
while IFS= read -r presenter_file; do
  presenter_total=$((presenter_total + 1))
  presenter_name="$(basename "$presenter_file" .swift)"
  expected_test="TestingTaskTests/${presenter_name}Tests.swift"

  if [[ -f "$expected_test" ]]; then
    status="covered"
  else
    status="missing"
    presenter_missing=$((presenter_missing + 1))
  fi

  echo "- [$status] $presenter_file -> $expected_test"
done < <(find TestingTask/Core/Sources -type f -path "*/Presenter/*.swift" | sort)
echo

echo "## Service and Utility Unit Tests"
while IFS= read -r service_file; do
  service_total=$((service_total + 1))
  service_name="$(basename "$service_file" .swift)"
  expected_test="TestingTaskTests/${service_name}Tests.swift"

  if [[ -f "$expected_test" ]]; then
    status="covered"
  else
    status="missing"
    service_missing=$((service_missing + 1))
  fi

  echo "- [$status] $service_file -> $expected_test"
done < <(
  find TestingTask/Core/Services -type f -name "*.swift" \
    ! -name "I*.swift" \
    ! -name "*Delegate.swift" \
    ! -name "ProgressHudView.swift" | sort
)
echo

echo "## Existing UI Tests"
while IFS= read -r ui_test_file; do
  ui_total=$((ui_total + 1))
  echo "- [present] $ui_test_file"
done < <(find TestingTaskUITests -type f -name "*Tests.swift" | sort)
echo

echo "## Accessibility Identifiers Found"
ids="$(rg -o 'accessibilityIdentifier\s*=\s*"[^"]+"' TestingTask | sed -E 's/.*"([^"]+)"/\1/' | sort -u || true)"
if [[ -z "$ids" ]]; then
  echo "- none found by static scan"
else
  while IFS= read -r item; do
    [[ -z "$item" ]] && continue
    echo "- $item"
  done <<<"$ids"
fi
echo

echo "## Summary"
echo "- presenters: $presenter_total total, $presenter_missing missing tests"
echo "- services: $service_total total, $service_missing missing tests"
echo "- ui test files: $ui_total"
echo

echo "## Suggested Next Actions"
echo "- Run \$ios-presenter-unit-test-writer for P1 presenters with missing tests."
echo "- Run \$ios-ui-flow-test-writer to add missing user-critical journeys."
echo "- Run \$ios-swiftymocky-maintainer before presenter tests if mock APIs are stale."
