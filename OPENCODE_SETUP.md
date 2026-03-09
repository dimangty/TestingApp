# OpenCode Setup (Qwen / TestingTask)

Инструкция для связки: **OpenCode + Ollama + qwen3-coder:30b**.

## 1. Базовые требования

1. Установить OpenCode.
2. Установить Ollama и запустить сервис.
3. Скачать модель:

```bash
ollama pull qwen3-coder:30b
```

4. Проверить, что модель доступна:

```bash
ollama list
```

## 2. Настройка OpenCode

1. В OpenCode выбрать провайдера **Ollama**.
2. Выбрать модель **qwen3-coder:30b**.
3. Использовать **Build mode** для задач с реальными правками файлов.

## 3. Куда ставить skills

В текущей рабочей конфигурации skills должны лежать в:

- `~/.opencode/skills`
- (дополнительно) `~/.codex/skills`

Папка `.opencode/skills` внутри репозитория сама по себе не является основной точкой загрузки для этой конфигурации.  
Репозиторий хранит исходники skills в `./skills`, затем они синхронизируются в home-директории.

## 4. Синхронизация skills из репозитория

Из корня проекта:

```bash
mkdir -p "$HOME/.opencode/skills" "$HOME/.codex/skills"
rsync -a --delete skills/ "$HOME/.opencode/skills/"
rsync -a --delete skills/ "$HOME/.codex/skills/"
```

Проверка:

```bash
ls -la "$HOME/.opencode/skills"
ls -la "$HOME/.codex/skills"
```

## 5. Рекомендуемый способ работы с qwen3-coder:30b

Для этой модели надежнее использовать command-only fallback (одна команда), если агент начинает:

- зацикливаться на “load skill”;
- печатать псевдо-теги вида `<function=...>` или `<tool_call>`;
- вызывать несуществующие инструменты (`skill`, `todolist`, `todowrite`).

### Готовые команды генерации тестов

XCTest (любой presenter):

```bash
bash scripts/opencode_create_presenter_tests.sh . <PresenterName> [output_file]
```

SwiftTesting (любой presenter):

```bash
bash scripts/opencode_create_presenter_swifttesting_tests.sh . <PresenterName> [output_file]
```

Примеры:

```bash
bash scripts/opencode_create_presenter_tests.sh . NewsPresenter
bash scripts/opencode_create_presenter_swifttesting_tests.sh . SignUpScreenPresenter
```

## 6. SwiftyMocky

Подробная настройка вынесена в:

- `SWIFTYMOCKY_SETUP.md`

Основная команда регенерации моков:

```bash
mint run SwiftyMocky generate
```

