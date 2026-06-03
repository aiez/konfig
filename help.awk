# self-doc for Makefiles. run: gawk -f help.awk $(MAKEFILE_LIST)
# targets  = lines like `name: ## description`
# defaults = lines like `VAR ?= value # description`
/^[~a-zA-Z0-9_%.\/ -]+:.*?##/ {
  split($0, a, ":.*?##")
  t[++tn] = sprintf("  \033[36m%-20s\033[0m %s", a[1], a[2])
}
match($0, /^([A-Za-z][A-Za-z0-9]*)[ \t]*\?=[ \t]*([^#]*[^# \t])[ \t]*#[ \t]*(.+)/, m) {
  d[++dn] = sprintf("  \033[36m%-8s\033[0m = %-30s %s", m[1], m[2], m[3])
}
END {
  printf "\nUsage:\n  make \033[36m<target>\033[0m [VAR=val ...]\n\ntargets:\n"
  n = asort(t); for (i = 1; i <= n; i++) print t[i]
  if (dn) {
    printf "\ndefaults:\n"
    n = asort(d); for (i = 1; i <= n; i++) print d[i]
  }
}
