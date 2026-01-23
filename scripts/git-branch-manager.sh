#!/usr/bin/env sh

# Interactive Git branch manager written to test Gum features, nothing too serious

print_error() {
  printf '%s %s\n' "$(gum style --foreground 1 "Error:")" "$1"
}

if ! git rev-parse --git-dir >/dev/null 2>&1; then
  print_error "not in a Git repo"
  exit 1
fi

gum style --padding "1" \
  "$(gum style --foreground 2 ' Git') Branch Manager"

branches=$(
  git branch --format="%(refname:short)" |
    gum choose --no-limit --header="Choose branch(es):"
) || exit 0

[ -n "$branches" ] || {
  print_error "No branches selected"
  exit 1
}

command=$(gum choose --limit=1 --header="Choose a Git command:" update rebase delete) || exit 0

export GUM_SPIN_SHOW_OUTPUT=1
export GUM_SPIN_SHOW_ERROR=1

for branch in $branches; do
  case $command in
  update)
    gum spin --title "Updating '$branch'" -- sh -c "
      git checkout '$branch' && git pull --ff-only
    "
    ;;
  rebase)
    target=$(
      git branch --format="%(refname:short)" |
        gum choose --limit=1 --header="Choose rebase target:"
    ) || continue
    gum confirm "Rebase '$branch' onto '$target'?" || continue
    gum spin --title "Rebasing '$branch' into '$target'" -- sh -c "
      git checkout '$branch' && git rebase '$target'
    "
    ;;
  delete)
    gum confirm "Delete branch '$branch'?" || continue
    gum spin --title "Deleting '$branch'" -- git branch -d "$branch"
    ;;
  esac
done
