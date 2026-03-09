# Prompt Examples for All Scripts (OpenCode + Ollama + qwen3-coder:30b)

Ниже готовые промты для каждого `*.sh` в проекте.

## Общий шаблон (самый стабильный)

```text
Build mode. Execute exactly one command and nothing else: <COMMAND>. Then return only: <EXPECTED_OUTPUT>.
```

## 1) scripts/opencode_create_login_presenter_tests.sh

```text
Build mode. Execute exactly one command and nothing else: bash scripts/opencode_create_login_presenter_tests.sh . Then return only: DONE + TestingTaskTests/LoginScreenPresenterTests.swift
```

## 2) scripts/opencode_create_login_presenter_swifttesting_tests.sh

```text
Build mode. Execute exactly one command and nothing else: bash scripts/opencode_create_login_presenter_swifttesting_tests.sh . Then return only: DONE + TestingTaskTests/LoginScreenPresenterSwiftTestingTests.swift
```

## 3) scripts/opencode_create_presenter_tests.sh

Шаблон:

```text
Build mode. Execute exactly one command and nothing else: bash scripts/opencode_create_presenter_tests.sh . <PresenterName> [OutputFile]. Then return only: DONE + <OutputFileOrDefault>.
```

Примеры:

```text
Build mode. Execute exactly one command and nothing else: bash scripts/opencode_create_presenter_tests.sh . NewsPresenter. Then return only: DONE + TestingTaskTests/NewsPresenterTests.swift
```

```text
Build mode. Execute exactly one command and nothing else: bash scripts/opencode_create_presenter_tests.sh . ArticlePresenter TestingTaskTests/ArticlePresenterTests.swift. Then return only: DONE + TestingTaskTests/ArticlePresenterTests.swift
```

## 4) scripts/opencode_create_presenter_swifttesting_tests.sh

Шаблон:

```text
Build mode. Execute exactly one command and nothing else: bash scripts/opencode_create_presenter_swifttesting_tests.sh . <PresenterName> [OutputFile]. Then return only: DONE + <OutputFileOrDefault>.
```

Примеры:

```text
Build mode. Execute exactly one command and nothing else: bash scripts/opencode_create_presenter_swifttesting_tests.sh . SignUpScreenPresenter. Then return only: DONE + TestingTaskTests/SignUpScreenPresenterSwiftTestingTests.swift
```

```text
Build mode. Execute exactly one command and nothing else: bash scripts/opencode_create_presenter_swifttesting_tests.sh . FavoritePresenter TestingTaskTests/FavoritePresenterSwiftTestingTests.swift. Then return only: DONE + TestingTaskTests/FavoritePresenterSwiftTestingTests.swift
```

## 5) skills/ios-presenter-unit-test-writer/scripts/create_login_presenter_tests.sh

Прямой вызов (если нужен именно skill-скрипт):

```text
Build mode. Execute exactly one command and nothing else: bash skills/ios-presenter-unit-test-writer/scripts/create_login_presenter_tests.sh . Then return only: DONE + TestingTaskTests/LoginScreenPresenterTests.swift
```

## 6) skills/ios-selected-presenter-swifttesting-writer/scripts/create_login_presenter_swifttesting_tests.sh

```text
Build mode. Execute exactly one command and nothing else: bash skills/ios-selected-presenter-swifttesting-writer/scripts/create_login_presenter_swifttesting_tests.sh . Then return only: DONE + TestingTaskTests/LoginScreenPresenterSwiftTestingTests.swift
```

## 7) skills/ios-swiftymocky-maintainer/scripts/regenerate_swiftymocky.sh

```text
Build mode. Execute exactly one command and nothing else: bash skills/ios-swiftymocky-maintainer/scripts/regenerate_swiftymocky.sh . Then return only: DONE + SwiftyMocky generation completed
```

## 8) skills/ios-test-coverage-auditor/scripts/build_coverage_backlog.sh

В файл:

```text
Build mode. Execute exactly one command and nothing else: bash skills/ios-test-coverage-auditor/scripts/build_coverage_backlog.sh . /tmp/testingtask_coverage_backlog.md. Then return only: DONE + /tmp/testingtask_coverage_backlog.md
```

В stdout:

```text
Build mode. Execute exactly one command and nothing else: bash skills/ios-test-coverage-auditor/scripts/build_coverage_backlog.sh . Then return only: DONE + coverage backlog printed
```

## Рекомендация

Для OpenCode лучше использовать скрипты из `scripts/` (пункты 1-4): они короче и не содержат в пути слова `skills`, что снижает риск ложного skill-loading поведения у qwen3-coder:30b.
