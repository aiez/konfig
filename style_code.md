# style_code.md — Python style for these gists

Goal: small, terse, readable in one sitting. ~300–400 lines of real work.
No deps. Pure stdlib. Pedagogical: every line earns its place.

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

## CLI

Options live in the module docstring; `settings(doc)` parses
`name=default` pairs into `the`. `cli(the, doc, globals())` toggles
booleans, sets values, runs `test_<name>()` for any `--<name>`.

Every test is `def test_X():` — discoverable by `grep '^def test_'`.

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
