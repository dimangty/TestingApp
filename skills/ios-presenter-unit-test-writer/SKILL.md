---
name: ios-presenter-unit-test-writer
description: Write and maintain XCTest unit tests for presenter logic in this iOS repository with SwiftyMocky-based interaction checks. Use when changing presenter behavior, fixing regressions, adding business rules, or expanding coverage for login, signup, news, favorite, and article flows.
---

# iOS Presenter Unit Test Writer

Create deterministic unit tests in `TestingTaskTests` that verify presenter state changes, routing, validation, and side effects.

## Workflow

1. Read [references/presenter-test-patterns.md](references/presenter-test-patterns.md).
2. Inspect the target presenter and related protocols in `TestingTask/Core/Sources/...`.
3. Reuse generated mocks from `TestingTaskTests/Support/Generated/Mock.generated.swift`.
4. If a needed mock type is missing, run `$ios-swiftymocky-maintainer` first.
5. Write tests into `TestingTaskTests/<PresenterName>Tests.swift` using `XCTestCase`.
6. Keep Given/When/Then comments and assert both behavior and interactions.

## Project-Specific Rules

1. Use `Verify(...)` for interaction checks with SwiftyMocky mocks.
2. Use `XCTest` assertions for state/value checks.
3. Inject dependencies through property wrappers, for example:

```swift
presenter.$authService.wrappedValue = authServiceMock
presenter.$progressService.wrappedValue = progressSpy
presenter.$errorService.wrappedValue = errorSpy
```

4. For final concrete services that cannot be mocked with SwiftyMocky, create small test spies/stubs in the test file.
5. Do not use network or real async timers in unit tests if behavior can be controlled with stubs.
6. Do not invent presenter API methods that are not in source.

## Coverage Checklist

1. `viewLoaded` initial setup.
2. Valid and invalid input branches.
3. Routing calls (`openMainScreen`, `openSignUpScreen`, `openArticle`, `close`).
4. Error and progress side effects.
5. Async completion path.

## OpenCode + Ollama Compatibility

1. Use Build mode and persist real file changes to disk.
2. Never call `write_file`.
3. If `write` tool is used, pass arguments as `filePath` + `content`.
4. Never call or mention unavailable tools: `todolist`, `todowrite`, `skill`.
5. Never emit pseudo tool markup like `<function=...>`, `<tool_call>`, or JSON tool stubs in chat.
6. Do not output "I will load this skill first"; assume the skill is already active and execute immediately.
7. If tool call fails with invalid arguments or unavailable tool, retry via `bash` and continue.

## qwen3-coder:30b Execution Contract

1. If presenter name and output file path are already provided, do not ask clarifying questions.
2. Do not write planning/preamble text like "I will load this skill first".
3. Do not call exploratory tools (`ls`, `pwd`, `find`) when target files are explicit in prompt.
4. Perform edits first, then return a short completion message.
5. If tool environment is limited, still complete task via bash-based file write.

## Done Criteria

1. Test file is persisted under `TestingTaskTests`.
2. Tests compile against real project APIs.
3. Happy path and failure path are both covered.
