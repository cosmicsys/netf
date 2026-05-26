#!/data/data/com.termux/files/usr/bin/bash

while true; do
  git add -A

  if ! git diff --cached --quiet; then
    git commit -m "auto sync $(date +%s)"
    git push
  fi

  sleep 3
done
