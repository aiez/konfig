<!-- Copyright (c) 2026 Tim Menzies, MIT License https://opensource.org/licenses/MIT -->
<a href="https://timm.fyi"><img align="right" alt="Author" src="https://img.shields.io/badge/Author-timm-dc143c?logo=readme&logoColor=white"></a><img align="right" alt="Language" src="https://img.shields.io/badge/Language-Shell-000080?logo=sh&logoColor=white"><a href="https://choosealicense.com/licenses/mit/"><img align="right" alt="License" src="https://img.shields.io/badge/License-MIT-32cd32?logo=open-source-initiative&logoColor=white"></a><img align="right" alt="Purpose" src="https://img.shields.io/badge/Purpose-Shell·Teaching-7b68ee?logo=githubcopilot&logoColor=white">

### [http://tiny.cc/konfig](http://tiny.cc/konfig)
Shared boilerplate for all my gists: one Makefile (help, doctor,
lint, push, pdf, tuned shells/editors/mux), one bashrc, one
init.lua, one tmux.conf. A project repo is just knobs plus
`include $(KONFIG)/Makefile`.

```bash
# install and test-drive from any sibling gist
git clone http://tiny.cc/konfig
git clone http://tiny.cc/luamine luamine && cd luamine
make help
```

<img align="right" alt="image" src="https://gist.github.com/user-attachments/assets/41ed5d0c-c2dd-40a8-91ce-74223a19df96" />

**Sections:** [NAME](#name) | [SYNOPSIS](#synopsis) | [OPTIONS](#options) | [OUTPUT](#output) | [SEE ALSO](#see-also) | [LICENSE](#license) | [AUTHOR](#author)

**Files:** [Makefile](#file-makefile) | [bashrc](#file-bashrc) | [init.lua](#file-init-lua) | [tmux.conf](#file-tmux-conf) | [style_code.md](#file-style_code-md) | [style_gist.md](#file-style_gist-md) | [make.md](#file-make-md) | [bash.md](#file-bash-md) | [nvim.md](#file-nvim-md) | [tmux.md](#file-tmux-md) | [banner.sh](#file-banner-sh) | [help.awk](#file-help-awk) | [hist.awk](#file-hist-awk) | [install.sh](#file-install-sh) | [Brewfile](#file-brewfile)

## NAME

    konfig - shared Makefile + dotfiles for sibling gist repos

## SYNOPSIS

    # in a project repo's Makefile: knobs, guard, include
    KONFIG ?= ../konfig
    APP    := project
    ...
    include $(KONFIG)/Makefile

    make help|doctor|check|test|push|hist|sh|vi|mux|pdf

## OPTIONS

    Knobs a repo sets before the include (see style_gist.md):

      APP    project name (tmux socket, NVIM_APPNAME, banner)
      MAIN   primary source file        (code repos)
      EXT    source extension           (code repos)
      LANG   language name              (code repos)
      LINT   lint command               (code repos)
      TOOLS  tool:why pairs for doctor
      PKG    packages doctor suggests installing

    Tool tutorials: make.md, bash.md, nvim.md, tmux.md.
    Style law for sibling gists: style_code.md, style_gist.md.

## OUTPUT

    make help    banner + every `target: ## desc` line
    make doctor  tool checklist with install hints
    make sh      tuned bash    (banner, git prompt, vi-mode)
    make vi      isolated nvim (catppuccin + tree; --clean)
    make mux     private-socket tmux; `make claude` = 3 panes

## SEE ALSO

    luamine   http://tiny.cc/luamine   Lua data mining
    optimiz   http://tiny.cc/optimiz   example datasets
    semble    http://tiny.cc/semble    regression trees
    repltut   http://tiny.cc/repltut   REPL tutorial prompts

## LICENSE

    MIT. https://choosealicense.com/licenses/mit/

## AUTHOR

    Tim Menzies <timm@ieee.org>
