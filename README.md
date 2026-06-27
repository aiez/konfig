<!-- Copyright (c) 2026 Tim Menzies, MIT License https://opensource.org/licenses/MIT -->
<a href="https://timm.fyi"><img align="right" alt="Author" src="https://img.shields.io/badge/Author-timm-dc143c?logo=readme&logoColor=white"></a><img align="right" alt="Language" src="https://img.shields.io/badge/Language-Shell-000080?logo=sh&logoColor=white"><a href="https://choosealicense.com/licenses/mit/"><img align="right" alt="License" src="https://img.shields.io/badge/License-MIT-32cd32?logo=open-source-initiative&logoColor=white"></a><img align="right" alt="Purpose" src="https://img.shields.io/badge/Purpose-Shell·Teaching-7b68ee?logo=githubcopilot&logoColor=white">

### [https://github.com/aiez/konfig](https://github.com/aiez/konfig)
Portable, self-erasing boilerplate for all my gists: one Makefile
(help, doctor, lint, push, pdf, tuned shells/editors/mux), one
bashrc, init.lua + init.el, one tmux.conf, plus isolated nvim/micro
configs. A project repo is just knobs plus `include $(KONFIG)/Makefile`.
Every file these tools generate is buried under a `.../konfig/...`
directory — never your real dotfiles — so `make death` wipes the lot
and leaves your machine spotless.

```bash
# install and test-drive from any sibling gist
git clone https://github.com/aiez/konfig
git clone https://github.com/aiez/luamine luamine && cd luamine
make help
```

<img align="right" alt="image" src="https://gist.github.com/user-attachments/assets/41ed5d0c-c2dd-40a8-91ce-74223a19df96" />

**Sections:** [NAME](#name) | [SYNOPSIS](#synopsis) | [OPTIONS](#options) | [OUTPUT](#output) | [SEE ALSO](#see-also) | [LICENSE](#license) | [AUTHOR](#author)

**Files:** [Makefile](#file-makefile) | [bashrc](#file-bashrc) | [init.lua](#file-init-lua) | [init.el](#file-init-el) | [tmux.conf](#file-tmux-conf) | [micro.settings.json](#file-micro-settings-json) | [micro.bindings.json](#file-micro-bindings-json) | [micro.lisp.yaml](#file-micro-lisp-yaml) | [style_code.md](#file-style_code-md) | [style_gist.md](#file-style_gist-md) | [newgist.md](#file-newgist-md) | [make.md](#file-make-md) | [bash.md](#file-bash-md) | [nvim.md](#file-nvim-md) | [micro.md](#file-micro-md) | [tmux.md](#file-tmux-md) | [banner.sh](#file-banner-sh) | [help.awk](#file-help-awk) | [hist.awk](#file-hist-awk) | [install.sh](#file-install-sh) | [Brewfile](#file-brewfile)

## NAME

    konfig - shared Makefile + dotfiles for sibling gist repos

## SYNOPSIS

    # in a project repo's Makefile: knobs, guard, include
    KONFIG ?= ../konfig
    APP    := project
    ...
    include $(KONFIG)/Makefile

    make help|doctor|check|test|push|hist|sh|vi|mux|pdf|death

## OPTIONS

    Knobs a repo sets before the include (see style_gist.md):

      APP    project name (tmux socket, NVIM_APPNAME, banner)
      MAIN   primary source file        (code repos)
      EXT    source extension           (code repos)
      LANG   language name              (code repos)
      LINT   lint command               (code repos)
      TOOLS  tool:why pairs for doctor
      PKG    packages doctor suggests installing

    Tool tutorials: make.md, bash.md, nvim.md, micro.md, tmux.md.
    Style law for sibling gists: style_code.md, style_gist.md.
    Spinning up a new gist (tool or data): newgist.md.

## OUTPUT

    make help    banner + every `target: ## desc` line
    make doctor  tool checklist with install hints
    make sh      tuned bash    (banner, git prompt, vi-mode)
    make vi      isolated nvim (catppuccin + tree; --clean)
    make mux     private-socket tmux; `make claude` = 3 panes
    make pdf     a2ps pretty-print -> ~/tmp/konfig/*.pdf
    make death   wipe every generated .../konfig/ dir (2x confirm)

    Editors (aliases inside `make sh`): vi=nvim  m=micro.
    All state isolated under ~/.{cache,config,local}/konfig/ + ~/tmp/konfig
    — nothing touches your real dotfiles; `make death` erases it all.

## SEE ALSO

    luamine   https://github.com/aiez/luamine   Lua data mining
    optimiz   https://github.com/aiez/optimiz   example datasets
    fft       https://github.com/aiez/fft       FFTs + regression trees
    repltut   https://github.com/aiez/repltut   REPL tutorial prompts

## LICENSE

    MIT. https://choosealicense.com/licenses/mit/

## AUTHOR

    Tim Menzies <timm@ieee.org>
