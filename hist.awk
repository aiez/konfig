# paragraph line-count histogram + cumulative %. comments stripped upstream.
# run: cat src | grep -Ev '^[[:space:]]*(#)' | gawk -f hist.awk
BEGIN { RS = ""; FS = "\n" }
{ d[NF]++; tot++ }
END {
  n = asorti(d, k, "@ind_num_asc"); all = 0
  for (i = 1; i <= n; i++) {
    all += d[k[i]]; s = ""
    for (j = 0; j < d[k[i]]; j++) s = s "#"
    printf "%3d %3d  %s\n", k[i], int(all * 100 / tot), s
  }
}
