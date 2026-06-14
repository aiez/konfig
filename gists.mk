# gists.mk -- konfig-only bootstrap of the sibling repos.
# included by konfig/Makefile ONLY when make runs inside konfig, so these
# targets stay out of the shared boilerplate that every sibling includes
# (and out of their `make help`). `make <name>` clones the repo, or pulls if
# it is already there; `make gists` does the lot.

# ~/gists -- dir holding the sibling gists. comment on its OWN line: an inline
# # comment would leave trailing spaces inside the path (see KONFIG strip note).
GROOT ?= $(abspath $(KONFIG)/..)

# $(call sync,clone-url,dest): clone if the dest is absent, else fast-forward pull
sync = @if [ -d "$(2)/.git" ]; then printf 'pull  %s\n' "$(2)"; git -C "$(2)" pull --ff-only -q; \
        else printf 'clone %s\n' "$(1)"; git clone -q "$(1)" "$(2)"; fi

ezr:      ## clone/pull ezr
	$(call sync,http://tiny.cc/ezr,$(GROOT)/ezr)
fairnez:  ## clone/pull fairnez
	$(call sync,http://tiny.cc/fairnez,$(GROOT)/fairnez)
gape:     ## clone/pull gape (tiny python tricks lib)
	$(call sync,http://tiny.cc/gape,$(GROOT)/gape)
kah-lua:  ## clone/pull kah-lua
	$(call sync,http://tiny.cc/kah-lua,$(GROOT)/kah-lua)
klassif:  ## clone/pull klassif (classification CSVs)
	$(call sync,http://tiny.cc/klassif,$(GROOT)/klassif)
textz:    ## clone/pull textz (text-mining CSVs)
	$(call sync,http://tiny.cc/textz,$(GROOT)/textz)
lithp:    ## clone/pull lithp (was lisp-)
	$(call sync,http://tiny.cc/lithp,$(GROOT)/lithp)
luamine:  ## clone/pull luamine (slug: tiny.cc/lull)
	$(call sync,http://tiny.cc/lull,$(GROOT)/luamine)
luk:      ## clone/pull luk
	$(call sync,http://tiny.cc/luk,$(GROOT)/luk)
optimiz:  ## clone/pull optimiz
	$(call sync,https://gist.github.com/timm/078f9287b9871124c63be19f8c9ec5de,$(GROOT)/optimiz)
repltut:  ## clone/pull repltut
	$(call sync,http://tiny.cc/repltut,$(GROOT)/repltut)
sand-box: ## clone/pull sand-box
	$(call sync,http://tiny.cc/sand-box,$(GROOT)/sand-box)
fyi:      ## clone/pull fyi (website; lives in ~/gits/timm)
	$(call sync,https://github.com/timm/fyi,$(HOME)/gits/timm/fyi)

gists: ezr fairnez gape kah-lua klassif textz lithp luamine luk optimiz repltut sand-box fyi ## clone/pull ALL the above
