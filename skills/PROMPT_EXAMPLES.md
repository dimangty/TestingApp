# Prompt Examples for OpenCode + Ollama + qwen3-coder:30b

## Compatibility Notes (Ollama)

1. Ask for real file edits: "Build mode. Persist all changes to disk."
2. Keep prompts short and explicit about output file paths.
3. Require: do not use `write_file`.
4. If `write` is used, require `filePath` + `content`.
5. Explicitly forbid unavailable tools: `todolist`, `todowrite`, `skill`.
6. Explicitly forbid pseudo tool markup: `<function=...>` / `<tool_call>`.
7. If tool calls fail, request bash fallback in the same prompt.
8. For qwen3 in OpenCode, if using `bash` tool, explicitly require both arguments: `command` and `description`.

## Important qwen3-coder:30b Limitation

In some OpenCode setups, using `$skill-name` triggers a broken "load skill" behavior loop.
If you see responses like "I will load this skill first", "skill isn't loaded", or fake tool tags, use prompts below **without** `$skill-name`.
For command-only mode, prefer wrapper scripts in `scripts/` so the command text does not contain skill names.

## ios-test-coverage-auditor

1. `Build mode. Audit current test coverage of TestingTask and return a prioritized backlog with exact source file -> test file mapping.`
2. `Build mode. Save test coverage audit to /tmp/testingtask_coverage_backlog.md.`
3. `Build mode. Focus only on presenter and UI-flow gaps, then output top 10 next tests.`

## ios-presenter-unit-test-writer

1. `Build mode. Create TestingTaskTests/LoginScreenPresenterTests.swift with happy path, invalid phone, and sign up routing tests.`
2. `Build mode. Add tests for SignUpScreenPresenter in TestingTaskTests/SignUpScreenPresenterTests.swift with validation and error paths.`
3. `Build mode. Add NewsPresenter tests for viewLoaded, filtering, row selection routing, and favorite tap behavior.`

### Qwen hard-safe prompt (recommended)

`Build mode. Create tests for LoginScreenPresenter in TestingTaskTests/LoginScreenPresenterTests.swift and persist file edits to disk. Do not call tools todolist, todowrite, or skill. Do not output <function=...> or <tool_call> tags. Use normal file edits or bash fallback if needed.`

### If `$skill` trigger fails

`Build mode. Create/update TestingTaskTests/LoginScreenPresenterTests.swift with unit tests for LoginScreenPresenter using XCTest + SwiftyMocky. Persist real file edits. Do not call todolist/todowrite/skill tools. Do not output <function=...> or <tool_call>. Use bash fallback on write errors.`

### Ultra-strict prompt (qwen3-coder:30b)

`Build mode. Task: directly edit TestingTaskTests/LoginScreenPresenterTests.swift. Write deterministic XCTest + SwiftyMocky tests for LoginScreenPresenter (viewLoaded, phoneChanged valid/invalid, confirm success/failure, signUpTapped). Do not ask questions. Do not print planning text. Do not call tools todolist, todowrite, skill, ls, find, pwd. Do not output <function=...> or <tool_call>. Persist file edits, then return only: DONE + updated file path.`

### Recommended for qwen3-coder:30b (no `$skill`)

`Build mode. Direct task (no skill loading): edit TestingTaskTests/LoginScreenPresenterTests.swift and implement XCTest + SwiftyMocky tests for LoginScreenPresenter (viewLoaded, phoneChanged valid/invalid, confirm success/failure, signUpTapped). Make real file edits only. No questions, no planning text, no tool tags. Return only: DONE + updated file path.`

### Command-only fallback (best when model loops)

`Build mode. Execute exactly one command and nothing else: bash scripts/opencode_create_login_presenter_tests.sh . Then return only: DONE + TestingTaskTests/LoginScreenPresenterTests.swift`

### Command-only fallback for qwen3 (schema-safe)

`Build mode. Call bash tool with: command='bash scripts/opencode_create_login_presenter_tests.sh .' and description='Generate LoginScreenPresenter XCTest tests'. Do not call any other tool. Then return only: DONE + TestingTaskTests/LoginScreenPresenterTests.swift`

## ios-ui-flow-test-writer

1. `Build mode. Add a UI test that verifies invalid login phone keeps confirm button disabled. Save in TestingTaskUITests/LoginFlowUITests.swift.`
2. `Build mode. Add end-to-end flow: Login -> News tab visible -> open article cell -> article screen appears.`
3. `Build mode. Refactor existing UI tests to remove sleeps and rely only on waitForExistence.`

## ios-swiftymocky-maintainer

1. `Build mode. Create or update TestingTaskTests/ScreenMockables.swift with wrappers for all presenter view/router protocols and regenerate mocks.`
2. `Build mode. Fix stale Verify/Perform signatures after protocol changes.`
3. `Build mode. Run bash skills/ios-swiftymocky-maintainer/scripts/regenerate_swiftymocky.sh from repo root.`

## ios-selected-presenter-swifttesting-writer

1. `Build mode. Cover LoginScreenPresenter with Swift Testing + SwiftyMocky and save to TestingTaskTests/LoginScreenPresenterSwiftTestingTests.swift.`
2. `Build mode. Add SwiftTesting tests for NewsPresenter: viewLoaded, search filtering, didSelectRow routing, and favorite tap flow.`
3. `Build mode. Cover SignUpScreenPresenter and include valid, invalid, and sign up failure scenarios.`

### Ultra-strict prompt (qwen3-coder:30b)

`Build mode. Task: directly edit TestingTaskTests/LoginScreenPresenterSwiftTestingTests.swift. Write Swift Testing + SwiftyMocky tests for LoginScreenPresenter (@Suite/@Test/#expect + Verify/Perform). Cover: viewLoaded, phoneChanged valid/invalid, confirm success/failure, signUpTapped. Do not ask questions. Do not print planning text. Do not call tools todolist, todowrite, skill, ls, find, pwd. Do not output <function=...> or <tool_call>. Persist file edits, then return only: DONE + updated file path.`

### Recommended for qwen3-coder:30b (no `$skill`)

`Build mode. Direct task (no skill loading): edit TestingTaskTests/LoginScreenPresenterSwiftTestingTests.swift and implement Swift Testing + SwiftyMocky tests for LoginScreenPresenter (@Suite/@Test/#expect + Verify/Perform, including success/failure flows). Make real file edits only. No questions, no planning text, no tool tags. Return only: DONE + updated file path.`

### Command-only fallback (best when model loops)

`Build mode. Execute exactly one command and nothing else: bash scripts/opencode_create_login_presenter_swifttesting_tests.sh . Then return only: DONE + TestingTaskTests/LoginScreenPresenterSwiftTestingTests.swift`

### Command-only fallback for qwen3 (schema-safe)

`Build mode. Call bash tool with: command='bash scripts/opencode_create_login_presenter_swifttesting_tests.sh .' and description='Generate LoginScreenPresenter SwiftTesting tests'. Do not call any other tool. Then return only: DONE + TestingTaskTests/LoginScreenPresenterSwiftTestingTests.swift`

## Russian Prompts

1. `Build mode. Составь приоритетный бэклог покрытия тестами с путями файлов.`
2. `Build mode. Создай unit-тесты для LoginScreenPresenter в TestingTaskTests/LoginScreenPresenterTests.swift.`
3. `Build mode. Добавь UI-тест для сценария Login -> News.`
4. `Build mode. Перегенерируй моки после изменения протоколов.`
5. `Build mode. Покрой NewsPresenter тестами на SwiftTesting + SwiftyMocky.`

### Русский hard-safe промт (recommended)

`Build mode. Создай тесты для LoginScreenPresenter в TestingTaskTests/LoginScreenPresenterTests.swift с реальными правками файлов. Не вызывай инструменты todolist, todowrite, skill. Не выводи теги <function=...> и <tool_call>. Если write не сработал, используй bash fallback и заверши задачу.`

### Если триггер `$skill` не сработал

`Build mode. Создай/обнови TestingTaskTests/LoginScreenPresenterTests.swift: unit-тесты для LoginScreenPresenter на XCTest + SwiftyMocky. Сохрани реальные изменения в файле. Не вызывай todolist/todowrite/skill и не выводи <function=...>/<tool_call>. При ошибках write используй bash fallback.`

### Русский ultra-strict промт (qwen3-coder:30b)

`Build mode. Задача: напрямую отредактируй TestingTaskTests/LoginScreenPresenterTests.swift. Напиши детерминированные XCTest + SwiftyMocky тесты для LoginScreenPresenter (viewLoaded, phoneChanged valid/invalid, confirm success/failure, signUpTapped). Не задавай вопросов. Не пиши план/прелюдию. Не вызывай инструменты todolist, todowrite, skill, ls, find, pwd. Не выводи теги <function=...> или <tool_call>. Сохрани изменения в файл и верни только: DONE + путь к файлу.`

### Русский рекомендуемый для qwen3-coder:30b (без `$skill`)

`Build mode. Прямая задача (без загрузки skill): отредактируй TestingTaskTests/LoginScreenPresenterTests.swift и реализуй XCTest + SwiftyMocky тесты для LoginScreenPresenter (viewLoaded, phoneChanged valid/invalid, confirm success/failure, signUpTapped). Только реальные правки файла. Без вопросов, без плана, без tool-тегов. Верни только: DONE + путь к файлу.`

### Русский command-only fallback (лучший при цикле модели)

`Build mode. Выполни ровно одну команду и ничего больше: bash scripts/opencode_create_login_presenter_tests.sh . Затем верни только: DONE + TestingTaskTests/LoginScreenPresenterTests.swift`

### Русский command-only fallback для qwen3 (schema-safe)

`Build mode. Вызови инструмент bash с аргументами: command='bash scripts/opencode_create_login_presenter_tests.sh .' и description='Сгенерировать XCTest тесты LoginScreenPresenter'. Не вызывай другие инструменты. Затем верни только: DONE + TestingTaskTests/LoginScreenPresenterTests.swift`
