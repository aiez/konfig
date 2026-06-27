# style_gist.md — gist structure + README style

Goal: every repo readable on gist.github.com preview, runnable in
three commands, and skinnable like a unix man page.

## repo split

Three sibling repos in `~/gists/`:

    konfig/       shared boilerplate (Makefile, bashrc, hist.awk,
                  banner.sh, init.lua, tmux.conf)
    optimiz/      example datasets (CSV only, no code)
    <project>/   code + project-specific README + Makefile knobs

Each project repo includes konfig's Makefile, points at optimiz for
data. No code/data/config mixed in one repo.

## repo file layout

    <project>/
      ,project.md      README; comma-prefix sorts to top of gist listing
      Makefile         knobs (APP/MAIN/EXT/...) then include konfig
      project.py       single-file source (see style_code.md)
      banner.txt       ascii art shown by `make help` / `make sh`

## Makefile pattern

MANDATORY: every gist — code, data-only, or doc-only — carries a
Makefile. Knobs first, then a loud-failure guard, then
`include $(KONFIG)/Makefile` as the last line. That include is what
gives every repo the shared targets (help doctor check push hist sh
vi mux pdf) for free.

    KONFIG ?= ../konfig
    APP   := project
    MAIN  := project.py
    EXT   := py
    LANG  := python
    LINT  := ruff check *.py
    TOOLS := python3:run-py ruff:lint
    PKG   := python3 gawk ruff neovim tmux

    $(KONFIG)/Makefile:
    	@test -f $@ || { echo "missing konfig: ..."; exit 1; }
    include $(KONFIG)/Makefile

Data-only and doc-only repos (no source): omit
MAIN/EXT/LANG/LINT/TOOLS. Keep KONFIG, APP, PKG, the guard, and
the include — minimum viable Makefile:

    KONFIG ?= ../konfig
    APP    := project
    PKG    := gawk neovim tmux

    $(KONFIG)/Makefile:
    	@test -f $@ || { echo "missing konfig: git clone http://tiny.cc/konfig $(KONFIG)"; exit 1; }
    include $(KONFIG)/Makefile

## cross-repo references (no naked paths)

A gist NEVER hardcodes another repo's location. Naked `../sibling`
literals and absolute `/Users/...` (or `/home/...`) paths are
VERBOTEN: they break the moment a gist moves (into `old/`, a deeper
dir) or a sibling relocates.

All external references resolve through ONE overridable root, tried
in order:

    1. env var      $DOOT (gists root), $KONFIG=$DOOT/konfig
                    exported once in konfig/bashrc            -- wins
    2. upward search climb parents for a dir named `konfig`   -- fallback
    3. relative     `?= ../konfig`           -- last-resort default only

`$DOOT` = the dir holding all the sibling gists (konfig, optimiz,
<project>...). One knob; move the tree or nest a gist, edit one line,
every gist follows.

    # Makefile: `?=` lets an exported env value override the default
    KONFIG ?= ../konfig
    DOOT   ?= $(abspath $(KONFIG)/..)
    DATA   ?= $(DOOT)/optimiz/auto93.csv      # never bare ../optimiz

    # Python: env first, then search, then the documented default
    DOOT = os.environ.get("DOOT") or find_up("konfig", then="..")
    DATA = f"{DOOT}/optimiz/auto93.csv"

Sole sanctioned naked path: the `KONFIG ?= ../konfig` bootstrap
default (and `DOOT` derived from it). Everything else hangs off the
root var. Doc/README example commands may show `../optimiz` for
brevity; runnable code and Makefile recipes may not.

Audit (see style_code.md `PATHS`): one grep surfaces every offender.

## local Makefile rules (after include)

Konfig's Makefile owns generic targets (help, doctor, check, push,
hist, sh, vi, mux, pdf). Repo-specific targets go in the local
Makefile *after* `include $(KONFIG)/Makefile`.

Every repo should define a local `test` rule that runs all
self-checks — language/framework-specific, so it can't live in
konfig.

Konfig's `check` = static lint. Local `test` = runtime behaviour.
Both kept separate so CI can call them independently.

### one rule per test, UPPERCASE-discovered

Each test is its own rule with an **UPPERCASE** name (TREES, MAIN,
PARSE, EQUIV, ...). The local `test` rule auto-discovers them by
grepping the Makefile — no central list to keep in sync. Adding a
new test = adding a new UPPERCASE rule.

    BANG:  ## test: end! appends correctly
    	@sbcl --script tests/bang.lisp

    PARSE: ## test: csv parser round-trips
    	@sbcl --script tests/parse.lisp

    test:  ## run every UPPERCASE rule
    	@gawk -F: '/^[A-Z][A-Z_]*:[^=]/ {print $$1}' $(MAKEFILE_LIST) | \
    	  sort -u | while read t; do \
    	    printf "\n=== %s ===\n" "$$t"; $(MAKE) -s $$t; done

Why UPPERCASE: rule name = discovery marker (no comment to drift
out of sync); visually clusters in `make help`; can't collide with
normal lowercase targets or `VAR :=` assignments (regex excludes
`:=` via `[^=]`). Language-agnostic — works for pytest, sbcl,
shell, anything callable from make.

## local rc / init overrides

Konfig's bashrc, init.lua, tmux.conf each source an optional
sibling-of-CWD file at the *end* so repo-specific tweaks layer on
without forking konfig:

    bashrc:    [ -f "$PWD/bashrc.local" ]    && source "$PWD/bashrc.local"
    init.lua:  pcall(dofile, vim.fn.getcwd() .. "/init.local.lua")
    tmux.conf: source-file -q tmux.local.conf

Silent if missing. Local file sources last → wins on conflict.
Use for per-project aliases (e.g. `alias r='sbcl --script ...'`),
language-specific keymaps, project-specific tmux panes.

## README (`,project.md`)

### first 7 lines = gist preview hook

Gist listing renders top of file. Pack the hook tight:

    line 1   <!-- copyright comment -->                (invisible)
    line 2   right-aligned badges (single line!)       (visible)
    line 3   blank
    line 4   ### [http://tiny.cc/project](http://tiny.cc/project)
    line 5   one-paragraph pitch with concrete facts
    line 6   blank
    line 7   ```bash + `# install and test` + clone line

### badges

`<p align="right">` is stripped by gist. Use one `<img align="right">`
per badge, all on a single line (no newlines between — newlines
trigger implicit paragraph breaks that kill the float chain). Order
in source is reversed: first floats furthest right.

Quote the attribute (`align="right"`, not `align=right`).

Standard four: Purpose · License · Language · Author.

### title

    ### [http://tiny.cc/project](http://tiny.cc/project)

H3, clickable tiny.cc URL. Skips repeating "Project — " noise; the
URL is the identifier.

### TOC bars (above NAME)

Two one-line pipe-separated TOCs sit between the install snippet
and `## NAME`. Standard in every gist README:

    **Sections:** [NAME](#name) | [SYNOPSIS](#synopsis) | ... | [LICENSE](#license)

    **Files:** [foo.py](http://tiny.cc/<gist>#file-foo-py) | [bar.md](http://tiny.cc/<gist>#file-bar-md) | ...

- *Sections* — section anchors within this README. Labels in
  SHORT-CAPS, match the H2 headers. Skip sections that don't
  exist in the project.
- *Files* — sibling files via the ABSOLUTE
  `http://tiny.cc/<gist>#file-<name>-<ext>` (so the links resolve
  even when the README is read off the gist page). Anchor rule:
  lowercase, dots/punctuation collapse into a single `-`, never
  double. E.g. `lib-.lisp` → `#file-lib-lisp` (NOT `lib--lisp`);
  `fft-2small.lisp` → `#file-fft-2small-lisp`. Omit the README
  itself and trivial files (banner.txt, .gitignore). Order by
  importance, not alphabetical.

Keeps gist preview navigable without scrolling.

### body: man-page hybrid

H2 section headers in markdown. Bodies indented 4 spaces so they
render as `<pre>`. Looks like `man(1)` output. Tables become
aligned text columns (no markdown table noise on mobile).

### standard sections (in order)

    NAME          one-line summary
    SYNOPSIS      usage line
    OPTIONS       flag table
    DATA          input format (CSV column suffix conventions)
    TESTS         --test_X discoverable entry points
    OUTPUT        what a typical run prints
    EXIT          exit codes
    SEE ALSO      sibling repos with tiny.cc URLs
    LICENSE       MIT + choosealicense.com link
    AUTHOR        name + email

DATA after OPTIONS — matches unix `man` ordering (FILES after OPTIONS).

## CSV column-name protocol (DATA convention)

    first char UPPER  -> numeric (Num)
    first char lower  -> symbolic (Sym)
    suffix '+'        -> numeric goal, maximize
    suffix '-'        -> numeric goal, minimize
    suffix '!'        -> symbolic goal (klass)
    suffix 'X'        -> ignore
    else              -> predictor
    missing value     -> '?'

Self-describing header; no separate schema file. Same protocol
across every project + every CSV in optimiz/.

## files TOC anchors

Link sibling files in the README TOC with ABSOLUTE gist URLs:
`http://tiny.cc/<gist>#file-<name>-<ext>` (lowercase,
dots/punctuation collapse into single `-`, never double). E.g.
`luamine.lua` → `http://tiny.cc/luamine#file-luamine-lua`;
`lib-.lisp` → `…#file-lib-lisp` (NOT `lib--lisp`).

## URLs

`tiny.cc/<reponame>` redirects to the gist. Use in:
- README title
- SEE ALSO cross-links
- install snippet (`git clone http://tiny.cc/foo`)

## license

MIT. Badge link → `https://choosealicense.com/licenses/mit/`.
LICENSE section repeats the link.
