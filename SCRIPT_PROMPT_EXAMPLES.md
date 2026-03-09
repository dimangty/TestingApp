# Prompt Examples for All Scripts (OpenCode + Ollama + qwen3-coder:30b)

Ниже готовые промты для всех `*.sh` скриптов проекта.

## Общий шаблон

```text
Build mode. Execute exactly one command and nothing else:
<COMMAND>
Then return only: <EXPECTED_OUTPUT>
```

## qwen3 schema-safe (если просит `description` для bash)

```text
Build mode. Call bash tool with:
command='<COMMAND>'
description='<SHORT_DESCRIPTION>'
Do not call any other tools.
Then return only: <EXPECTED_OUTPUT>
```

## 1) Универсальный скрипт (рекомендуется)

Файл:

- `scripts/opencode_create_presenter_swiftymocky_tests.sh`

Назначение:

- один скрипт для любого presenter;
- поддержка `xctest` и `swifttesting`.

Формат:

```text
bash scripts/opencode_create_presenter_swiftymocky_tests.sh <root_dir> <PresenterName> [xctest|swifttesting] [output_file]
```

Пример (`xctest`):

```text
Build mode. Execute exactly one command and nothing else:
bash scripts/opencode_create_presenter_swiftymocky_tests.sh . NewsPresenter xctest
Then return only: DONE: ./TestingTaskTests/NewsPresenterTests.swift
```

Пример (`swifttesting`):

```text
Build mode. Execute exactly one command and nothing else:
bash scripts/opencode_create_presenter_swiftymocky_tests.sh . SignUpScreenPresenter swifttesting
Then return only: DONE: ./TestingTaskTests/SignUpScreenPresenterSwiftTestingTests.swift
```

Schema-safe пример (`opencode-cli` / qwen3):

```text
Build mode. Call bash tool with:
command='bash /Users/dmitrijbykov/Documents/IOS_Projects/Qwen/scripts/opencode_create_presenter_swiftymocky_tests.sh /Users/dmitrijbykov/Documents/IOS_Projects/Qwen SignUpScreenPresenter swifttesting'
description='Generate SwiftyMocky SwiftTesting tests for SignUpScreenPresenter'
Do not call any other tools.
Then return only: DONE: /Users/dmitrijbykov/Documents/IOS_Projects/Qwen/TestingTaskTests/SignUpScreenPresenterSwiftTestingTests.swift
```

## 2) scripts/opencode_create_login_presenter_tests.sh

```text
Build mode. Execute exactly one command and nothing else:
bash scripts/opencode_create_login_presenter_tests.sh .
Then return only: DONE: ./TestingTaskTests/LoginScreenPresenterTests.swift
```

## 3) scripts/opencode_create_login_presenter_swifttesting_tests.sh

```text
Build mode. Execute exactly one command and nothing else:
bash scripts/opencode_create_login_presenter_swifttesting_tests.sh .
Then return only: DONE: ./TestingTaskTests/LoginScreenPresenterSwiftTestingTests.swift
```

## 4) scripts/opencode_create_presenter_tests.sh

```text
Build mode. Execute exactly one command and nothing else:
bash scripts/opencode_create_presenter_tests.sh . <PresenterName> [OutputFile]
Then return only: DONE: <OutputFileOrDefault>
```

## 5) scripts/opencode_create_presenter_swifttesting_tests.sh

```text
Build mode. Execute exactly one command and nothing else:
bash scripts/opencode_create_presenter_swifttesting_tests.sh . <PresenterName> [OutputFile]
Then return only: DONE: <OutputFileOrDefault>
```

## 6) skills/ios-presenter-unit-test-writer/scripts/create_login_presenter_tests.sh

```text
Build mode. Execute exactly one command and nothing else:
bash skills/ios-presenter-unit-test-writer/scripts/create_login_presenter_tests.sh .
Then return only: DONE: ./TestingTaskTests/LoginScreenPresenterTests.swift
```

## 7) skills/ios-selected-presenter-swifttesting-writer/scripts/create_login_presenter_swifttesting_tests.sh

```text
Build mode. Execute exactly one command and nothing else:
bash skills/ios-selected-presenter-swifttesting-writer/scripts/create_login_presenter_swifttesting_tests.sh .
Then return only: DONE: ./TestingTaskTests/LoginScreenPresenterSwiftTestingTests.swift
```

## 8) skills/ios-swiftymocky-maintainer/scripts/regenerate_swiftymocky.sh

```text
Build mode. Execute exactly one command and nothing else:
bash skills/ios-swiftymocky-maintainer/scripts/regenerate_swiftymocky.sh .
Then return only: SwiftyMocky generation completed.
```

## 9) skills/ios-test-coverage-auditor/scripts/build_coverage_backlog.sh

В файл:

```text
Build mode. Execute exactly one command and nothing else:
bash skills/ios-test-coverage-auditor/scripts/build_coverage_backlog.sh . /tmp/testingtask_coverage_backlog.md
Then return only: DONE: /tmp/testingtask_coverage_backlog.md
```

В stdout:

```text
Build mode. Execute exactly one command and nothing else:
bash skills/ios-test-coverage-auditor/scripts/build_coverage_backlog.sh .
Then return only: DONE: coverage backlog printed
```

## Если видишь `EACCES ... mkdir '/Users/user/Projects'`

Используй абсолютные пути (и корень, и скрипт), например:

```text
Build mode. Execute exactly one command and nothing else:
bash /Users/dmitrijbykov/Documents/IOS_Projects/Qwen/scripts/opencode_create_presenter_swiftymocky_tests.sh /Users/dmitrijbykov/Documents/IOS_Projects/Qwen SignUpScreenPresenter swifttesting
Then return only: DONE: /Users/dmitrijbykov/Documents/IOS_Projects/Qwen/TestingTaskTests/SignUpScreenPresenterSwiftTestingTests.swift
```
