#!/data/data/com.termux/files/usr/bin/bash

BRANCH="main"

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Not git repo"
  exit 1
fi

while true; do
  git add -A

  if ! git diff --cached --quiet; then
    git commit -m "auto sync $(date +%s)"

    git pull --rebase origin $BRANCH

    git push origin $BRANCH
  fi

  sleep 3
done
