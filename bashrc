# tuned interactive bash. source via: bash --rcfile bashrc -i
# env in: KONFIG (this dir), APP (NVIM_APPNAME), MAIN (py entry)
set -o vi
[ -f ~/.bashrc ] && source ~/.bashrc

alias p="python3 ${MAIN:-main.py}" c="make check"
alias ll='ls -la' gs='git status -s' \
      gd='git diff' gl='git log --oneline -20'

# vi: real file in $KONFIG, NVIM_APPNAME isolates plugin data
alias vi="NVIM_APPNAME=${APP:-nvim} nvim --clean -u \"${KONFIG:-.}/init.lua\""
