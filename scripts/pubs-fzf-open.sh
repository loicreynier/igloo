#!/usr/bin/env sh

bib=$(pubs list --alphabetical "$@")
[ -z "$bib" ] && exit
sel=$(
  printf '%s\n' "$bib" |
    fzf -i --exact --reverse --height 40% |
    awk '{ print $1; }' |
    sed 's/\[//;s/\]//'
)
[ -n "$sel" ] && pubs doc open "$sel" || exit 0
