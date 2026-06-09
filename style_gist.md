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

Data-only repos (no source): omit MAIN/EXT/LANG/LINT/TOOLS. Keep
KONFIG, APP, PKG.

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

Link sibling files in the README TOC with gist anchors:
`#file-<name>-<ext>` (lowercase, dots/punctuation stripped).
E.g. `lull.lua` → `#file-lull-lua`.

## URLs

`tiny.cc/<reponame>` redirects to the gist. Use in:
- README title
- SEE ALSO cross-links
- install snippet (`git clone http://tiny.cc/foo`)

## license

MIT. Badge link → `https://choosealicense.com/licenses/mit/`.
LICENSE section repeats the link.
