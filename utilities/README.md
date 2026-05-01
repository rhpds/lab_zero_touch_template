# utilities

Local development scripts for the lab zero-touch template.
All scripts work from any directory — they resolve the repository root automatically.

## Quick start

```bash
utilities/lab-build   # Build Antora site + stage nookbag UI into ./www/
utilities/lab-serve   # Start HTTP preview server on http://localhost:8080
```

Open **http://localhost:8080/** in your browser.

Iterative cycle:

```bash
# edit a .adoc page or ui-config.yml, then:
utilities/lab-build
# hard-refresh the browser (Ctrl+Shift+R)
```

To stop the preview server:

```bash
utilities/lab-stop
```

---

## Script reference

| Script | What it does | When to use |
|--------|-------------|-------------|
| `lab-build` | Runs the Antora container, stages nookbag UI, writes a local-preview `www/ui-config.yml` | Every time you change content, `ui-config.yml`, or `site.yml` |
| `lab-serve` | Starts `ubi9/httpd-24` container serving `./www` on port 8080 | After `lab-build` to open the preview |
| `lab-stop` | Removes the `showroom-httpd` container | To free port 8080 or after you are done |
| `lab-clean` | Deletes `./www/*` | To force a full clean rebuild |
| `lab-check-updates` | Checks GitHub for newer nookbag SPA and nookbag-bundle releases | Periodically, to keep the UI up to date |

---

## What `lab-build` does for local preview

`lab-build` produces a `./www/` tree that is safe to serve locally without a running cluster.
The source files (`ui-config.yml`, `site.yml`, `.adoc` pages) are **never modified**.

### Tab stripping

Tabs defined in `ui-config.yml` that use `type: terminal`, `type: double-terminal`,
`type: secondary-terminal`, or `port: 443` are **stripped from `www/ui-config.yml`** before the
server starts.

These tabs construct URLs like `https://localhost:443/tty1` at runtime.
On a deployed cluster that resolves to the showroom pod's wetty endpoint — it works fine.
Locally there is nothing on port 443, and Firefox reports "There is a problem with this site"
because the embedded iframe triggers a TLS failure.

**You do not need to comment out or remove terminal tabs from `ui-config.yml`.**
Keep them there for production deployments. `lab-build` strips them only in `www/` for local use.

The same stripping runs in the GitHub Pages workflow — see [GitHub Pages](#github-pages) below.

### `view_switcher` injection

When cluster-only tabs are stripped, `lab-build` also injects into `www/ui-config.yml`:

```yaml
view_switcher:
  enabled: true
  default_mode: instructions
```

This makes nookbag start in full-width Instructions mode (content panel fills the screen).
If your `ui-config.yml` already defines `view_switcher`, `lab-build` leaves it unchanged.

### `zero-touch-config.yml`

Nookbag always fetches both `./ui-config.yml` and `./zero-touch-config.yml` at startup.
On a deployed cluster, AgnosticD copies `zero-touch-config.yml` from the lab repo into `www/`
if it exists; otherwise only `ui-config.yml` is served (the second request 404s, which is fine).

For local preview, `lab-build` creates `www/zero-touch-config.yml` as a symlink to
`ui-config.yml` so both fetches succeed and DevTools stays clean.
If you ship a real `zero-touch-config.yml` in the repo root, it is copied into `www/` instead.

---

## Prerequisites

| Requirement | Notes |
|-------------|-------|
| `podman` or `docker` | `podman` is preferred and auto-detected. On RHEL/Fedora: `dnf install podman`. On macOS: [Podman Desktop](https://podman-desktop.io) or [Docker Desktop](https://www.docker.com/products/docker-desktop). |
| `python3` + `pyyaml` | Used by `lab-build` for tab stripping. Pre-installed on RHEL/Fedora. If missing, `lab-build` falls back to a plain copy (no stripping). |
| `wget` | Downloads the nookbag UI zip. Pre-installed on RHEL/Fedora. On macOS: `brew install wget`. |
| `unzip` | Extracts the nookbag UI zip. Pre-installed on most systems. |
| Port 8080 free | `lab-serve` binds `localhost:8080`. |
| `curl` | Used by `lab-check-updates`. Pre-installed on all platforms. |
| Linux/amd64 emulation | `lab-build` runs Antora with `--platform linux/amd64`. On Apple Silicon: enable Rosetta in Docker Desktop, or run `podman machine init --arch amd64`. |

---

## Tips

- **Nookbag zip is cached** at `/tmp/nookbag.zip`. If you see stale UI, delete it and rebuild:
  ```bash
  rm /tmp/nookbag.zip && utilities/lab-build
  ```
- **Antora bundle is cached** at `.cache/antora/`. Delete it to force a re-fetch after a version bump.
- **Check for updates** at any time:
  ```bash
  utilities/lab-check-updates
  ```
  It reports the pinned versions in `utilities/lab-build` and `site.yml` against the latest
  GitHub releases for nookbag and nookbag-bundle.

---

## GitHub Pages

The `.github/workflows/deploy-pages.yml` workflow runs `utilities/lab-build` on every push to
`main` and deploys `./www` to GitHub Pages.

Because `lab-build` is the same script used locally, GitHub Pages gets the **identical
tab-stripped, view_switcher-injected `ui-config.yml`** — no extra configuration needed.

To enable GitHub Pages for your lab repo:

1. Go to your repo → **Settings** → **Pages**
2. Under **Build and deployment**, set **Source** to **GitHub Actions**
3. Push to `main` — the workflow runs automatically

The deployed URL will be `https://<org>.github.io/<repo>/`.
