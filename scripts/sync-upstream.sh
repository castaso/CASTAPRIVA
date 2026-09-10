#!/usr/bin/env bash
# Sync CASTAPRIVA fork with upstream open-webui/open-webui
# Keeps main clean (mirror) and replays rebrand/castapriva on top.
set -euo pipefail

UPSTREAM="${1:-https://github.com/open-webui/open-webui.git}"
REBRAND_BRANCH="rebrand/castapriva"
CLEAN_BRANCH="main"

if ! git rev-parse --git-dir >/dev/null 2>&1; then
  echo "Run from repo root."
  exit 1
fi

if ! git remote get-url upstream >/dev/null 2>&1; then
  echo "Adding upstream -> $UPSTREAM"
  git remote add upstream "$UPSTREAM"
fi

echo "Fetching upstream..."
git fetch upstream --prune

echo "=== 1) Update $CLEAN_BRANCH (clean mirror) ==="
git checkout "$CLEAN_BRANCH"
# ff-only to guarantee no local rebrand commits on main
git pull --ff-only upstream main || {
  echo "!! $CLEAN_BRANCH has diverged (should never happen). Resetting to upstream/main"
  git reset --hard upstream/main
}
git push origin "$CLEAN_BRANCH"

echo "=== 2) Update $REBRAND_BRANCH (overlay) ==="
git checkout "$REBRAND_BRANCH"
echo "Merging $CLEAN_BRANCH into $REBRAND_BRANCH..."
if ! git merge "$CLEAN_BRANCH" --no-edit; then
  echo ""
  echo "Conflicts in overlay files — resolve them, keeping CASTAPRIVA branding:"
  echo "  - backend/open_webui/env.py  (keep WEBUI_NAME='CASTAPRIVA' without suffix)"
  echo "  - package.json / pyproject.toml"
  echo "  - LICENSE / README.md / static/BRANDING.md"
  echo "Then: git add <files> && git commit && git push origin $REBRAND_BRANCH"
  exit 1
fi
git push origin "$REBRAND_BRANCH"

echo "Done. $CLEAN_BRANCH mirrors upstream; $REBRAND_BRANCH has CASTAPRIVA overlay."
echo "Tip: use 'git rebase $CLEAN_BRANCH' instead of merge if you prefer linear history."
