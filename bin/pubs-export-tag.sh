#!/usr/bin/env sh

# Does not work with a Pubs location other than the default "`HOME/.pubs`.
# Could be improved by adding an option flag to specify the location,
# but I'll probably never use a different location.

if [ "$#" -ne 2 ]; then
  echo "Exactly two arguments are required: tag and output path." >&2
  echo "Usage: pubs export-tag <tag> <path>" >&2
  exit 1
fi

bib=$(pubs list "tags:$1" -k)

[ -z "$bib" ] && exit
for key in $bib; do
  cat "$HOME/.pubs/bib/$key.bib"
done >"$2"

echo "Tag '$1' bibliography exported to '$2'"
