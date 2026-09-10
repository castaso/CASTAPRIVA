# Syncing CASTAPRIVA with upstream Open WebUI

This repo keeps **two branches** to stay clean and conflict-free.

## Branch model

- `main` — **clean mirror** of `open-webui/open-webui@main`. No CASTAPRIVA edits ever.
- `rebrand/castapriva` — **overlay** branch: `main` + CASTAPRIVA rebrand (6 files).

Upstream → `main` → `rebrand/castapriva` (always forward).

## Initial setup (already done for this fork)

```bash
git remote add upstream https://github.com/open-webui/open-webui.git
git fetch upstream --prune
git checkout main
git reset --hard upstream/main
git push -f origin main
git checkout -b rebrand/castapriva
# apply rebrand patch (env.py, package.json, pyproject.toml, LICENSE, README, static/BRANDING.md, .env.example)
git push -u origin rebrand/castapriva
```

## Routine sync (maintainer, weekly or on upstream release)

```bash
./scripts/sync-upstream.sh
# or manually:
git fetch upstream --prune
git checkout main
git pull --ff-only upstream main
git push origin main

git checkout rebrand/castapriva
git merge main   # or git rebase main for linear history
# resolve conflicts — only the 6 overlay files should ever conflict
git push origin rebrand/castapriva
```

### Rebase vs merge

- `merge` — preserves exact overlay commit, adds a merge commit. Safer for shared `rebrand/castapriva`.
- `rebase` — rewrites overlay on top of new `main`, linear history. Requires `git push --force-with-lease`.

Pick one and stick to it.

## Why this stays conflict-free

Rebrand touches only:

1. `backend/open_webui/env.py` (WEBUI_NAME default + comment)
2. `package.json` (name)
3. `pyproject.toml` (name + script alias)
4. `LICENSE` (fork grant)
5. `README.md` (CASTAPRIVA docs)
6. `static/BRANDING.md` (this fork's notes)
7. `.env.example` (WEBUI_NAME example)
8. `SYNC.md` / `scripts/sync-upstream.sh` (fork tooling, never in upstream)

No bulk `s/Open WebUI/CASTAPRIVA/g` across `src/`, `CHANGELOG.md`, or docs — upstream changes there never conflict. Visible name in the UI is controlled at runtime by `WEBUI_NAME`, not by editing every string.

## Porting the rebrand to a new clone

```bash
git clone https://github.com/castaso/CASTAPRIVA.git
cd CASTAPRIVA
git remote add upstream https://github.com/open-webui/open-webui.git
git fetch upstream
git checkout main
git checkout rebrand/castapriva
WEBUI_NAME=CASTAPRIVA npm run dev
```

## Tags & releases

Upstream tags are fetched (`git fetch upstream --tags`) but not pushed to `origin` by default.
To publish CASTAPRIVA releases: tag from `rebrand/castapriva`:

```bash
git checkout rebrand/castapriva
git tag -a castapriva-v0.11.3 -m "CASTAPRIVA v0.11.3 (upstream 0.11.3)"
git push origin castapriva-v0.11.3
```

## Troubleshooting

- **Merge conflict in `env.py`**: upstream changed WEBUI_NAME logic. Keep CASTAPRIVA's `WEBUI_NAME = os.getenv('WEBUI_NAME', 'CASTAPRIVA')` without the `+ ' (Open WebUI)'` suffix, and keep the original fallback comment if upstream added validation.
- **`main` diverged**: never commit to `main`. Reset: `git checkout main && git reset --hard upstream/main && git push -f origin main`.
- **GitHub shows fork=false**: This repo was created empty and wired to upstream via `git remote add upstream`; GitHub's fork network badge requires forking via `gh repo fork`. Functionally identical — sync works the same. To get the badge, delete the repo and `gh repo fork open-webui/open-webui --fork-name CASTAPRIVA`.

## Attribution

Upstream: https://github.com/open-webui/open-webui  
Fork: https://github.com/castaso/CASTAPRIVA  
See `LICENSE` and `LICENSE_HISTORY`.
