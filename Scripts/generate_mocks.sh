#!/bin/bash

# SwiftyMocky Mock Generation Script
# This script runs SwiftyMocky to generate mocks before building tests

# Exit on error
set -e

# Navigate to project root
cd "$SRCROOT"

# Check if swiftymocky is installed
if ! command -v ~/.mint/bin/swiftymocky &> /dev/null; then
    echo "⚠️  SwiftyMocky CLI not found. Please install it with: mint install MakeAWishFoundation/SwiftyMocky"
    exit 1
fi

# Generate mocks
echo "🔨 Generating mocks with SwiftyMocky..."
~/.mint/bin/swiftymocky generate

echo "✅ Mock generation complete!"
