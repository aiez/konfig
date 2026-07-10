# style_code.md — Python style for these gists

Goal: small, terse, readable in one sitting. ~300–400 lines of real work.
No deps. Pure stdlib. Pedagogical: every line earns its place.

## principles (language-neutral)

Shared across every gist, any language:

- **COI**  compose, don't inherit
- **LoB**  locality of behavior: a type's methods + the funcs on it
  live together (wrapper next to its algorithm). Exception:
  cross-type op-families may cluster (all ctors, all `add`s).
- **SSOT** config from one help/doc string. Scope = one repo:
  gists are standalone, so small function batteries may repeat
  across repos (kah.lua / luamine lib.lua / luk lib.luk) by
  design -- do not "reconcile" them
- **BOB**  funcs <=5 lines — warn, not mandatory
- **BAIL** one-line guards
- **KISS** one func, one job
- **R3**   rule of three: don't wrap until 3rd real use (egs don't
  count); 1–2 uses = inline
- **DSL**  when a shape repeats, invent tiny notation kept as data
  (string/table) + write ONE small interpreter. See below.
- **ZIP**  max logic/screen, min whitespace
- **HINT** names = types (see `## names`)
- **ASCII only** in source — no unicode arrows/glyphs; they break
  the a2ps PDF (`make pdf`)
- **PATHS** no naked cross-repo refs. A gist never hardcodes another
  repo's location (no `../sibling` literals, no absolute `/Users/`,
  `/home/`). Resolve via `$DOOT`/`$KONFIG` env, else `find_up`; the
  sole exception is the `KONFIG ?= ../konfig` bootstrap default. See
  style_gist.md "cross-repo references". Audit:

      grep -rnE '\.\./[a-z]|/Users/|/home/|/gits/' *.$(EXT) Makefile

  every hit must route through the root var, not a literal.

## DSLs (notation as data + one interpreter)

Recurring shapes encoded as data, each read by one small engine.
Spot repetition → minimal syntax → single interpreter. Adding a
row/col/test/flag becomes new data, not new code.

| notation | example |
|---|---|
| **CSV header** = schema | `Clndrs Lbs- Mpg+ klass!` |
| **per-file help string** = help + config | `## options` / `## egs` blocks |
| **test cases** = triples | `{"mid", got, want}` |
| **Makefile self-doc** | `target: ## desc`, `Var ?= v # for X` |

## data records: CSV

Header row names cols. Caps first letter = numeric col, else
symbolic. Suffix: `X`=skip, `-`=goal min, `+`=goal max, `!`=klass.
Rows sorted ascending by distance-to-heaven (lower = better).

    Clndrs, Volume, HpX, Lbs-, Acc+, Mpg+
    4,      90,     48,  1985, 21.5, 40

## on "update"

When asked to "update" code to current style:
1. Re-read the style doc(s)
2. Audit every file in the gist
3. **Print a plan** (file → what changes)
4. **Pause for confirmation**
5. On approval: apply

## layout

    #!/usr/bin/env python3 -B
    """
    name.py, one-line summary (library / cli)
    (c) YEAR, Author <email>, MIT license

    2–4 line narrative: what it does, key idea, dispatch trick.

    Options:
     -x --xname meaning   xname=default
     ...

    eg: python3 name.py -f FILE --tree
    """
    import sys, re
    from math import ...
    from random import ...

    BIG  = inf
    TINY = 1e-30

    # ## constructors -----------------------------------------------
    def Foo(...): return o(it=Foo, ...)

    # ## one-polymorphic-op (dispatch on .it) -----------------------
    def add(i, v): ...

    # ## methods ----------------------------------------------------
    ...

    # ## lib --------------------------------------------------------
    class o(dict): ...
    def csv(file): ...
    def cli(the, doc, egs={}): ...

    # ## egs (run via --name) ---------------------------------------
    def test_the(): ...
    def test_tree(): ...

    the = settings(__doc__)
    if __name__ == "__main__":
      cli(the, __doc__, globals())

## conventions

    indent           2 spaces
    line width       ~70 chars where possible
    type hints       none
    docstrings       module only; not per-function
    comments         section dividers `# ## name ----`, plus
                     end-of-line for non-obvious lines only
    constants        UPPERCASE (BIG, TINY)
    private fields   leading _ (repr skips them)

## data records: o(dict)

    class o(dict):
      __getattr__ = dict.get
      __setattr__ = dict.__setitem__

Use o(k=v,...) for plain records. Attr + dict access both work.
No dataclass overhead.

## tagged unions

Instead of subclasses, every record carries `it=<Constructor>`.
Polymorphic functions dispatch on `i.it is Foo`. One `add()`,
one `mid()`, one `spread()` handle Num/Sym/Data uniformly.

    def add(i, v):
      if   i.it is Data: ...
      elif i.it is Sym:  ...
      else:              ...   # Num

## tiny helpers

Lambdas inline when one-shot:

    yfun = yfun or (lambda r: r[root.cols.klass.at])
    ymid = lambda rs: sum(disty(root, r) for r in rs)/max(1, len(rs))

Walrus for one-pass init+use:

    out += [col := (Num if s[0].isupper() else Sym)(s, at)]

## names

Function arguments mirror their class. `def foo(data, rows, col)`
tells the reader the types without annotations.

    arg name   means
    --------   --------------------------------------------------
    data       a Data
    rows       list of rows (each row = list of cell values)
    row        one row
    col        a Sym or Num. **collective noun** for either
    cols       list of cols
    num        a Num specifically (when Sym wouldn't fit)
    sym        a Sym specifically
    t          a Tree node (interior) or Data (leaf)
    the        global config (settings(__doc__))

One-letter names allowed only for tight loops / lambdas where the
larger name is in scope:

    for c in data.cols.x:        # c shadows nothing; col=c implied
      for v in row:              # v=value, r-row already iterated
        ...

Avoid `d` for data, `r` for row, `c` for col at function-argument
scope — that's where the type cue matters most. Use the long name.

    yes:  def disty(data, row):  ...
    no:   def disty(d, r):       ...

Full words for module-level / exported names (Data, treeShow,
generalized).

Short scalars, any language, tight scope only:

    n        int / count / index
    s, v     string / scalar value
    at       column index
    lo, hi   bounds
    mu, sd   mean, stdev
    plurals  cols rows xs(=features) ys(=goals) = lists

(`t` and `i` are language-specific: `t` = table/tree, `i` = loop
index or method receiver. Disambiguate per language doc.)

## CLI

Shared protocol (any language in these gists):

- The help/doc string is the SSOT for options + defaults.
- Option line `--name=default` seeds config; action line (no `=`)
  doesn't.
- Flags are long-only except canonical shorts `-t`(train),
  `-T`(test), `-h`(help). Unknown flag = error.
- `--name` runs the matching test/eg.
- Every file is standalone-runnable AND importable (CLI or library).

Python: options live in the module docstring; `settings(doc)` parses
`name=default` pairs into `the`. `cli(the, doc, globals())` toggles
booleans, sets values, runs `test_<name>()` for any `--<name>`.

Every test is `def test_X():` — discoverable by `grep '^def test_'`.

## library vs app config (no global `the` in libraries)

An **app** (ezr) owns a global `the = settings(__doc__)`. A **library**
others import (nuff, on PyPI) must NOT — a global config is a landmine
in someone else's program. So library functions carry their tuning as
keyword args, with the default living once at the lowest function:

    def disty(data, row, **kw): minkowski(..., **kw)   # p flows through
    def minkowski(vals, p=2): ...                       # default lives here
    def same(xs, ys, cliff=0.195, conf=1.36): ...
    def shuffle(lst, rng=random): ...                   # pass your own RNG

`settings(s)` still parses `var=val` from a string into an `o`, but the
*caller* (the app) owns the result; the library never reaches for it.
nuff.py is the canonical tiny stdlib-only library (records, io, rand,
stats, columns, distance, bayes, tree — one file, zero deps).

## numerics

    BIG  = inf            for "no cut yet" sentinel
    TINY = 1e-30          for divide-by-zero guards in z-score / disty
    # NEVER use 1/BIG as epsilon — inf division underflows to 0

## tests run by seed

`cli` calls `seed(the.seed)` before each test fn — runs are reproducible.

## avoid

    type hints (noise for ~300-line scripts)
    abc / dataclass / pydantic
    multi-paragraph docstrings on functions
    try/except for control flow (except `of()` int/float coercion)
    f-strings when % does the job in a one-liner
    classes (except `o`); use closures or modules of functions
