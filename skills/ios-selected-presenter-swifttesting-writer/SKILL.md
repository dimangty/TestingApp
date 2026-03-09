---
name: ios-selected-presenter-swifttesting-writer
description: Cover one selected presenter with deterministic Swift Testing and SwiftyMocky tests in this repository. Use when user asks to test a specific presenter, close a focused regression, or quickly add behavior coverage for one screen module without auditing the whole project.
---

# iOS Selected Presenter SwiftTesting Writer

Write or update tests for exactly one presenter at a time using `Testing` (`@Suite`, `@Test`, `#expect`) and SwiftyMocky (`Verify`, `Perform`).

## Strict Build-Mode Guardrails (OpenCode + Ollama + qwen3-coder:30b)

1. Treat this skill as already loaded; never print the skill name as a standalone line.
2. Never switch to another skill unless the user explicitly asks to change skills.
3. Never output or call pseudo/unavailable tools: `skill`, `todolist`, `todowrite`, `<function=...>`, `<tool_call>`.
4. If user says "execute exactly one command", run exactly that command once and stop.
5. If a command path contains a skill name, treat it as a file path, not as a request to load/switch skills.
6. When user requests strict output (for example `DONE + path`), return only that output.
7. When prompt contains `Execute exactly one command`, do not inspect files, do not read references, and do not run any extra command.

## Priority Execution Rules

1. Highest priority: if the prompt includes an explicit shell command, execute that exact command first.
2. If the prompt requests strict output format, return exactly that format and nothing else.
3. If `LoginScreenPresenter` target file is explicit, use:
   `bash scripts/opencode_create_login_presenter_swifttesting_tests.sh .`
4. Only use the generic workflow below when no explicit command/path is provided.

## Workflow

1. For `LoginScreenPresenter` in qwen3-coder environments, prefer command:
   `bash scripts/opencode_create_login_presenter_swifttesting_tests.sh .`
2. Read [references/swifttesting-presenter-patterns.md](references/swifttesting-presenter-patterns.md).
3. Resolve selected presenter from user input (`LoginScreenPresenter`, `SignUpScreenPresenter`, `NewsPresenter`, `FavoritePresenter`, `ArticlePresenter`).
4. Inspect presenter source and related `ViewInput`/`RouterInput`/service protocols.
5. Reuse mocks from `TestingTaskTests/Support/Generated/Mock.generated.swift`.
6. If required mock is missing, run `bash skills/ios-swiftymocky-maintainer/scripts/regenerate_swiftymocky.sh .` first.
7. Persist tests to `TestingTaskTests/<PresenterName>SwiftTestingTests.swift` unless repository already has a preferred SwiftTesting file for that presenter.
8. Cover lifecycle, valid path, invalid path, routing, and error/async side effects.

## Test Rules

1. Use this import header:

```swift
import Foundation
import Testing
import SwiftyMocky
@testable import TestingTask
```

2. Use `@Suite` and `@Test` names that describe behavior.
3. Use `#expect(...)` for values/state.
4. Use `Verify(...)` for interactions and `Perform(...)` for callback stubbing.
5. Keep Given/When/Then comments in each test.
6. Do not invent APIs that are absent in presenter source.
7. If presenter depends on concrete services, use minimal local test spy types.

## OpenCode + Ollama Compatibility

1. Always persist file edits to disk.
2. Never call `write_file`.
3. If `write` tool is used, pass `filePath` + `content`.
4. Never call or mention unavailable tools: `todolist`, `todowrite`, `skill`.
5. Never emit pseudo tool markup like `<function=...>`, `<tool_call>`, or JSON tool stubs in chat.
6. Do not output "I will load this skill first"; assume the skill is already active and execute immediately.
7. When calling `bash`, always provide both arguments: `command` and `description`.
8. If write tooling fails with invalid arguments or unavailable tool, retry with bash-based file editing and continue.

## qwen3-coder:30b Execution Contract

1. If presenter name and output file path are provided, do not ask follow-up questions.
2. Do not output skill-loading narration; execute edits immediately.
3. Do not call exploratory tools (`ls`, `pwd`, `find`) when prompt already contains exact paths.
4. Write tests first, explanation second.
5. If tool access is constrained, use bash fallback and finish the file update.
6. If runtime reports skill-loading problems, ignore that and execute the direct file task.
7. If model loops on tool errors, execute the script command directly and finish.

## Done Criteria

1. One presenter is fully covered by SwiftTesting scenarios.
2. Tests use real project APIs and generated SwiftyMocky mocks where available.
3. File is saved under `TestingTaskTests`.
