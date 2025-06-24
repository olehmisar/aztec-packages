#!/bin/bash

# === Function to find the closest package.json upwards ===
find_package_json() {
  dir=$(dirname "$1")
  while [[ "$dir" != "/" ]]; do
    if [[ -f "$dir/package.json" ]]; then
      echo "$dir/package.json"
      return
    fi
    dir=$(dirname "$dir")  # Move up one dir
  done
  echo ""  # None found
}

# === Loop through tracked .ts files only ===
git ls-files '*.ts' | while read -r file; do
  # Check if file uses Buffer and ain't got the import yet
  if grep -q '\bBuffer\b' "$file" && ! grep -q 'import\s\+{\s*Buffer\s*}\s\+from\s\+["'\'']buffer["'\'']' "$file"; then
    echo "Injectin Buffer import in: $file"

    tmpfile=$(mktemp)  # Create temp file to hold modified content
    first_line=$(head -n 1 "$file")

    if [[ $first_line == \#!* ]]; then
      # Keep shebang (e.g. #!/usr/bin/env node) at the top
      echo "$first_line" > "$tmpfile"
      echo 'import { Buffer } from "buffer";' >> "$tmpfile"
      tail -n +2 "$file" >> "$tmpfile"
    else
      # No shebang, just inject import at the top
      echo 'import { Buffer } from "buffer";' > "$tmpfile"
      cat "$file" >> "$tmpfile"
    fi

    # Replace original file with updated content
    mv "$tmpfile" "$file"

    # === Handle dependency injection into closest package.json ===
    pkg_json=$(find_package_json "$file")
    if [[ -n "$pkg_json" ]]; then
      # Check if buffer is already in dependencies
      if ! grep -q '"buffer"\s*:' "$pkg_json"; then
        echo "Addin buffer@^6.0.3 to $pkg_json"
        tmp_pkg=$(mktemp)
        jq '.dependencies["buffer"] = "^6.0.3"' "$pkg_json" > "$tmp_pkg" && mv "$tmp_pkg" "$pkg_json"
      fi
    fi
  fi
done
