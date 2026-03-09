---
name: ios-ui-flow-test-writer
description: Add and maintain deterministic XCTest UI flow tests for this iOS app. Use when user journeys change, accessibility identifiers are added/updated, regressions appear in login/signup/navigation, or UI smoke coverage must be expanded.
---

# iOS UI Flow Test Writer

Create stable tests in `TestingTaskUITests` using the existing launch and selector conventions.

## Workflow

1. Read [references/ui-test-patterns.md](references/ui-test-patterns.md).
2. Add or update tests under `TestingTaskUITests`.
3. Always extend `UITestBase` and launch app with `launchApp()`.
4. Use accessibility IDs and explicit waits before interaction.
5. Keep one behavior per test and deterministic assertions.
6. Persist edits to repository files.

## Test Writing Rules

1. Avoid `sleep(...)`.
2. Use `waitForExistence(timeout:)` for first element of each screen.
3. Prefer IDs like `login.phone`, `login.confirm`, `signup.createAccount`.
4. Keep data deterministic and short.
5. Assert outcomes that matter to user flow (button enabled, screen visible, tab opened).

## Recommended Scenarios

1. Login happy path and invalid input behavior.
2. Signup completion flow.
3. Navigation from login to tabs.
4. News-to-article and favorite toggling flow.

## OpenCode + Ollama Compatibility

1. Use Build mode and persist edits to `TestingTaskUITests` files.
2. Never call `write_file`.
3. If `write` tool is used, pass `filePath` + `content`.
4. On tool argument/schema failures, retry via `bash`.

## Done Criteria

1. Tests use stable selectors and waits.
2. Tests are deterministic across reruns.
3. Scenarios map to real user behavior, not implementation details.
