---
name: ios-test-coverage-auditor
description: Audit current iOS test coverage in this repository and produce a prioritized backlog of missing tests with concrete next actions. Use when the user asks to improve coverage, find testing gaps, plan what to test next, or estimate effort before writing unit/UI tests.
---

# iOS Test Coverage Auditor

Create an actionable coverage plan for `TestingTask` with real file paths and test targets.
Focus on what is missing now, not generic advice.

## Workflow

1. Read [references/coverage-audit-workflow.md](references/coverage-audit-workflow.md).
2. Run `bash skills/ios-test-coverage-auditor/scripts/build_coverage_backlog.sh .` from repo root.
3. Validate each reported gap by checking source and test files.
4. Prioritize by business risk and regression risk (auth flow, signup validation, news/favorites state, routing).
5. Return:
   - current state summary,
   - prioritized missing tests,
   - concrete prompts that can be executed by `$ios-presenter-unit-test-writer`, `$ios-ui-flow-test-writer`, and `$ios-swiftymocky-maintainer`.

## Output Format

Use this structure:

1. `Coverage Snapshot`
2. `Critical Gaps (P1)`
3. `Important Gaps (P2)`
4. `Prompt Queue`

Each gap entry must include:

- source file,
- expected test file,
- why it matters,
- minimum test scenarios.

## Rules

1. Never claim coverage percentages unless produced by a real command in this run.
2. Never mark a module as covered if only generated mocks exist.
3. Keep prompts short and runnable with local models.
4. Mark testability blockers explicitly (for example: presenter depends on final concrete service).

## OpenCode + Ollama Compatibility

1. Prefer `bash` execution for the audit script.
2. If report needs to be written to a file, persist it to disk, not chat-only output.
3. Never call `write_file`.
4. If `write` tool is used, pass `filePath` + `content`; on failure retry via `bash`.

## Done Criteria

1. Backlog lists real missing test files.
2. Priorities and rationale are explicit.
3. Prompt queue is ready to run without extra rewording.
