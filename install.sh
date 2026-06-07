#!/usr/bin/env bash
# install.sh — set up this machine from konfig's Brewfile.
#   ./install.sh        install everything in ./Brewfile
#   ./install.sh dump   regenerate ./Brewfile from current brew state
#   ./install.sh check  list Brewfile entries not yet installed
# Brewfile lists only intentional installs (brew leaves + casks);
# dependencies resolve automatically.
set -euo pipefail
cd "$(dirname "$0")"

have() { command -v "$1" >/dev/null 2>&1; }

# homebrew: install if missing
if ! have brew; then
  echo "installing homebrew..."
  /bin/bash -c "$(curl -fsSL \
    https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # apple silicon puts brew in /opt/homebrew; add to this shell
  [ -x /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"
fi

case "${1:-install}" in
  dump)
    {
      echo "# Brewfile — konfig. regenerate: ./install.sh dump"
      echo "# install all: ./install.sh   (or: brew bundle)"
      echo
      brew tap                            | sed 's/^/tap "/;  s/$/"/'
      echo
      brew leaves --installed-on-request  | sed 's/^/brew "/; s/$/"/'
      echo
      brew list --cask                    | sed 's/^/cask "/; s/$/"/'
    } > Brewfile
    echo "wrote Brewfile ($(grep -c '^\(brew\|cask\) ' Brewfile) packages)"
    ;;
  check)
    brew bundle check --file=Brewfile --verbose || true
    ;;
  install)
    brew bundle install --file=Brewfile
    echo "done. shell/editor/tmux config: make sh | make vi | make mux"
    ;;
  *)
    echo "usage: ./install.sh [install|dump|check]" >&2
    exit 1
    ;;
esac
