# konfig todo

## done

- **BANNER env fossil leak** — fixed 2026-06-04.
  - Makefile: `ifeq ($(origin VAR),environment)` guard on `APP`, `MAIN`, `BANNER`. Env-sourced values get reset to defaults; repo Makefile assignments (origin=file) still win. `KONFIG` left alone — users may legitimately export it.
  - bashrc: `unset BANNER APP MAIN KONFIG` after aliases + banner consumed, so child shells / tmux / claude can't inherit.

## bugs

(none open)
