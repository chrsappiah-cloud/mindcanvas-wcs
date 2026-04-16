#!/bin/bash
# Script to remove duplicate Info.plist files from Swift package sources
# and ensure only the Xcode project references Info.plist

# Path to the Xcode project's Info.plist
PROJECT_PLIST="/Applications/mindcanvas/mindcanvas/Info.plist"

# Path to the Swift package sources
PACKAGE_SOURCES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/mindcanvas/Sources"

# Find and remove any Info.plist in the Swift package sources
find "$PACKAGE_SOURCES" -name "Info.plist" -type f -exec rm -v {} \;

echo "Ensured only Xcode project references Info.plist: $PROJECT_PLIST"
echo "If you see the error again, check your Xcode target's Build Phases and Build Settings for duplicate references."
