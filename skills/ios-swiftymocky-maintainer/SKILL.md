---
name: ios-swiftymocky-maintainer
description: Maintain SwiftyMocky wrappers and generated mocks for this repository. Use when protocols change, tests fail due to missing mock types or Verify/Perform signatures, or new view/router/service contracts need mock coverage.
---

# iOS SwiftyMocky Maintainer

Keep test mocks synchronized with production protocols and avoid manual drift.

## Workflow

1. Read [references/swiftymocky-workflow.md](references/swiftymocky-workflow.md).
2. Ensure `TestingTaskTests/ScreenMockables.swift` exists and contains needed `AutoMockable` wrappers.
3. Run `bash skills/ios-swiftymocky-maintainer/scripts/regenerate_swiftymocky.sh .`.
4. Review resulting diffs in:
   - `TestingTaskTests/ScreenMockables.swift`
   - `TestingTaskTests/Support/Generated/Mock.generated.swift`
5. Fix wrapper definitions and regenerate until mock API matches required test calls.

## Rules

1. Do not hand-edit `Mock.generated.swift`.
2. Keep wrappers in `ScreenMockables.swift` small and protocol-only.
3. Keep generated changes isolated to mock files unless task explicitly includes test updates.
4. Re-run generation after any protocol signature change used by tests.

## OpenCode + Ollama Compatibility

1. Prefer running `bash skills/ios-swiftymocky-maintainer/scripts/regenerate_swiftymocky.sh .`.
2. Never call `write_file`.
3. If `write` tool is used, pass `filePath` + `content`.
4. If write tooling fails, switch to bash-based file editing and continue.

## Done Criteria

1. Generator command completes successfully.
2. Required `*Mock` types are present in generated output.
3. Mock usage compiles for current tests.
