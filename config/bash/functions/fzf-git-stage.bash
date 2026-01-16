#!/usr/bin/env bash

# Homemade fzf-based interactive Git stage menu

if [[ -v HAS[fzf] && -v HAS[git] ]]; then
  :
elif ! command -v fzf >/dev/null 2>&1 ||
  ! command -v git >/dev/null 2>&1; then
  return 1
fi

if ! command -v difft >/dev/null 2>&1; then
  return 1
fi

function __fzf_git_stage() {
  if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "Error: Not in a Git repository."
    return 1
  fi

  local -r git_difft='GIT_EXTERNAL_DIFF="difft --color always --display inline" git diff'

  # `fzf --version` output example:
  #
  #     0.50.0 (v0.50.0)
  #
  local -r fzf_version=$(fzf --version | awk '{print $1;}')
  local -r fzf_version_req="0.49.0" # Required for `$FZF_PREVIEW_LABEL`
  if ! [[ "$(printf '%s\n' "$fzf_version_req" "$fzf_version" | sort -V | head -n1)" == "0.49.0" ]]; then
    echo "Error: 'fzf' version $fzf_version is not compatible."
    echo "Please upgrade to at least version 0.49.0."
    return 1
  fi

  local -r git_root="$(git rev-parse --show-toplevel)"

  # Use `git status --short` instead of `git diff --name-only` to get the path relative to root.
  #
  # `^[A-Z]` keeps the line starting with a capital letter, which corresponds to staged files:
  #
  #     MM ../staged/file
  #      M modified/file
  #     ?? ../../untracked/file
  #
  # shellcheck disable=SC2016 # Nothing to expand here, Awk will do it, single quotes are fine
  local -r git_staged_files='git status --short | awk "/^[A-Z]/{print \$NF}"'

  local -r git_unstaged_files="git ls-files \
    --modified \
    --deleted \
    --other \
    --exclude-standard \
    --deduplicate \
    $git_root"

  local -r fzf_prompt_add="Add > "
  local -r fzf_prompt_reset="Reset > "

  local -r fzf_header=$(
    printf "%s\n" \
      "Keybindings:" \
      "<CTRL-s> to switch between Add Mode and Reset mode" \
      "<CTRL-t> to switch between Status and Diff preview" \
      "<ALT-e>  to open files in the editor" \
      "<ALT-c>  to commit | <ALT-a> to append to the last commit"
  )

  local -r fzf_header_add=$(
    printf "%s\n" "$fzf_header" \
      "<ENTER>  to add files" \
      "<ALT-p>  to add patch" \
      " "
  )

  local -r fzf_header_reset=$(
    printf "%s\n" "$fzf_header" \
      "<ENTER>  to reset files" \
      "<ALT-x>  to reset and checkout files" \
      " "
  )

  local -r fzf_git_reset="git reset -- {+}"
  local -r fzf_enter_cmd="($git_unstaged_files | grep {} && git add {+}) || $fzf_git_reset"

  local -r fzf_preview_status="git -c color.ui=always status --short"
  local -r fzf_preview_status_label=" Status "

  local -r fzf_preview_diff="$git_difft -- \{}"
  local -r fzf_preview_diff_staged="$git_difft --staged -- \{}"
  local -r fzf_preview_diff_label=" Diff "
  local -r fzf_preview_diff_staged_label=" Diff (Staged) "
  local -r fzf_preview="
    if [[ \$FZF_PREVIEW_LABEL =~ \"$fzf_preview_status_label\" ]]; then
      if [[ \$FZF_PROMPT =~ \"$fzf_prompt_add\" ]]; then
        echo 'change-preview($fzf_preview_diff)+change-preview-label($fzf_preview_diff_label)'
      else
        echo 'change-preview($fzf_preview_diff_staged)+change-preview-label($fzf_preview_diff_staged_label)'
      fi
    else
      echo 'change-preview($fzf_preview_status)+change-preview-label($fzf_preview_status_label)'
    fi
  "

  # When switching:
  # - unbind `<ALT-p>` (add patch) in reset mode
  # - unbind `<ALT-x>` (reset and checkout) in add mode
  local -r fzf_mode="
    if [[ \$FZF_PROMPT =~ \"$fzf_prompt_add\" ]]; then
      echo -n 'change-prompt($fzf_prompt_reset)+reload($git_staged_files)+change-header($fzf_header_reset)'
      echo -n '+unbind(alt-p)+rebind(alt-x)'
      if ! [[ \$FZF_PREVIEW_LABEL =~ \"$fzf_preview_status_label\" ]]; then
        echo '+change-preview($fzf_preview_diff_staged)+change-preview-label($fzf_preview_diff_staged_label)'
      else
        echo
      fi
    else
      echo -n 'change-prompt($fzf_prompt_add)+reload($git_unstaged_files)+change-header($fzf_header_add)'
      echo -n '+rebind(alt-p)+unbind(alt-x)'
      if ! [[ \$FZF_PREVIEW_LABEL =~ \"$fzf_preview_status_label\" ]]; then
        echo '+change-preview($fzf_preview_diff)+change-preview-label($fzf_preview_diff_label)'
      else
        echo
      fi
    fi
  "

  # shellcheck disable=SC2016 # Expansion is done by `fzf`, single quotes are fine here
  eval "$git_unstaged_files" | fzf \
    --multi \
    --reverse \
    --no-sort \
    --height "100%" \
    --prompt="Add > " \
    --preview-label="$fzf_preview_status_label" \
    --preview="$fzf_preview_status" \
    --header "$fzf_header_add" \
    --header-first \
    --bind='start:unbind(alt-x)' \
    --bind="ctrl-t:transform:$fzf_preview" \
    --bind="ctrl-s:transform:$fzf_mode" \
    --bind="enter:execute($fzf_enter_cmd)" \
    --bind="enter:+reload([[ \$FZF_PROMPT =~ '$fzf_prompt_add' ]] && $git_unstaged_files || $git_staged_files)" \
    --bind="enter:+refresh-preview" \
    --bind='alt-p:execute(git add --patch {+})' \
    --bind="alt-p:+reload($git_unstaged_files)" \
    --bind="alt-x:execute($fzf_git_reset && git checkout {+})" \
    --bind="alt-x:+reload($git_staged_files)" \
    --bind='alt-c:execute(git commit)+abort' \
    --bind='alt-a:execute(git commit --amend)+abort' \
    --bind='alt-e:execute(${EDITOR:-vim} {+})'
}
