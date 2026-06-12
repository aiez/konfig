# bash.md — bash, as konfig tunes it

Konfig's `bashrc` is not your login shell. It layers a tuned
*interactive* shell on top of it, started per-repo via `make sh`
(which runs `bash --rcfile $(KONFIG)/bashrc -i`).

## start it

    make sh          # from any gist repo

You get: banner art, prompt with git branch, vi-mode line editing,
short aliases. Exit with `exit` or ctrl-d; you fall back to your
normal shell.

## the prompt

    konfig/src main* [42]$

    parent/cwd      cyan; last two path parts only
    main            git branch, yellow; '*' = dirty tree
    [42]            bash history number (recall: !42)

## line editing is vi-mode

`set -o vi`. ESC then h/j/k/l, `b w e`, `0 $`, `dd`, `cw`...
ESC-k walks history; `/text` searches it. INSERT mode is default,
so typing works normally until you hit ESC.

## aliases

    p     python3 -B $MAIN     run the repo entry point
    c     make check           lint
    vi    nvim --clean -u $KONFIG/init.lua   (isolated per APP)
    tmux  tmux -f $KONFIG/tmux.conf
    gs    git status -s
    gd    git diff
    gl    git log --oneline -20
    ll    ls -la
    cat   bat --paging=never   syntax-colored cat
    less  bat

## history tricks

    !42        rerun history line 42 (the [42] in the prompt)
    !!         rerun last command
    !$         last word of last command
    ctrl-r     (in insert mode) is replaced by ESC /text in vi-mode

## per-repo overrides

Put repo-specific aliases in `bashrc.local` next to the Makefile;
it is sourced *last*, so it wins:

    # bashrc.local
    alias r='lua lull.lua --all'

Silent if missing. Never edit konfig's bashrc for one repo.

## why not source ~/.bashrc?

PATH and env are already inherited from the parent login shell.
Re-sourcing would clobber the prompt, the vi alias, and the banner.
KONFIG/APP/MAIN/BANNER are consumed then `unset` so child shells
(tmux, claude) don't inherit stale paths.
