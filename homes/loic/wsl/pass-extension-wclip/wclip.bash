clip() {
  echo -n "$1" | clip.exe
}
cmd_show --clip "$@"
