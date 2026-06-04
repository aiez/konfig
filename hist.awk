# paragraph line-count histogram + cumulative %. comments stripped upstream.
# only paragraphs whose first line starts with def/function are counted,
# so module docstrings, data tables, inline strings don't inflate.
# run: cat src | grep -Ev '^[[:space:]]*(#)' | gawk -f hist.awk
BEGIN { RS = ""; FS = "\n" }
$1 ~ /^(def |function |local function )/ { d[NF]++; tot++ }
END {
  n = asorti(d, k, "@ind_num_asc"); all = 0
  for (i = 1; i <= n; i++) {
    all += d[k[i]]; s = ""
    for (j = 0; j < d[k[i]]; j++) s = s "#"
    printf "%3d %3d  %s\n", k[i], int(all * 100 / tot), s
  }
}
