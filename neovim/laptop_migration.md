# Neovim Laptop Migration

How to move a fully-working Neovim "installation" to a new laptop **without
re-fetching plugins/LSP servers from GitHub**.

This works cleanly when the new laptop is the **same architecture** (Apple
Silicon macOS). The compiled Mason binaries and treesitter parsers run as-is.
On a different architecture (Intel macOS, Linux), the config and plugin source
still transfer, but Mason binaries and treesitter parsers must be rebuilt.

## Setup overview

- **Config** (`~/.config/nvim`) is just symlinks into `~/github/prefs/neovim`,
  a git repo pushed to `github-craigrosie:craigrosie/prefs`.
- **Plugins**: lazy.nvim, ~89 plugins in `~/.local/share/nvim/lazy`,
  version-pinned by `lazy-lock.json`.
- **LSP servers / formatters / linters**: Mason, in `~/.local/share/nvim/mason`
  (compiled binaries).
- **Treesitter parsers**: compiled `.so` files under `~/.local/share/nvim`.
- **nvim binary**: Homebrew (v0.12.3 at time of writing).

The whole `~/.local/share/nvim` is ~1.5 GB and is what you transfer to avoid
re-fetching from GitHub.

## On your current laptop

**1. Commit & push your config changes** (config lives in the `prefs` repo):

```bash
cd ~/github/prefs
git add neovim
git commit -m "Snapshot neovim config before laptop migration"
git push
```

Alternatively, just copy the whole `~/github/prefs` directory to the new
machine — but git is simpler since the repo already has a remote.

**2. Package the runtime data** (plugins + Mason binaries + treesitter
parsers), excluding large logs:

```bash
tar -czf ~/nvim-share.tar.gz \
  -C ~/.local/share \
  --exclude='nvim/*.log' \
  --exclude='nvim/**/*.log' \
  nvim
```

This ~1.5 GB blob contains `lazy/` (all plugins), `mason/` (LSP
servers/formatters), and the compiled treesitter parsers.

Copy `~/nvim-share.tar.gz` to the new laptop (AirDrop, scp, etc.).

### If you can't transfer the file in one go

Split the archive into smaller chunks (e.g. 200 MB each):

```bash
split -b 200m ~/nvim-share.tar.gz ~/nvim-share.tar.gz.part-
```

This produces files named `nvim-share.tar.gz.part-aa`, `nvim-share.tar.gz.part-ab`, etc.
Transfer each part individually (email, Slack, cloud storage upload, whatever your limit allows).

On the new laptop, reassemble before extracting:

```bash
cat ~/nvim-share.tar.gz.part-* > ~/nvim-share.tar.gz
```

Then continue from step 5 as normal. You can verify the reassembled file isn't corrupt with:

```bash
gzip -t ~/nvim-share.tar.gz && echo "OK"
```

## On the new laptop

**3. Install the same neovim version:**

```bash
brew install neovim
```

**4. Restore your config** via the prefs repo (recreating the same symlinks):

```bash
git clone git@github-craigrosie:craigrosie/prefs.git ~/github/prefs
mkdir -p ~/.config/nvim
ln -s ~/github/prefs/neovim/init.lua ~/.config/nvim/init.lua
ln -s ~/github/prefs/neovim/lua      ~/.config/nvim/lua
cp ~/github/prefs/neovim/lazy-lock.json ~/.config/nvim/lazy-lock.json
```

(`lazy-lock.json` currently sits in `~/.config/nvim/` and isn't a symlink, so
copy it explicitly — or move it into the repo.)

**5. Restore the runtime data:**

```bash
mkdir -p ~/.local/share
tar -xzf ~/nvim-share.tar.gz -C ~/.local/share
```

**6. Launch nvim.** Because both `lazy/` and `lazy-lock.json` are present and
pinned, lazy.nvim won't download anything. Mason binaries are already in place.
It should come up fully working, offline.

## Notes

- **PATH for Mason tools**: Mason binaries live in
  `~/.local/share/nvim/mason/bin`. They're invoked by nvim internally, so you
  generally don't need them on your shell `PATH` — but if any config references
  them globally, add that dir to PATH.
- **Verify offline**: After restoring, confirm nothing re-downloads by
  launching nvim with no network, or running `:Lazy` and `:Mason` to see
  everything marked installed.
- **Optional personal state** (not required for a working install):
  `~/.local/share/nvim/dirsession/`, `smart_open.sqlite3`, and
  `telescope_history` (session/frecency history). The tarball above excludes
  only logs, so these are already included.
