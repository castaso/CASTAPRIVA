# CASTAPRIVA Branding

This distribution is **CASTAPRIVA** — a rebranded fork of
[Open WebUI](https://github.com/open-webui/open-webui) by CASTASOFT.

## Visible identity

- **App name:** `CASTAPRIVA` (env `WEBUI_NAME`, default on `rebrand/castapriva` branch)
- **Package names:** `castapriva` (`package.json`, `pyproject.toml`); alias `open-webui` preserved for CLI compat
- **Favicon / splash:** `static/favicon.png`, `static/splash.png` — replace these two files to rebrand visually; `WEBUI_FAVICON_URL` env can also point elsewhere
- **PWA manifest / OpenSearch:** derived at runtime from `WEBUI_NAME` in `backend/open_webui/main.py`

## What changed vs upstream

Minimal overlay on `rebrand/castapriva` only (see `README.md` table):

- `backend/open_webui/env.py` — default `WEBUI_NAME=CASTAPRIVA`, no forced ` (Open WebUI)` suffix
- `package.json` / `pyproject.toml` — package name
- `LICENSE` — added explicit permission to replace Open WebUI branding with CASTAPRIVA branding while preserving attribution (upstream license otherwise required keeping "Open WebUI" visible)
- `README.md` — CASTAPRIVA title, badges, and sync instructions
- This file

Upstream branding assets, comments, and `CHANGELOG.md` are intentionally **not** bulk-replaced — that keeps `main` clean and merges conflict-free.

## License note

`LICENSE` in this fork grants CASTAPRIVA permission to use its own name/logo.
Attribution to Open WebUI is retained in `LICENSE`, `LICENSE_HISTORY`, and `README.md`.
See also: https://docs.openwebui.com/license

## Rebranding further

- Text: `WEBUI_NAME=YourName` env var (no code change)
- Logo: drop new `favicon.png` / `splash.png` into `static/` and rebuild, or set `WEBUI_FAVICON_URL`
- Advanced: edit `backend/open_webui/env.py` and `static/manifest.json` if needed (still small diff)

Do not commit rebrand changes to `main` — keep `main` as an exact mirror of upstream for easy sync. See `SYNC.md`.
