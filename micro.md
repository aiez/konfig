# micro.md — micro, as konfig tunes it

A simple, modern terminal editor with standard keys (Ctrl-s save,
Ctrl-c/x/v, Ctrl-z undo). Konfig ships catppuccin-mocha colors, a
richer lisp syntax, a python reformatter, and pane splits. Launched
isolated — your own `~/.config/micro` is untouched.

## start it

    m file           # alias inside `make sh`

The gist is flat (no dirs) but micro needs a config *directory*, so
`make sh` builds one at `~/.config/konfig/micro` and symlinks the flat
repo files into it (`settings.json`, `bindings.json`,
`syntax/lisp.yaml`, `colorschemes/catppuccin-mocha.micro`). Plugins
micro downloads land there too — never your real `~/.config/micro`.
`make death` wipes it.

    alias m="micro -config-dir ~/.config/konfig/micro"

## settings you get

    colorscheme   catppuccin-mocha (matches bat + banner)
    numbers       relative (relativeruler); current line absolute
    indent        2 spaces, tabstospaces
    keymenu       2-line shortcut bar pinned at the bottom
    softwrap      on, scrollbar on

## keys (beyond the standard ctrl-set)

    F5            toggle file-tree sidebar (filemanager)
    F6            fuzzy open / find-in-files (fzf)
    F7            reformat selection: python via `ruff format -`
    F8            toggle spellcheck (aspell, dict pinned en_US)
    Alt-|         pipe selection through a shell cmd (vim's `!`):
                  opens `textfilter `, type e.g. `sort -u` or
                  `python3 foo.py`, Enter -> output replaces selection
    Ctrl-_  Alt-/ comment / uncomment line or selection
    Alt-v  Alt-h  split pane vertical / horizontal (Alt = ⌥ Option)
    Ctrl-w        cycle between panes
    Ctrl-q        close pane (or quit last one)
    Ctrl-t        new tab     Ctrl-PgUp/PgDn  switch tabs
    Ctrl-a / ^D   select all / duplicate line
    Alt-Up/Down   move line up / down

Reformat acts on the selection — `Ctrl-a` first to format the whole
file. The bottom keymenu lists the standard keys; the statusline
(right) lists the custom F-keys. Splits open a blank pane; `Ctrl-w`
to it, then open a file. (Alt-keys need "Option as Meta" on in your
terminal.)

## plugins

Four auto-install on first `make sh` into the isolated plug dir
(never your real `~/.config/micro`; `make death` wipes them):

    filemanager   F5 sidebar tree (parity with nvim-tree)
    fzf           F6 fuzzy open (needs the fzf binary)
    aspell        F8 spellcheck; auto-checks prose + code comments
    detectindent  match a file's existing tabs-vs-spaces

Add more: `Ctrl-e`, then `> plugin install <name>`; list available
with `> plugin available`.

## syntax highlighting

150+ languages ship built-in. Konfig adds a richer `lisp.yaml`
(`syntax/lisp.yaml`) covering Common Lisp + Emacs Lisp — `defun`,
`let`, `cond`, `:keywords`, `#'`, `;` comments — which the bundled one
omits. Audition any theme live: `Ctrl-e`, then `set colorscheme <Tab>`.

## tweaking

Edit the flat repo files (`micro.settings.json`,
`micro.bindings.json`, `micro.lisp.yaml`); they are symlinked, so
changes are live on the next launch. No per-repo override file —
micro config is shared across all gists.
