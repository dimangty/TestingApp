# SCRIPT_PROMPT_TEST_Example

Ниже примеры промтов для `opencode + qwen3-coder:30b`, чтобы вызвать генерацию тестов презентера через:

- `xctest`
- `swifttesting`

Основной скрипт:

- `scripts/opencode_create_presenter_swiftymocky_tests.sh`
- `scripts/opencode_create_presenter_swifty_mocky_tests.sh` — алиас

Формат команды:

```bash
bash scripts/opencode_create_presenter_swiftymocky_tests.sh <root_dir> <PresenterName> [xctest|swifttesting] [output_file]
```

## Что использовать в первую очередь

По скриншотам видно, что формат `Execute exactly one command` у `qwen3-coder:30b` иногда уходит в:

- поиск вместо вызова `bash`;
- попытку "искать файлы";
- не тот shell command;
- чтение и "починку" скрипта после первой же ошибки.

Поэтому для `opencode` лучше сначала использовать `schema-safe` промт с явным `Call bash tool with`.

Ещё одна проблема на скриншотах: внутри скрипта не находится `rg`.
Поэтому в примерах ниже команда запускается через `/bin/zsh -lc` c явным `PATH`, чтобы `rg` находился и из `Homebrew`, и из стандартных директорий.

## Рекомендуемый промт для XCTest

```text
Build mode. Call bash tool with:
command='/bin/zsh -lc "export PATH=/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH; bash /Users/dmitrijbykov/Documents/IOS_Projects/Qwen/scripts/opencode_create_presenter_swiftymocky_tests.sh /Users/dmitrijbykov/Documents/IOS_Projects/Qwen LoginScreenPresenter xctest"'
description='Generate XCTest presenter tests for LoginScreenPresenter'
Do not search.
Do not inspect files.
Do not read the script.
Do not modify the script.
Do not call any other tools.
Do not explain anything.
If the command fails, stop immediately and do not debug the failure.
Then return only: DONE: /Users/dmitrijbykov/Documents/IOS_Projects/Qwen/TestingTaskTests/LoginScreenPresenterTests.swift
```

## Рекомендуемый промт для SwiftTesting

```text
Build mode. Call bash tool with:
command='/bin/zsh -lc "export PATH=/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH; bash /Users/dmitrijbykov/Documents/IOS_Projects/Qwen/scripts/opencode_create_presenter_swiftymocky_tests.sh /Users/dmitrijbykov/Documents/IOS_Projects/Qwen SignUpScreenPresenter swifttesting"'
description='Generate Swift Testing presenter tests for SignUpScreenPresenter'
Do not search.
Do not inspect files.
Do not read the script.
Do not modify the script.
Do not call any other tools.
Do not explain anything.
If the command fails, stop immediately and do not debug the failure.
Then return only: DONE: /Users/dmitrijbykov/Documents/IOS_Projects/Qwen/TestingTaskTests/SignUpScreenPresenterSwiftTestingTests.swift
```

## Запасной промт для XCTest

Используй только если `Call bash tool with` по какой-то причине недоступен.

```text
Build mode. Execute exactly one command and nothing else:
/bin/zsh -lc "export PATH=/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH; bash /Users/dmitrijbykov/Documents/IOS_Projects/Qwen/scripts/opencode_create_presenter_swiftymocky_tests.sh /Users/dmitrijbykov/Documents/IOS_Projects/Qwen LoginScreenPresenter xctest"
Do not search.
Do not inspect files.
Do not read or modify any files.
If the command fails, stop immediately.
Then return only: DONE: /Users/dmitrijbykov/Documents/IOS_Projects/Qwen/TestingTaskTests/LoginScreenPresenterTests.swift
```

## Запасной промт для SwiftTesting

```text
Build mode. Execute exactly one command and nothing else:
/bin/zsh -lc "export PATH=/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH; bash /Users/dmitrijbykov/Documents/IOS_Projects/Qwen/scripts/opencode_create_presenter_swiftymocky_tests.sh /Users/dmitrijbykov/Documents/IOS_Projects/Qwen SignUpScreenPresenter swifttesting"
Do not search.
Do not inspect files.
Do not read or modify any files.
If the command fails, stop immediately.
Then return only: DONE: /Users/dmitrijbykov/Documents/IOS_Projects/Qwen/TestingTaskTests/SignUpScreenPresenterSwiftTestingTests.swift
```

## Короткие относительные варианты

XCTest:

```text
Build mode. Call bash tool with:
command='/bin/zsh -lc "export PATH=/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH; bash scripts/opencode_create_presenter_swiftymocky_tests.sh . LoginScreenPresenter xctest"'
description='Generate XCTest presenter tests for LoginScreenPresenter'
Do not call any other tools.
Then return only: DONE: ./TestingTaskTests/LoginScreenPresenterTests.swift
```

SwiftTesting:

```text
Build mode. Call bash tool with:
command='/bin/zsh -lc "export PATH=/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH; bash scripts/opencode_create_presenter_swiftymocky_tests.sh . SignUpScreenPresenter swifttesting"'
description='Generate Swift Testing presenter tests for SignUpScreenPresenter'
Do not call any other tools.
Then return only: DONE: ./TestingTaskTests/SignUpScreenPresenterSwiftTestingTests.swift
```

## Практические правила

- Используй абсолютные пути, если модель начинает писать про `files not found`.
- Явно пиши `Call bash tool with`, если модель уходит в поиск.
- Добавляй `PATH=/opt/homebrew/bin:/usr/local/bin:...`, если внутри скрипта не находится `rg`.
- Не проси модель "найти" или "посмотреть" что-то до запуска команды.
- Явно запрещай читать и чинить скрипт после ошибки команды.
- Ожидаемый ответ всегда должен быть только `DONE: <path>`.
