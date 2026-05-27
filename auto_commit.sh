#!/data/data/com.termux/files/usr/bin/bash

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Not git repo"
  exit 1
fi

echo "Watching repo:"
git remote get-url origin

while true; do
  git add -A

  if ! git diff --cached --quiet; then
    git commit -m "auto sync $(date +%s)"
    git push
  fi

  sleep 3
done
