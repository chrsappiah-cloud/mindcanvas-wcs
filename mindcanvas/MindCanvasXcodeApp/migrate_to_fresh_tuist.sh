#!/bin/bash
# Script to migrate MindCanvasXcodeApp sources/resources into a fresh Tuist project structure
set -e

# Set working directory to the script location
cd "$(dirname "$0")"

# 1. Create a new directory for the fresh Tuist project
NEW_PROJECT_DIR="../MindCanvasXcodeApp_Tuist"
if [ -d "$NEW_PROJECT_DIR" ]; then
  echo "Removing existing $NEW_PROJECT_DIR..."
  rm -rf "$NEW_PROJECT_DIR"
fi
mkdir "$NEW_PROJECT_DIR"
cd "$NEW_PROJECT_DIR"

echo "Initializing new Tuist project..."
tuist init

# 2. Copy sources and resources
echo "Copying sources and resources..."
mkdir -p Sources/MindCanvasXcodeApp
mkdir -p Resources/MindCanvasXcodeApp
cp ../../mindcanvas/MindCanvasXcodeApp/Sources/*.swift Sources/MindCanvasXcodeApp/
cp ../../mindcanvas/MindCanvasXcodeApp/Resources/* Resources/MindCanvasXcodeApp/

# 3. Reminder to update Project.swift
cat <<EOM

Migration complete!
- Update the generated Project.swift to include all your sources and resources for the MindCanvasXcodeApp target.
- Then run: tuist generate
- Open the generated Xcode project and build/run your app.
EOM
