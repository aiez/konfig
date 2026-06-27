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
	$(call sync,https://github.com/aiez/ezr,$(GROOT)/ezr)
ezr2:     ## clone/pull ezr2 (landscape + dual-mode tree)
	$(call sync,https://github.com/aiez/ezr2,$(GROOT)/ezr2)
fairnez:  ## clone/pull fairnez
	$(call sync,https://github.com/aiez/fairnez,$(GROOT)/fairnez)
nuff:     ## clone/pull nuff (tiny python tricks lib)
	$(call sync,https://github.com/aiez/nuff,$(GROOT)/nuff)
skape:    ## clone/pull skape (FastMap landscape active learner)
	$(call sync,https://github.com/aiez/skape,$(GROOT)/skape)
gistsite: ## clone/pull gistsite (render gists -> static html catalog)
	$(call sync,https://github.com/aiez/gistsite,$(GROOT)/gistsite)
xomo:     ## clone/pull xomo (cocomo-ii + coqualmo: effort/defects/risk)
	$(call sync,https://github.com/aiez/xomo,$(GROOT)/xomo)
kah-lua:  ## clone/pull kah-lua
	$(call sync,https://github.com/aiez/kahlua,$(GROOT)/kah-lua)
klassif:  ## clone/pull klassif (classification CSVs)
	$(call sync,https://github.com/aiez/klassif,$(GROOT)/klassif)
textz:    ## clone/pull textz (text-mining CSVs)
	$(call sync,https://github.com/aiez/textz,$(GROOT)/textz)
lithp:    ## clone/pull lithp (was lisp-)
	$(call sync,https://github.com/aiez/lithp,$(GROOT)/lithp)
luamine:  ## clone/pull luamine
	$(call sync,https://github.com/aiez/luamine,$(GROOT)/luamine)
luk:      ## clone/pull luk
	$(call sync,https://github.com/aiez/luk,$(GROOT)/luk)
optimiz:  ## clone/pull optimiz
	$(call sync,https://github.com/aiez/optimiz,$(GROOT)/optimiz)
regress:  ## clone/pull regress (regression datasets)
	$(call sync,https://github.com/aiez/regress,$(GROOT)/regress)
repltut:  ## clone/pull repltut
	$(call sync,https://github.com/aiez/repltut,$(GROOT)/repltut)
sand-box: ## clone/pull sand-box
	$(call sync,https://github.com/aiez/sandbox,$(GROOT)/sand-box)
fyi:      ## clone/pull fyi (website; lives in ~/gits/timm)
	$(call sync,https://github.com/timm/fyi,$(HOME)/gits/timm/fyi)

gists: ezr ezr2 fairnez nuff skape gistsite xomo kah-lua klassif textz lithp luamine luk optimiz regress repltut sand-box fyi ## clone/pull ALL the above
