#!/bin/bash
# Copyright (c) 2026 World Class Scholars, led by Dr. Christopher Appiah-Thompson. All rights reserved.
# Script to prepend copyright notice to all text files in the repository

NOTICE="# Copyright (c) 2026 World Class Scholars, led by Dr. Christopher Appiah-Thompson. All rights reserved."

# List of file extensions to include (add more as needed)
exts="js ts py sh md json html css swift plist yml yaml jsx tsx mjs c cpp h hpp java cs txt xml conf ini env scss less vue php rb go rs dart kt m kts sql toml cfg properties gradle make mk bat zsh bash csv tsv tex bib rst mdx vue"

# Find all files with the above extensions, excluding .git, node_modules, build, .build, cache, .cache, dist, .next, and binary files
find . \
  \( -path "*/.git*" -o -path "*/node_modules*" -o -path "*/build*" -o -path "*/.build*" -o -path "*/cache*" -o -path "*/.cache*" -o -path "*/dist*" -o -path "*/.next*" \) -prune -false \
  -o \( $(for ext in $exts; do echo -n "-iname '*.$ext' -o "; done | sed 's/ -o $//') \) \
  -type f \
  -print | while read file; do
    # Skip binary files (simple check)
    if file "$file" | grep -qE 'text|script|source|XML|JSON|ASCII|Unicode|UTF-8'; then
      # Check if notice already present
      if ! grep -q "World Class Scholars, led by Dr. Christopher Appiah-Thompson" "$file"; then
        echo "Updating $file"
        tmpfile=$(mktemp)
        echo -e "$NOTICE\n" | cat - "$file" > "$tmpfile" && mv "$tmpfile" "$file"
      fi
    fi
  done

echo "Done."
