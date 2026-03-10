#!/bin/bash

# Test script for analyze-presenter skill using Ollama directly

PRESENTER_CONTENT=$(cat TestingTask/Core/Sources/ArticleScreen/Presenter/ArticlePresenter.swift)

PROMPT="Проанализируй презентер и выведи детальную информацию для написания тестов.

Код презентера:
$PRESENTER_CONTENT

Выведи:

## 1. Публичные методы (ViewOutput)
Список всех публичных методов с сигнатурами

## 2. Зависимости (@Injected)
Все @Injected зависимости с типами

## 3. Приватные методы и свойства
Все приватные методы и свойства

## 4. Протоколы
- View protocol
- Router protocol

## 5. Пути выполнения
Все возможные пути выполнения (success/failure branches)

## 6. Edge cases для тестирования
- Empty/nil values
- Boundary conditions
- Multiple calls
- State transitions

## 7. Необходимые Spy классы
Список Spy классов, которые нужно создать

## 8. Методы View протокола
Какие методы view вызываются из презентера

## 9. Методы Router протокола
Какие методы router вызываются из презентера

## 10. Async операции
Все async операции и completion handlers

Формат ответа должен быть структурированным и готовым для использования при написании тестов."

echo "Testing analyze-presenter skill with ArticlePresenter..."
echo "=================================================="
echo ""

ollama run qwen3-coder:30b "$PROMPT"
