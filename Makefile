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
PKG     ?= gawk git neovim tmux  # doctor install hint
BANNER  ?= banner.txt            # ascii art shown atop help (if present)
# make keeps trailing spaces before #, which break path concat; strip them
override KONFIG := $(strip $(KONFIG))
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
           printf "clone: git clone http://tiny.cc/konfig %s\n" "$(KONFIG)"; \
           exit 1; }

# base tools these targets need, plus per-repo TOOLS
ALLTOOLS := gawk:help/hist git:push nvim:vi/sh tmux:mux $(TOOLS)

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

## check ------------------------------------------------------

check: ## lint source ($(LINT))
	@$(LINT) || true

## push -------------------------------------------------------

push: ## add+commit+push+status; msg from cli: make push my note
	@git add -A
	@m="$(filter-out $@,$(MAKECMDGOALS))"; git commit -m "$${m:-save}" || true
	@git push
	@git status
%:            # swallow the message words so make won't error
	@:

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
	@NVIM_APPNAME=$(APP) nvim --clean -u $(KONFIG)/init.lua $F

## mux --------------------------------------------------------

mux: ## tuned tmux, private socket, config from $(KONFIG)
	$(call need,tmux,mux)
	$(call konfig)
	@tmux -L $(APP) -f $(KONFIG)/tmux.conf new-session -A -s $(APP)

## pdf --------------------------------------------------------

Font   ?= 5         # for ~/tmp/%.pdf
Cols   ?= 3         # for ~/tmp/%.pdf
Orient ?= landscape # for ~/tmp/%.pdf

~/tmp/%.pdf : %.$(EXT) ## src -> pdf via a2ps
	$(call need,a2ps,pdf)
	$(call need,ps2pdf,pdf)
	@mkdir -p ~/tmp
	@echo "pdfing : $@ ..."
	@D=$$(mktemp -d); trap "rm -rf $$D" EXIT; \
	 mkdir -p $$D/.a2ps; \
	 HOME=$$D a2ps -Bj --$(Orient) --line-numbers=1 \
	      --highlight-level=heavy --borders=no \
	      --pro=color --right-footer="" --left-footer="" \
	      --pretty-print=$(LANG) --footer="page %p." \
	      -M letter --font-size=$(Font) \
	      --columns $(Cols) -o - $< | ps2pdf - $@
	@$(OPEN) $@
