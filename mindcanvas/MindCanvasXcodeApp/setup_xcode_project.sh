#!/bin/bash
# Automated Xcode project setup for MindCanvasXcodeApp
set -e

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
SRC_DIR="$PROJECT_DIR/Sources"
RES_DIR="$PROJECT_DIR/Resources"
ROOT_DIR="$(dirname "$PROJECT_DIR")"

# 1. Create Xcode project if not exists
echo "Checking for MindCanvasXcodeApp.xcodeproj..."
if [ ! -d "$PROJECT_DIR/MindCanvasXcodeApp.xcodeproj" ]; then
  echo "Creating Xcode project..."
  xcodebuild -project MindCanvasXcodeApp.xcodeproj || true
  # Note: Actual project creation is manual or via Xcode CLI tools
fi

# 2. Copy sources and resources
echo "Copying sources and resources..."
cp -R "$SRC_DIR"/*.swift "$PROJECT_DIR/"
cp -R "$RES_DIR"/* "$PROJECT_DIR/"

# 3. Reminder for manual steps
echo "\nManual steps required:"
echo "- Open Xcode and add all .swift files and resources to the main app target."
echo "- Set Info.plist and LaunchScreen.storyboard in project settings."
echo "- Add CloudKit capability if needed."
echo "- Build and run the app."
