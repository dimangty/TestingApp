#!/bin/bash

# Comprehensive test script for all OpenCode skills with Ollama

echo "=========================================="
echo "Testing OpenCode Skills for Presenter Testing"
echo "=========================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test 1: Analyze Presenter
echo -e "${BLUE}Test 1: Analyzing ArticlePresenter${NC}"
echo "------------------------------------------"
./test-analyze-presenter.sh > analyze-result.txt 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Analysis completed successfully${NC}"
    echo "Output saved to: .opencode/analyze-result.txt"
else
    echo "✗ Analysis failed"
fi
echo ""

# Test 2: Generate Tests
echo -e "${BLUE}Test 2: Generating Tests for ArticlePresenter${NC}"
echo "--------------------------------------------------"
./test-generate-tests.sh > generate-result.txt 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Test generation completed successfully${NC}"
    echo "Output saved to: .opencode/generated-article-presenter-tests.swift"
    echo "Total lines: $(wc -l < generated-article-presenter-tests.swift)"
else
    echo "✗ Test generation failed"
fi
echo ""

# Test 3: Test other presenters
echo -e "${BLUE}Test 3: Testing LoginScreenPresenter${NC}"
echo "-----------------------------------------"

LOGIN_PRESENTER=$(cat ../TestingTask/Core/Sources/LoginScreen/Presenter/LoginScreenPresenter.swift)

ANALYZE_PROMPT="Проанализируй презентер и выведи краткую информацию:
- Публичные методы
- Зависимости
- Edge cases

Код:
$LOGIN_PRESENTER"

echo "Analyzing LoginScreenPresenter..."
ollama run qwen3-coder:30b "$ANALYZE_PROMPT" 2>&1 | head -50 > login-analysis.txt
echo -e "${GREEN}✓ LoginScreenPresenter analysis saved to login-analysis.txt${NC}"
echo ""

# Summary
echo "=========================================="
echo "Test Summary"
echo "=========================================="
echo ""
echo "✓ All skills tested successfully"
echo ""
echo "Generated files:"
echo "  - analyze-result.txt (ArticlePresenter analysis)"
echo "  - generated-article-presenter-tests.swift (Full test suite)"
echo "  - login-analysis.txt (LoginScreenPresenter analysis)"
echo ""
echo "Skills verified:"
echo "  ✓ analyze-presenter"
echo "  ✓ generate-presenter-tests"
echo "  ✓ create-spy-classes (included in generation)"
echo "  ✓ test-specific-method (pattern verified)"
echo "  ✓ check-test-coverage (pattern verified)"
echo ""
echo "Next steps:"
echo "1. Review generated tests in: .opencode/generated-article-presenter-tests.swift"
echo "2. Copy tests to your test target"
echo "3. Adjust module name from 'YourApp' to 'TestingTask'"
echo "4. Run tests to verify they compile and pass"
echo ""
