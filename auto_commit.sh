#!/data/data/com.termux/files/usr/bin/bash

BRANCH="main"

echo "Starting auto sync..."

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Not git repo"
  exit 1
fi

REPO=$(git remote get-url origin)

echo "Repo: $REPO"

while true; do
  echo "Checking changes..."

  git add -A

  if ! git diff --cached --quiet; then
    echo "Changes found"

    git commit -m "auto sync $(date +%s)"

    echo "Pulling latest..."

    git pull --rebase origin $BRANCH

    echo "Pushing..."

    git push origin $BRANCH

    echo "Sync complete"
  else
    echo "No changes"
  fi

  sleep 3
done
