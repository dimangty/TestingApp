# Prompt Examples for OpenCode + Ollama + qwen3-coder:30b

## Compatibility Notes (Ollama)

1. Ask for real file edits: "Build mode. Persist all changes to disk."
2. Keep prompts short and explicit about output file paths.
3. Require: do not use `write_file`.
4. If `write` is used, require `filePath` + `content`.
5. Explicitly forbid unavailable tools: `todolist`, `todowrite`, `skill`.
6. Explicitly forbid pseudo tool markup: `<function=...>` / `<tool_call>`.
7. If tool calls fail, request bash fallback in the same prompt.

## ios-test-coverage-auditor

1. `Use $ios-test-coverage-auditor. Build mode. Audit current test coverage of TestingTask and return a prioritized backlog with exact source file -> test file mapping.`
2. `Use $ios-test-coverage-auditor and save the audit to /tmp/testingtask_coverage_backlog.md.`
3. `Use $ios-test-coverage-auditor. Focus only on presenter and UI-flow gaps, then output top 10 next tests.`

## ios-presenter-unit-test-writer

1. `Use $ios-presenter-unit-test-writer. Build mode. Create TestingTaskTests/LoginScreenPresenterTests.swift with happy path, invalid phone, and sign up routing tests.`
2. `Use $ios-presenter-unit-test-writer to add tests for SignUpScreenPresenter in TestingTaskTests/SignUpScreenPresenterTests.swift with validation and error paths.`
3. `Use $ios-presenter-unit-test-writer. Add NewsPresenter tests for viewLoaded, filtering, row selection routing, and favorite tap behavior.`

### Qwen hard-safe prompt (recommended)

`Build mode. Use $ios-presenter-unit-test-writer. Create tests for LoginScreenPresenter in TestingTaskTests/LoginScreenPresenterTests.swift and persist file edits to disk. Do not call tools todolist, todowrite, or skill. Do not output <function=...> or <tool_call> tags. Use normal file edits or bash fallback if needed.`

### If `$skill` trigger fails

`Build mode. Create/update TestingTaskTests/LoginScreenPresenterTests.swift with unit tests for LoginScreenPresenter using XCTest + SwiftyMocky. Persist real file edits. Do not call todolist/todowrite/skill tools. Do not output <function=...> or <tool_call>. Use bash fallback on write errors.`

### Ultra-strict prompt (qwen3-coder:30b)

`Build mode. Task: directly edit TestingTaskTests/LoginScreenPresenterTests.swift. Write deterministic XCTest + SwiftyMocky tests for LoginScreenPresenter (viewLoaded, phoneChanged valid/invalid, confirm success/failure, signUpTapped). Do not ask questions. Do not print planning text. Do not call tools todolist, todowrite, skill, ls, find, pwd. Do not output <function=...> or <tool_call>. Persist file edits, then return only: DONE + updated file path.`

## ios-ui-flow-test-writer

1. `Use $ios-ui-flow-test-writer. Build mode. Add a UI test that verifies invalid login phone keeps confirm button disabled. Save in TestingTaskUITests/LoginFlowUITests.swift.`
2. `Use $ios-ui-flow-test-writer to add end-to-end flow: Login -> News tab visible -> open article cell -> article screen appears.`
3. `Use $ios-ui-flow-test-writer and refactor existing UI tests to remove sleeps and rely only on waitForExistence.`

## ios-swiftymocky-maintainer

1. `Use $ios-swiftymocky-maintainer. Build mode. Create or update TestingTaskTests/ScreenMockables.swift with wrappers for all presenter view/router protocols and regenerate mocks.`
2. `Use $ios-swiftymocky-maintainer to fix stale Verify/Perform signatures after protocol changes.`
3. `Use $ios-swiftymocky-maintainer and run bash skills/ios-swiftymocky-maintainer/scripts/regenerate_swiftymocky.sh from repo root.`

## ios-selected-presenter-swifttesting-writer

1. `Use $ios-selected-presenter-swifttesting-writer. Build mode. Cover LoginScreenPresenter with Swift Testing + SwiftyMocky and save to TestingTaskTests/LoginScreenPresenterSwiftTestingTests.swift.`
2. `Use $ios-selected-presenter-swifttesting-writer to add SwiftTesting tests for NewsPresenter: viewLoaded, search filtering, didSelectRow routing, and favorite tap flow.`
3. `Use $ios-selected-presenter-swifttesting-writer for SignUpScreenPresenter and include valid, invalid, and sign up failure scenarios.`

### Ultra-strict prompt (qwen3-coder:30b)

`Build mode. Task: directly edit TestingTaskTests/LoginScreenPresenterSwiftTestingTests.swift. Write Swift Testing + SwiftyMocky tests for LoginScreenPresenter (@Suite/@Test/#expect + Verify/Perform). Cover: viewLoaded, phoneChanged valid/invalid, confirm success/failure, signUpTapped. Do not ask questions. Do not print planning text. Do not call tools todolist, todowrite, skill, ls, find, pwd. Do not output <function=...> or <tool_call>. Persist file edits, then return only: DONE + updated file path.`

## Russian Prompts

1. `Используй $ios-test-coverage-auditor и составь приоритетный бэклог покрытия тестами с путями файлов.`
2. `Используй $ios-presenter-unit-test-writer и создай unit-тесты для LoginScreenPresenter в TestingTaskTests/LoginScreenPresenterTests.swift.`
3. `Используй $ios-ui-flow-test-writer и добавь UI-тест для сценария Login -> News.`
4. `Используй $ios-swiftymocky-maintainer и перегенерируй моки после изменения протоколов.`
5. `Используй $ios-selected-presenter-swifttesting-writer и покрой NewsPresenter тестами на SwiftTesting + SwiftyMocky.`

### Русский hard-safe промт (recommended)

`Build mode. Используй $ios-presenter-unit-test-writer и создай тесты для LoginScreenPresenter в TestingTaskTests/LoginScreenPresenterTests.swift с реальными правками файлов. Не вызывай инструменты todolist, todowrite, skill. Не выводи теги <function=...> и <tool_call>. Если write не сработал, используй bash fallback и заверши задачу.`

### Если триггер `$skill` не сработал

`Build mode. Создай/обнови TestingTaskTests/LoginScreenPresenterTests.swift: unit-тесты для LoginScreenPresenter на XCTest + SwiftyMocky. Сохрани реальные изменения в файле. Не вызывай todolist/todowrite/skill и не выводи <function=...>/<tool_call>. При ошибках write используй bash fallback.`

### Русский ultra-strict промт (qwen3-coder:30b)

`Build mode. Задача: напрямую отредактируй TestingTaskTests/LoginScreenPresenterTests.swift. Напиши детерминированные XCTest + SwiftyMocky тесты для LoginScreenPresenter (viewLoaded, phoneChanged valid/invalid, confirm success/failure, signUpTapped). Не задавай вопросов. Не пиши план/прелюдию. Не вызывай инструменты todolist, todowrite, skill, ls, find, pwd. Не выводи теги <function=...> или <tool_call>. Сохрани изменения в файл и верни только: DONE + путь к файлу.`
