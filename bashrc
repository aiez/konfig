# tuned interactive bash. source via: bash --rcfile bashrc -i
# env in: KONFIG (this dir), APP (NVIM_APPNAME), MAIN (py entry), BANNER (art)
set -o vi
export BASH_SILENCE_DEPRECATION_WARNING=1  # mute macOS "default shell is zsh" notice
export PATH="$HOME/.local/bin:$PATH"
# bat: groovy. Catppuccin Mocha matches banner purple/green. grid+rule decor.
export BAT_THEME="Catppuccin Mocha"
export BAT_STYLE="numbers,changes,header,grid,snip"
# do NOT source ~/.bashrc: PATH/env already inherited from the parent
# login shell. Sourcing it clobbers PS1 (PROMPT_COMMAND), the vi alias,
# and drags in the fossil banner.

# prompt: parent/cwd in cyan + git branch (yellow, * if dirty) + [histno]
__gp() {
  local b=$(git branch --show-current 2>/dev/null)
  [[ -z $b ]] && return
  [[ -n $(git status --porcelain 2>/dev/null) ]] && b="$b*"
  echo " $b"
}
__pw() { pwd | awk -F/ '{print $(NF-1)"/"$NF}'; }
PS1='\[\e[36m\]$(__pw)\[\e[33m\]$(__gp) \[\e[0m\][\!]\$ '

alias p="python3 -B ${MAIN:-main.py}" c="make check"
alias ll='ls -la' gs='git status -s' gd='git diff' gl='git log --oneline -20'
alias cat='bat --paging=never' less='bat'  # groovy syntax color
# vi: real file in $KONFIG. NVIM_APPNAME=konfig/nvim puts ALL nvim state
# (config/data/state/cache) under a konfig/ segment, never the real ~ nvim dirs.
alias vi="NVIM_APPNAME=konfig/nvim nvim --clean -u \"${KONFIG:-.}/init.lua\""
# e: emacs in terminal (-nw), -Q skips real ~/.emacs.d, --init-directory parks
# elpa/state under ~/.config/konfig/emacs (needs emacs 29+; like NVIM_APPNAME above).
alias e="emacs -nw -Q --init-directory \"$HOME/.config/konfig/emacs\" -l \"${KONFIG:-.}/init.el\""
# tmux: repo config (path baked now; KONFIG unset below). No recursion: bash
# won't re-expand the same word.
alias tmux="tmux -f \"${KONFIG:-.}/tmux.conf\""
# free C-s (save) from terminal XOFF flow-control, so micro/nvim can bind it.
stty -ixon 2>/dev/null
# m: simple micro. micro needs a config DIR but the gist is flat, so build the
# dir under ~/.config/konfig/micro at startup, symlinking the flat repo files in.
# plugins/themes micro downloads land there too -- never the real ~/.config/micro.
__md="$HOME/.config/konfig/micro"
mkdir -p "$__md/colorschemes" "$__md/syntax"
ln -sf "${KONFIG:-$PWD}/micro.settings.json"   "$__md/settings.json"
ln -sf "${KONFIG:-$PWD}/micro.bindings.json"   "$__md/bindings.json"
ln -sf "${KONFIG:-$PWD}/micro.lisp.yaml"       "$__md/syntax/lisp.yaml"
ln -sf "${KONFIG:-$PWD}/catppuccin-mocha.micro" "$__md/colorschemes/catppuccin-mocha.micro"
# plugins: install any missing into the isolated dir (first run only; needs net).
# tree=F5 sidebar, fzf=F6 fuzzy-open, aspell=F8 spell, detectindent=auto tabs.
for __p in filemanager fzf aspell detectindent; do
  [ -d "$__md/plug/$__p" ] || micro -config-dir "$__md" -plugin install "$__p" >/dev/null 2>&1
done
alias m="micro -config-dir \"$__md\""
unset __md __p

# graphic on top, colorful
[ -f "$BANNER" ] && bash "${KONFIG:-.}/banner.sh" "$BANNER"

# shortcuts under it
printf '\033[1;38;5;141m shortcuts  \033[0m'
for kv in "p:run" "c:check" "vi:edit" "e:emacs" "m:micro" "tmux:mux" "gs:status" "gd:diff" "gl:log" "ll:ls"; do
  printf '\033[38;5;84m%s\033[0m\033[38;5;245m=%s  \033[0m' "${kv%%:*}" "${kv##*:}"
done
printf '\n\n'

# per-repo overrides (sourced last so they win). silent if missing.
[ -f "$PWD/bashrc.local" ] && source "$PWD/bashrc.local"

# stop fossil leak: aliases + banner already consumed these. Don't let
# child shells / tmux / claude inherit stale paths from this session.
unset BANNER APP MAIN KONFIG
