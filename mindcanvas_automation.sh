#!/bin/bash
# Automate GitHub push, add tests, and update CI/CD for MindCanvas
# Usage: ./mindcanvas_automation.sh <github-username> <repo-name>

set -e

GITHUB_USER="$1"
REPO_NAME="$2"
REPO_URL="https://github.com/$GITHUB_USER/$REPO_NAME.git"

# 1. Initialize git and push to GitHub
if [ ! -d .git ]; then
  git init
fi
git remote remove origin 2>/dev/null || true
git remote add origin "$REPO_URL"
git branch -M main
git add .
git commit -m "Initial MindCanvas MVP commit" || true
git push -u origin main

# 2. Add a basic Swift test if not present
TEST_DIR="mindcanvas/Tests"
TEST_FILE="$TEST_DIR/MindCanvasTests.swift"
if [ ! -f "$TEST_FILE" ]; then
  mkdir -p "$TEST_DIR"
  cat > "$TEST_FILE" <<EOL
import XCTest
@testable import MindCanvas

final class MindCanvasTests: XCTestCase {
    func testExample() {
        XCTAssertTrue(true)
    }
}
EOL
  git add "$TEST_FILE"
  git commit -m "Add basic unit test"
  git push
fi

# 3. Update GitHub Actions workflow to run tests
WORKFLOW_FILE=".github/workflows/ios-ci.yml"
if ! grep -q 'xcodebuild test' "$WORKFLOW_FILE"; then
  sed -i '' '/xcodebuild -scheme/a\
    - name: Run tests with xcodebuild\
      run: |\
        xcodebuild test -scheme "mindcanvas" -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 15,OS=latest'\
' "$WORKFLOW_FILE"
  git add "$WORKFLOW_FILE"
  git commit -m "Update CI to run tests"
  git push
fi

echo "All steps automated: repo pushed, tests added, CI/CD updated."
