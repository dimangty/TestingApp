#!/bin/bash

# SwiftyMocky Mock Generation Script
# This script runs SwiftyMocky to generate mocks before building tests.

set -euo pipefail

cd "$SRCROOT"

readonly generated_mocks_path="TestingTaskTests/Mocks/GeneratedMocks.swift"
export PATH="$HOME/.mint/bin:/opt/homebrew/bin:/usr/local/bin:$PATH"

if [[ -x "$HOME/.mint/bin/swiftymocky" ]]; then
    swiftymocky_cmd="$HOME/.mint/bin/swiftymocky"
elif command -v swiftymocky >/dev/null 2>&1; then
    swiftymocky_cmd="$(command -v swiftymocky)"
else
    if [[ -f "$generated_mocks_path" ]]; then
        echo "⚠️  SwiftyMocky CLI not found. Skipping generation and using committed mocks."
        exit 0
    fi
    echo "❌ SwiftyMocky CLI not found. Install with: mint install MakeAWishFoundation/SwiftyMocky"
    exit 1
fi

if ! command -v sourcery >/dev/null 2>&1; then
    if [[ -f "$generated_mocks_path" ]]; then
        echo "⚠️  Sourcery not found. Skipping generation and using committed mocks."
        exit 0
    fi
    echo "❌ Sourcery CLI not found. Install with: brew install sourcery"
    exit 1
fi

echo "🔨 Generating mocks with SwiftyMocky..."
"$swiftymocky_cmd" generate
echo "✅ Mock generation complete!"
