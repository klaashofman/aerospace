# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A single-file [AeroSpace](https://nikitabobko.github.io/AeroSpace/guide) (macOS tiling window manager) configuration: `.aerospace.toml`. It is a port of the i3 default config (`https://github.com/i3/i3/blob/next/etc/config`), so the goal is i3 behavioral parity. There is no build, lint, or test tooling and no git repository.

## Working with the config

- Apply changes by pressing `alt-shift-c` (bound to `reload-config`) or running `aerospace reload-config`.
- AeroSpace looks for `~/.aerospace.toml` (or `~/.config/aerospace/aerospace.toml`); this file must be copied or symlinked there to take effect.
- `config-version = 2` is required. Use the AeroSpace docs for the syntax of this version: `https://nikitabobko.github.io/AeroSpace/commands` and `https://nikitabobko.github.io/AeroSpace/guide`.

## Structure and non-obvious choices

- **Modes:** `[mode.main.binding]` holds all everyday bindings; `[mode.resize.binding]` is entered with `alt-r` and left with `enter`/`esc`, mirroring i3's resize mode.
- **Non-standard directional keys:** focus/move use `j k l ;` (`left down up right`) as in i3's default layout, not vim's `h j k l`. `alt-h` is `split horizontal`, not a focus key. `alt-v` opens a new VS Code window (`open -n ... --args --new-window` on the copy in `~/Applications`; other copies exist in `~/Downloads`, so the path is explicit; without `--new-window` VS Code just focuses the running instance), so `split vertical` currently has no binding. In resize mode, however, `h j k l` are used.
- **Normalizations are disabled** (`enable-normalization-flatten-containers` and `...-opposite-orientation-for-nested-containers` are `false`). This is deliberate: i3's tree model permits nested single-child and same-orientation containers, and `split` depends on them. If normalizations are enabled, replace `split` with `join-with`.
- **Default layout:** `default-root-container-layout = 'tiles'` with `default-root-container-orientation = 'horizontal'` (windows side by side, as in i3). It only applies to workspaces that are empty when a window arrives; existing workspaces keep their current layout.
- **i3 layout mapping:** `alt-s` is `v_accordion` (i3 stacking), `alt-w` is `h_accordion` (i3 tabbed), `alt-e` is `tiles horizontal vertical` (i3 toggle split). `alt-shift-space` toggles floating.
- **Workspaces** 1–10 are bound to `alt-1`…`alt-0` (`alt-0` maps to workspace 10) with `alt-shift-<n>` for moving windows. `persistent-workspaces = []` reproduces i3's phantom workspaces.
- `alt-enter` opens a plain new Terminal.app window through `osascript`; change it if using another terminal.
- `alt-n` runs `new-terminal.sh` (referenced by absolute path in the config, so update the path if the repo moves). It reads the tty of the focused Terminal.app or iTerm2 window via AppleScript, finds the cwd of the foreground process on that tty, and opens a new Terminal.app window there (`open -a Terminal <dir>`). For any other focused app it falls back to a plain new window. `DRY_RUN=1 ./new-terminal.sh` prints the detected directory without opening anything. AeroSpace may need macOS Automation permission to control Terminal/iTerm2.
- `alt-left/down/up/right` duplicate the `j k l ;` focus bindings (same wrap-around behavior), and `alt-shift-left/down/up/right` duplicate the `alt-shift-j k l ;` move bindings.
- `alt-pageUp`/`alt-pageDown` send the focused window to the Dell / built-in monitor (matched by name, like the workspace assignments) and focus follows it.
- `alt-c` opens a new Google Chrome window (`--new-window`); `reload-config` is `alt-shift-c`.
- `alt-q` is `close` (i3's `kill`, but on `alt-q` rather than i3's `alt-shift-q`). It closes the focused window like its close button, so an app can still prompt to save.
- `focus parent`/`focus child` and `focus toggle_tiling_floating` have no AeroSpace equivalent, so they are intentionally left out (commented in the file).
