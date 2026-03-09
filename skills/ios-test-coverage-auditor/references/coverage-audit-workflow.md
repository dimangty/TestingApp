# Coverage Audit Workflow (TestingTask)

## Goal

Build a realistic backlog of missing tests for this repository with exact source and destination test files.

## Quick Scan Command

Run:

```bash
bash skills/ios-test-coverage-auditor/scripts/build_coverage_backlog.sh .
```

Optional output file:

```bash
bash skills/ios-test-coverage-auditor/scripts/build_coverage_backlog.sh . /tmp/testingtask_coverage_backlog.md
```

## What to Audit

1. Presenter unit coverage:
   - `TestingTask/Core/Sources/*/Presenter/*.swift`
   - expected tests: `TestingTaskTests/<PresenterName>Tests.swift`
2. Service and utility unit coverage:
   - `TestingTask/Core/Services/**/*.swift`
   - exclude protocol-only files and generated/runtime support files
3. UI flow coverage:
   - existing: `TestingTaskUITests/*Tests.swift`
   - compare with current user-critical paths (login, signup, tabs, article, favorites)

## Prioritization Rules

1. `P1`: auth and routing regressions that break app entry (`Login`, `SignUp`, main tab navigation).
2. `P1`: business-critical list/detail flows (`News`, `Favorite`, `Article` presenters).
3. `P2`: validation edge-cases and error handling paths.
4. `P3`: low-risk utilities that are unlikely to regress.

## Testability Blockers to Flag

1. Presenter depends on concrete/final services with no protocol seam.
2. Async behavior cannot be controlled without waiting on real timers.
3. State is hidden and can only be validated through side effects.

When a blocker exists, propose a minimal refactor before writing tests.

## Output Contract

Return:

1. Coverage snapshot with current files.
2. Prioritized missing tests with reasons.
3. Ready-to-run prompts for:
   - `$ios-presenter-unit-test-writer`
   - `$ios-ui-flow-test-writer`
   - `$ios-swiftymocky-maintainer`
