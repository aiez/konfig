# tuned interactive bash. source via: bash --rcfile bashrc -i
# env in: KONFIG (this dir), APP (NVIM_APPNAME), MAIN (py entry), BANNER (art)
set -o vi
source ~/.bashrc >/dev/null 2>&1   # keep env/path, drop its banner+ghost

alias p="python3 -B ${MAIN:-main.py}" c="make check"
alias ll='ls -la' gs='git status -s' gd='git diff' gl='git log --oneline -20'
# vi: real file in $KONFIG, NVIM_APPNAME isolates plugin data
alias vi="NVIM_APPNAME=${APP:-nvim} nvim --clean -u \"${KONFIG:-.}/init.lua\""

# graphic on top, colorful
[ -f "$BANNER" ] && bash "${KONFIG:-.}/banner.sh" "$BANNER"

# shortcuts under it
printf '\033[1;38;5;141m shortcuts  \033[0m'
for kv in "p:run" "c:check" "vi:edit" "gs:status" "gd:diff" "gl:log" "ll:ls"; do
  printf '\033[38;5;84m%s\033[0m\033[38;5;245m=%s  \033[0m' "${kv%%:*}" "${kv##*:}"
done
printf '\n'
