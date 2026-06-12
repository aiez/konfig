# make.md — make, as konfig uses it

One shared Makefile (this repo) gives every gist the same targets.
A repo's own Makefile is just knobs + `include $(KONFIG)/Makefile`.

## the everyday targets

    make             same as `make help` (default goal)
    make help        banner + every `target: ## desc` line
    make doctor      check required tools, print install hints
    make check       run $(LINT)
    make test        repo-defined; runs every UPPERCASE test rule
    make push        git add -A, commit (msg from cli or prompt), push
    make push fix typo   <- message straight on the command line
    make pushs       commit+push EVERY sibling gist (prompts if dirty)
    make pulls       pull every sibling gist (skips dirty ones)
    make sh          tuned bash        (see bash.md)
    make vi          tuned nvim        (see nvim.md)
    make mux         tuned tmux        (see tmux.md)
    make hist        paragraph-size histogram of the source
    make ~/tmp/foo.pdf   pretty-print foo.$(EXT) via a2ps

## a repo Makefile (knobs then include)

    KONFIG ?= ../konfig
    APP    := lull          # session/socket/NVIM_APPNAME
    MAIN   := lull.lua      # entry point (p alias)
    EXT    := lua
    LANG   := lua           # a2ps language
    COMMENT:= --            # hist strips these
    LINT    = luacheck -- *.lua
    TOOLS  := lua:run luacheck:check
    PKG    := lua luacheck gawk neovim tmux

    $(KONFIG)/Makefile:
    	@test -f $@ || { echo "missing konfig: git clone http://tiny.cc/konfig $(KONFIG)"; exit 1; }
    include $(KONFIG)/Makefile

Data-only repos: keep just KONFIG, APP, PKG, the guard, the include.

## self-documenting help

`make help` greps the Makefile itself:

    target: ## one-line description     -> shown by help
    VAR ?= default   # for <target>     -> shown under that target

Document a target by writing the `##` comment; nothing else needed.

## tests: one rule per test, UPPERCASE

    PARSE: ## test: csv parser round-trips
    	@lua tests/parse.lua

    test:  ## run every UPPERCASE rule
    	@gawk -F: '/^[A-Z][A-Z_]*:[^=]/ {print $$1}' $(MAKEFILE_LIST) | \
    	  sort -u | while read t; do \
    	    printf "\n=== %s ===\n" "$$t"; $(MAKE) -s $$t; done

Add a test = add an UPPERCASE rule. `test` discovers it by grep;
no central list to maintain.

## make survival rules

    recipes are TABS, not spaces (the classic error)
    $$ in a recipe = shell $ (make eats one)
    ?=  set only if not already set (env/cli can override)
    :=  evaluate now;  =  evaluate at use
    @   prefix = don't echo the command
    make -s       silent     make -n   dry run (print, don't do)
    make V=1 t    pass variable V to target t

## paths

Cross-repo paths hang off `$(DOOT)` (gists root, default: parent
of konfig). Never hardcode `../sibling` outside the
`KONFIG ?= ../konfig` bootstrap line. See style_gist.md.
