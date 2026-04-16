#!/bin/bash
# Script to generate an Xcode project from the MindCanvas Swift package
# Usage: ./generate_mindcanvas_xcodeproj.sh

cd "$(dirname "$0")/mindcanvas" || exit 1
swift package generate-xcodeproj

if [ $? -eq 0 ]; then
  echo "MindCanvas.xcodeproj generated successfully. Open it in Xcode to continue development."
else
  echo "Failed to generate Xcode project. Please check for errors in your Package.swift or Swift files."
fi
