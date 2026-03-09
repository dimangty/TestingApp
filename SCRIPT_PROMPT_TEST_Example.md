# SCRIPT_PROMPT_TEST_Example

Примеры промтов для `OpenCode + Ollama + qwen3-coder:30b`.

## Универсальный скрипт (SwiftyMocky + XCTest/SwiftTesting)

Скрипт:

- `scripts/opencode_create_presenter_swiftymocky_tests.sh`

Формат:

```bash
bash scripts/opencode_create_presenter_swiftymocky_tests.sh <root_dir> <PresenterName> [xctest|swifttesting] [output_file]
```

## Рекомендуемый промт (single command)

```text
Build mode. Execute exactly one command and nothing else:
bash /Users/dmitrijbykov/Documents/IOS_Projects/Qwen/scripts/opencode_create_presenter_swiftymocky_tests.sh /Users/dmitrijbykov/Documents/IOS_Projects/Qwen SignUpScreenPresenter swifttesting
Then return only: DONE: /Users/dmitrijbykov/Documents/IOS_Projects/Qwen/TestingTaskTests/SignUpScreenPresenterSwiftTestingTests.swift
```

## qwen3 schema-safe промт (если требует description для bash)

```text
Build mode. Call bash tool with:
command='bash /Users/dmitrijbykov/Documents/IOS_Projects/Qwen/scripts/opencode_create_presenter_swiftymocky_tests.sh /Users/dmitrijbykov/Documents/IOS_Projects/Qwen NewsPresenter xctest'
description='Generate SwiftyMocky XCTest tests for NewsPresenter'
Do not call any other tools.
Then return only: DONE: /Users/dmitrijbykov/Documents/IOS_Projects/Qwen/TestingTaskTests/NewsPresenterTests.swift
```

## Доп. совместимость с qwen3

Иногда qwen3 меняет имя скрипта на `swifty_mocky` (с дополнительным `_`).  
В репозитории добавлен алиас:

- `scripts/opencode_create_presenter_swifty_mocky_tests.sh`

Поэтому оба пути работают.

## Быстрые промты

XCTest:

```text
Build mode. Execute exactly one command and nothing else:
bash scripts/opencode_create_presenter_swiftymocky_tests.sh . NewsPresenter xctest
Then return only: DONE: ./TestingTaskTests/NewsPresenterTests.swift
```

SwiftTesting:

```text
Build mode. Execute exactly one command and nothing else:
bash scripts/opencode_create_presenter_swiftymocky_tests.sh . SignUpScreenPresenter swifttesting
Then return only: DONE: ./TestingTaskTests/SignUpScreenPresenterSwiftTestingTests.swift
```
