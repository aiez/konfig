# vim: ts=2 sw=2 sts=2 et :
# shared make boilerplate. doubles as konfig's own Makefile.
# a repo Makefile sets a few knobs then: include $(KONFIG)/Makefile
# knobs (all optional, defaults below):
#   APP MAIN EXT LANG SRC COMMENT LINT TOOLS PKG KONFIG
SHELL := /bin/bash

# self-locate: dir of this file (= "." standalone, repo's path when included)
KONFIG  ?= $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
# APP/MAIN/BANNER: ignore env (fossil-leak from prior `make sh`). Repo
# Makefile assignments (origin=file) keep winning; only origin=environment
# is overridden back to default.
ifeq ($(origin APP),environment)
override APP := $(notdir $(CURDIR))
endif
ifeq ($(origin MAIN),environment)
override MAIN := main.py
endif
ifeq ($(origin BANNER),environment)
override BANNER := banner.txt
endif
APP     ?= $(notdir $(CURDIR))   # NVIM_APPNAME / tmux socket / session
MAIN    ?= main.py               # entry point (p alias in bashrc)
EXT     ?= py                    # source file extension
LANG    ?= python                # a2ps pretty-print language
SRC     ?= *.$(EXT)              # source glob (hist, pdf, lint)
COMMENT ?= \#|--|//              # comment regex (hist strips these)
LINT    ?= ruff check $(SRC)     # check target command
TOOLS   ?=                       # extra doctor checks: "cmd:use cmd:use"
PKG     ?= gawk git neovim tmux micro  # doctor install hint
BANNER  ?= banner.txt            # ascii art shown atop help (if present)
# make keeps trailing spaces before #, which break path concat; strip them
override KONFIG := $(strip $(KONFIG))
# DOOT: gists root (dir holding konfig + sibling gists). env wins; else
# parent of konfig. all cross-repo paths hang off this -- see style_gist.md.
DOOT    ?= $(abspath $(KONFIG)/..)
override APP    := $(strip $(APP))
override MAIN   := $(strip $(MAIN))

OPEN := $(shell command -v open 2>/dev/null \
                || command -v xdg-open 2>/dev/null \
                || echo true)

need = @command -v $(1) >/dev/null || { \
         printf "missing: %s (needed for %s)\n" $(1) $(2); \
         exit 1; }

konfig = @test -d $(KONFIG) || { \
           printf "missing dir: %s\n" "$(KONFIG)"; \
           printf "clone: git clone https://github.com/aiez/konfig %s\n" "$(KONFIG)"; \
           exit 1; }

# base tools these targets need, plus per-repo TOOLS
ALLTOOLS := gawk:help/hist git:push nvim:vi/sh tmux:mux micro:m $(TOOLS)

.DEFAULT_GOAL := help

## help -------------------------------------------------------

help: ## show help
	@bash $(KONFIG)/banner.sh $(BANNER) 2>/dev/null || true
	@gawk -f $(KONFIG)/help.awk $(MAKEFILE_LIST)
	@echo " "

## doctor -----------------------------------------------------

doctor: ## check required tools
	@for e in $(ALLTOOLS); do \
	   c=$${e%%:*}; use=$${e##*:}; \
	   if command -v $$c >/dev/null; then \
	     printf "  \033[32mok\033[0m %-10s used by: %s\n" "$$c" "$$use"; \
	   else \
	     printf "  \033[31mXX\033[0m %-10s missing: %s\n" "$$c" "$$use"; fi; done
	@printf "\nmacOS: brew install $(PKG)\n"
	@printf "linux: apt  install $(PKG)\n"

## install ----------------------------------------------------

install: ## how to install packages (runs nothing)
	@printf "package install is a separate step. run:\n\n"
	@printf "  ./install.sh        # install from Brewfile\n"
	@printf "  ./install.sh dump   # regenerate Brewfile from this machine\n"
	@printf "  ./install.sh check  # list Brewfile pkgs not yet installed\n\n"

## check ------------------------------------------------------

check: ## lint source ($(LINT))
	@$(LINT) || true

## push -------------------------------------------------------

push: ## add+commit+push+status; msg from cli (make push my note) else prompts
	@git add -A
	@m="$(filter-out $@,$(MAKECMDGOALS))"; \
	  [ -z "$$m" ] && { printf "commit msg (empty=save): "; read m </dev/tty; }; \
	  git commit -m "$${m:-save}" || true
	@git push
	@git status
%:            # swallow the message words so make won't error
	@:

# walk sibling gists, run shell fn `repo` (defined by caller) inside each
eachgist = for d in $$(cd .. && ls -d */ 2>/dev/null); do d=$${d%/}; \
	  [ -d "../$$d/.git" ] || continue; \
	  printf "\n=== %s ===\n" "$$d"; \
	  ( cd ../$$d && repo ); \
	done

pushs: ## commit+push every sibling gist; prompts only if dirty
	@repo(){ \
	  if [ -n "$$(git status --porcelain)" ]; then \
	    printf "  msg (empty=skip): "; read m </dev/tty; \
	    [ -z "$$m" ] && { echo "  skipped"; return 0; }; \
	    git add -A && git commit -m "$$m" && git push; \
	  elif [ "$$(git rev-list --count @{u}..HEAD 2>/dev/null || echo 0)" != "0" ]; then \
	    git push; \
	  else echo "  clean + synced"; fi; \
	}; $(eachgist)

pulls: ## git pull every sibling gist (skips dirty repos)
	@repo(){ \
	  if [ -n "$$(git status --porcelain)" ]; then \
	    echo "  skipped: dirty (commit or stash first)"; \
	  else git pull --ff-only; fi; \
	}; $(eachgist)

## hist -------------------------------------------------------

hist: ## paragraph line counts + cum%% (skip comments)
	@cat $(wildcard $(SRC)) | grep -Ev '^[[:space:]]*($(COMMENT))' | \
	  gawk -f $(KONFIG)/hist.awk

## sh ---------------------------------------------------------

sh: ## tuned bash + vi alias (config from $(KONFIG))
	$(call need,nvim,sh)
	$(call need,git,sh)
	$(call konfig)
	@KONFIG=$(abspath $(KONFIG)) APP=$(APP) MAIN=$(MAIN) BANNER=$(abspath $(BANNER)) \
	 bash --rcfile $(KONFIG)/bashrc -i

## vi ---------------------------------------------------------

F ?= $(firstword $(wildcard $(SRC))) # for vi

vi: ## tuned nvim + catppuccin (config from $(KONFIG))
	$(call need,nvim,vi)
	$(call konfig)
	@NVIM_APPNAME=konfig/nvim nvim --clean -u $(KONFIG)/init.lua $F

## el ---------------------------------------------------------

el: ## tuned emacs (-nw): evil+org-babel+sly+magit, config from $(KONFIG)
	$(call need,emacs,el)
	$(call konfig)
	@emacs -nw -Q --init-directory $(HOME)/.config/konfig/emacs -l $(KONFIG)/init.el $F

## mux --------------------------------------------------------

mux: ## tuned tmux, private socket, config from $(KONFIG)
	$(call need,tmux,mux)
	$(call konfig)
	@KONFIG=$(abspath $(KONFIG)) APP=$(APP) MAIN=$(MAIN) BANNER=$(abspath $(BANNER)) \
	 tmux -L $(APP) -f $(KONFIG)/tmux.conf new-session -A -s $(APP)

## claude -----------------------------------------------------

claude: ## tmux: left shell | right = claude (top) + `make sh` (bottom)
	$(call need,tmux,claude)
	$(call konfig)
	@T="tmux -L $(APP)"; \
	 $$T has-session -t $(APP) 2>/dev/null && exec $$T attach -t $(APP); \
	 $$T -f $(KONFIG)/tmux.conf new-session -d -s $(APP) -c $(CURDIR) \; \
	   send-keys 'make sh' C-m \; \
	   split-window -h -c $(CURDIR) \; send-keys 'make sh' C-m 'clear' C-m 'claude' C-m \; \
	   split-window -v -c $(CURDIR) \; send-keys 'make sh' C-m \; \
	   select-pane -L; \
	 exec $$T attach -t $(APP)

## play -------------------------------------------------------

GAMES ?= $(DOOT)/bsdgames-osx  # sibling gist of classic bsdgames source
GAME  ?= robots                # for: make play GAME=<dir>
DEFS  ?=                       # extra -D flags some games need
# strip trailing space left before the # comments above (see L32)
override GAMES := $(strip $(GAMES))
override GAME  := $(strip $(GAME))
override DEFS  := $(strip $(DEFS))

play: ## build+run a bsdgame: make play GAME=trek (DEFS=-D...)
	$(call need,cc,play)
	@g=$(GAMES)/$(GAME); \
	 test -d $$g || { echo "no game '$(GAME)' in $(GAMES)"; \
	   echo "have: $$(cd $(GAMES) 2>/dev/null && ls -d */ | tr -d /)"; exit 1; }; \
	 out=$${TMPDIR:-/tmp}/bsdg_$(GAME); err=$${TMPDIR:-/tmp}/bsdg_$(GAME).err; \
	 echo "building $(GAME)..."; \
	 cc -w -o $$out $(DEFS) $$g/*.c -lcurses 2>$$err \
	   || { echo "build failed:"; cat $$err; exit 1; }; \
	 exec $$out

robots: ## play ASCII daleks (bsdgames robots)
	@$(MAKE) --no-print-directory play GAME=robots DEFS=-DMAX_PER_UID=5

## toys -------------------------------------------------------
# eye-candy needing a brew formula; print install hint if missing
toy = @command -v $(1) >/dev/null || { \
        printf "missing: %s  (brew install %s)\n" $(1) $(2); exit 1; }; \
      exec $(1) $(3)

cmatrix: ## matrix rain        (brew install cmatrix)
	$(call toy,cmatrix,cmatrix,-ab)
aquarium: ## fish tank         (brew install asciiquarium)
	$(call toy,asciiquarium,asciiquarium,)
pipes: ## animated pipes       (brew install pipes-sh)
	$(call toy,pipes.sh,pipes-sh,)
chess: ## play chess           (brew install gnuchess)
	$(call toy,gnuchess,gnuchess,)
tetris: ## play tetris         (brew install vitetris)
	$(call toy,vitetris,vitetris,)
checkers: ## play checkers     (brew install nbsdgames)
	$(call toy,checkers,nbsdgames,)

## pdf --------------------------------------------------------

Font   ?= 4.5         # for ~/tmp/konfig/%.pdf
Cols   ?= 3         # for ~/tmp/konfig/%.pdf
Orient ?= landscape # for ~/tmp/konfig/%.pdf
HL     ?= heavy     # for ~/tmp/konfig/%.pdf a2ps highlight level
BREAK  ?=           # for ~/tmp/konfig/%.pdf form-feed marker (awk regex; empty=off)
SSH    ?=           # for ~/tmp/konfig/%.pdf name of exported var w/ a2ps style sheet

~/tmp/konfig/%.pdf : %.$(EXT) ## src -> pdf via a2ps
	$(call need,a2ps,pdf)
	$(call need,ps2pdf,pdf)
	@mkdir -p ~/tmp/konfig
	@echo "pdfing : $@ ..."
	@D=$$(mktemp -d); trap "rm -rf $$D" EXIT; \
	 mkdir -p $$D/.a2ps; \
	 [ -n "$(SSH)" ] && printf '%s\n' "$${$(SSH)}" > $$D/.a2ps/$(LANG).ssh; \
	 { [ -n "$(BREAK)" ] && awk '/$(BREAK)/{if(NR>1)printf "\f";next}{print}' $< \
	     || cat $<; } | \
	 HOME=$$D a2ps -Bj --$(Orient) --line-numbers=1 \
	      --highlight-level=$(HL) --borders=no \
	      --pro=color --right-footer="" --left-footer="" \
	      --pretty-print=$(LANG) --footer="page %p." \
	      -M letter --font-size=$(Font) \
	      --columns $(Cols) -o - | ps2pdf - $@
	@$(OPEN) $@

MDSTYLE ?= tango        # pandoc code-token theme for `pretty` (light)
pretty: ## $(f).md -> self-contained html (images embedded) + open. usage: make f=NAME pretty
	$(call need,pandoc,pretty)
	@test -n "$(f)" || { echo "usage: make f=<basename> pretty"; exit 1; }
	@mkdir -p ~/tmp/konfig
	@pandoc $(f).md -o ~/tmp/konfig/$(f).html --embed-resources --standalone \
	        --highlight-style=$(MDSTYLE) --include-in-header=$(KONFIG)/pretty.css
	@$(OPEN) ~/tmp/konfig/$(f).html

## death ------------------------------------------------------

# every external dir konfig generates lives under a konfig/ segment of an XDG
# base (+ ~/tmp/konfig). nuke them all; the gist itself is never touched.
DEATHDIRS := ~/.cache/konfig ~/.config/konfig ~/.local/share/konfig \
             ~/.local/state/konfig ~/tmp/konfig

death: ## wipe ALL generated konfig dirs (cache/config/data/state/tmp)
	@echo "These dirs will be DELETED (gist files are safe):"
	@for d in $(DEATHDIRS); do echo "  $$d"; done
	@read -p 'Type DESTROY to confirm: ' a; [ "$$a" = DESTROY ] || { echo aborted; exit 1; }
	@read -p 'Really? last chance [y/N]: ' b; [ "$$b" = y ] || { echo aborted; exit 1; }
	@rm -rf $(DEATHDIRS)
	@echo "gone. re-run any tool to rebuild its dir fresh."

## gists (konfig only) ----------------------------------------

# konfig-only bootstrap of the sibling repos. kept in a SEPARATE file pulled in
# only when make runs inside konfig -- so the targets never reach the shared
# boilerplate siblings include, not even their `make help` (which text-greps
# MAKEFILE_LIST: gists.mk simply isn't on it in a sibling).
ifeq ($(notdir $(CURDIR)),konfig)
-include $(KONFIG)/gists.mk
endif
