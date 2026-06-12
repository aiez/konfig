#!/usr/bin/env bash
# _commit2.sh — finish rename: push with explicit upstream.
# Run: bash ~/gists/konfig/_commit2.sh
set -e
G=$HOME/gists

doit() { # $1=repo $2=msg
  cd "$G/$1"
  [ -n "$(git status --porcelain)" ] \
    && git add -A && { git commit -m "$2" || true; }
  git push -u origin main
  echo "$1: ok"
}

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
rm -rf "$G/konfig/_rename" "$G/konfig/_commit.sh" \
       "$G/konfig/_commit2.sh"
echo DONE
