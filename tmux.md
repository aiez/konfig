# tmux.md — tmux, as konfig tunes it

Konfig's `tmux.conf` is small: C-Space prefix, mouse on, vi copy
mode, quiet status line at top. Each repo runs on a *private
socket*, so its tmux can't collide with any other session.

## start it

    make mux         # tmux -L $(APP) -f $(KONFIG)/tmux.conf, session $(APP)
    make claude      # 3-pane layout: shell | claude + shell

Re-running `make mux` re-attaches (`new-session -A`). Detach with
prefix d; the session keeps running.

## prefix = C-Space

Hold ctrl, tap space, release, then the key:

    C-Space |       split vertical   (panes side by side)
    C-Space -       split horizontal (panes stacked)
    C-Space d       detach
    C-Space C       new session (prompts for name)
    C-Space S       pick session from a tree
    C-Space z       zoom/unzoom current pane
    C-Space x       kill pane
    C-Space o       next pane (or just click — mouse is on)

Splits open in the *current pane's directory*.

## copy mode (vi keys)

    C-Space [       enter copy mode
    h j k l         move        /text  search
    v               start selection
    y               yank -> macOS clipboard (pbcopy), exits copy mode

Mouse drag also copies straight to the clipboard, without jumping
the view to the bottom.

## status line

Top of screen, muted grey; current window in steel blue bold.
No clocks, no powerline noise.

## per-repo overrides

Put `tmux.local.conf` next to the repo Makefile; sourced *last*
(silently skipped if missing), so it wins:

    # tmux.local.conf
    bind r source-file "#{config_files}" \; display "reloaded"

## sockets, in case of confusion

`-L name` = separate server per repo. `tmux ls` shows nothing?
You're asking the *default* server. Use:

    tmux -L luamine ls
