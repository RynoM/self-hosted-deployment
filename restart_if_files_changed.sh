#!/bin/bash
# Get the files that were changed in the last commit and check if any of the
# string arguments to the script are substrings of these filenames.
CHANGED_FILES=$(git diff --name-only HEAD HEAD~1)
for str in "$@"; do
  for file in $CHANGED_FILES; do
    if echo "$file" | grep -q "$str"; then
      docker compose restart "$str"
      break
    fi
  done
done
exit 0