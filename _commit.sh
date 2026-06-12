#!/usr/bin/env bash
# _commit.sh — finish/commit the kah+luamine rename everywhere.
# Idempotent: skips clean repos. Run: bash ~/gists/konfig/_commit.sh
set -e
G=$HOME/gists

doit() { # $1=repo $2=msg
  cd "$G/$1" || return 0
  if [ -n "$(git status --porcelain)" ]; then
    git add -A && git commit -m "$2" && git push
  else
    git push 2>/dev/null || true
    echo "$1: clean"
  fi
}

rm -rf "$G/konfig/_rename"
doit kah     "rename tumm->kah; rockspec 1.0.0-1"
doit luamine "rename lull->luamine; rockspec 2.0.0-1"
doit regress "see-also: lull->luamine"
doit klassif "see-also: lull->luamine"
doit optimiz "see-also: lull->luamine"
doit konfig  "kah/luamine renames in docs"

gh gist edit 4990faa5b0ddc9b1db2e17ce310b205e \
  --desc "kah: useful short lua functions. http://tiny.cc/kah-lua" \
  </dev/null || true
gh gist edit d2f6e74750271fc68a215d1967d34c29 \
  --desc "LUAMINE = LUA MINing Engines. http://tiny.cc/luamine" \
  </dev/null || true

echo "== fossil sweep (files still mentioning tumm/lull):"
grep -rliE 'tumm|lull' "$G" --exclude-dir=.git || echo "  none"
rm -f "$G/konfig/_commit.sh"
echo DONE
