#!/usr/bin/env sh

bib_dir="$HOME/.pubs/bib"

fd_bin="fd"
fzf_bin="fzf"
bat_bin="bat"

bib_files=$(cd "$bib_dir" && "$fd_bin" -t f -e bib . | "$fzf_bin" \
  --multi --delimiter ' ' \
  --height 40% \
  --layout reverse \
  --preview "$bat_bin --color=always {}" \
  --bind=alt-u:preview-page-up,alt-d:preview-page-down)

[ -z "$bib_files" ] && exit 0

for file in $bib_files; do
  cat "$bib_dir/$file"
  echo ""
done
