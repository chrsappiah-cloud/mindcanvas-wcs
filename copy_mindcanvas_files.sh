#!/bin/bash
# Script to copy MindCanvas SwiftUI source files into an Xcode project directory
# Usage: ./copy_mindcanvas_files.sh /path/to/your/xcode/project

SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/mindcanvas/Sources"
DEST_DIR="$1"

if [ -z "$DEST_DIR" ]; then
  echo "Usage: $0 /path/to/your/xcode/project"
  exit 1
fi

cp "$SRC_DIR"/MindCanvasApp.swift "$DEST_DIR"/
cp "$SRC_DIR"/HomeDashboardView.swift "$DEST_DIR"/
echo "Files copied to $DEST_DIR."
echo "In Xcode, right-click your group and select 'Add Files to ...' to reference them."
