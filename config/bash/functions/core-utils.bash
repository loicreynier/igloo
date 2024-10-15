path() {
  # IFS = Internal Field Separator
  IFS=':'

  read -r -a path_array <<<"${1:-$PATH}"

  for element in "${path_array[@]}"; do
    echo "$element"
  done
}
