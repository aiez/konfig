# nvim.md — neovim, as konfig tunes it

Konfig's `init.lua` is a minimal nvim 0.12 config: catppuccin-mocha
colors + nvim-tree file sidebar. Launched isolated — your own nvim
config is untouched.

## start it

    make vi          # opens first source file
    make vi F=foo.py # open a specific file
    vi file          # alias inside `make sh`

Under the hood: `NVIM_APPNAME=$(APP) nvim --clean -u $(KONFIG)/init.lua`.
`--clean` ignores your ~/.config/nvim; `NVIM_APPNAME` gives each repo
its own plugin/data dir, so plugins for one repo can't break another.

First run downloads three plugins via `vim.pack` (nvim >= 0.12):
catppuccin, nvim-web-devicons, nvim-tree.

## settings you get

    leader        space
    numbers       on, cursorline on
    indent        2 spaces, expandtab
    search        ignorecase + smartcase (caps = exact)
    clipboard     unnamedplus (yank = system clipboard)

## file sidebar (nvim-tree)

    SPACE e       toggle 25%-width file tree
    ENTER         open file       a  add file
    d             delete          r  rename
    R             refresh

netrw is disabled; nvim-tree replaces it.

## survival vi (if rusty)

    i / ESC       insert / back to normal
    :w :q :wq     save / quit / both
    u  ctrl-r     undo / redo
    /text n N     search, next, prev
    dd yy p       cut line, copy line, paste
    gg G :42      top, bottom, line 42

## per-repo overrides

Drop `init.local.lua` in the repo root; it is loaded *last* via
pcall (silent if missing), so it wins:

    -- init.local.lua
    vim.o.wrap = false
    vim.filetype.add({ extension = { mal = "lisp" } })

Never fork konfig's init.lua for one repo.
