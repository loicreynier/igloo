# Allow tabs for Bash Here Documents (`<<-EOF ...`)
# vim: set ts=2 sts=2 sw=2 noexpandtab:
# editorconfig-checker-disable-file

if ! command -v fzf >/dev/null 2>&1 ||
  ! command -v git >/dev/null 2>&1; then
  return 1
fi

function __fzf_git_stage() {
  local -r fzf_bin="fzf"
  local -r difft_bin="difft"

  if ! command -v $fzf_bin &>/dev/null; then
    echo "Error: '$fzf_bin'" is not installed
    return 1
  fi

  # `fzf --version` output example:
  #
  #     0.50.0 (0.50.0)
  #
  local -r fzf_version=$(fzf --version | awk '{print $1;}')
  local -r fzf_version_req="0.49.0" # Required for `$FZF_PREVIEW_LABEL`
  if ! [[ "$(printf '%s\n' "$fzf_version_req" "$fzf_version" | sort -V | head -n1)" == "0.49.0" ]]; then
    echo "Error: '$fzf_bin' version $fzf_version is not compatible."
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
    cat <<-EOF
		> <CTRL-s> to switch between Add Mode and Reset mode
		> <CTRL-t> to switch between Status and Diff preview
		> <ALT-e> to open files in the editor
		> <ALT-c> to commit | <ALT-a> to append to the last commit
		EOF
  )

  local -r fzf_add_header=$(
    cat <<-EOF
		$fzf_header
		> <ENTER> to add files
		> ALT-P to add patch
		EOF
  )

  local -r fzf_reset_header=$(
    cat <<-EOF
		$fzf_header
		> <ENTER> to reset files
		> <ALT-x> to reset and checkout files
		EOF
  )

  local -r fzf_git_reset="git reset -- {+}"
  local -r fzf_enter_cmd="($git_unstaged_files | grep {} && git add {+}) || $fzf_git_reset"

  local -r fzf_preview_status="git -c color.ui=always status --short"
  local -r fzf_preview_status_label=" Status "

  # TODO: make it work for staged files
  local -r fzf_preview_diff="GIT_EXTERNAL_DIFF=\"$difft_bin --color always\" git diff -- \{}"
  local -r fzf_preview_diff_label=" Diff "

  # Unbind `<ALT-p>` (add patch) in reset mode
  local -r fzf_mode_reset="change-prompt($fzf_prompt_reset)+reload($git_staged_files)+change-header($fzf_reset_header)+unbind(alt-p)+rebind(alt-x)"

  # Unbind `<ALT-x>` (reset and checkout) in add mode
  local -r fzf_mode_add="change-prompt($fzf_prompt_add)+reload($git_unstaged_files)+change-header($fzf_add_header)+rebind(alt-p)+unbind(alt-x)"

  # shellcheck disable=SC2016 # Expansion is done by `fzf`, single quotes are fine here
  eval "$git_unstaged_files" | $fzf_bin \
    --multi \
    --reverse \
    --no-sort \
    --height=40% \
    --prompt="Add > " \
    --preview-label="$fzf_preview_status_label" \
    --preview="$fzf_preview_status" \
    --header "$fzf_add_header" \
    --header-first \
    --bind='start:unbind(alt-x)' \
    --bind="ctrl-t:transform:[[ \$FZF_PREVIEW_LABEL =~ '$fzf_preview_status_label' ]] \
    && echo 'change-preview($fzf_preview_diff)+change-preview-label($fzf_preview_diff_label)' \
    || echo 'change-preview($fzf_preview_status)+change-preview-label($fzf_preview_status_label)'" \
    --bind="ctrl-s:transform:[[ \$FZF_PROMPT =~ '$fzf_prompt_add' ]] \
    && echo '$fzf_mode_reset' || echo '$fzf_mode_add'" \
    --bind="enter:execute($fzf_enter_cmd)" \
    --bind="enter:+reload([[ \$FZF_PROMPT =~ '$fzf_prompt_add' ]] && $git_unstaged_files || $git_staged_files)" \
    --bind="enter:+refresh-preview" \
    --bind='alt-p:execute(git add --patch {+})' \
    --bind="alt-p:+reload($git_unstaged_files)" \
    --bind="alt-x:execute($fzf_git_reset && git checkout {+})" \
    --bind="alt-x:+reload($git_staged_files)" \
    --bind='alt-c:execute(git commit)+abort' \
    --bind='alt-a:execute(git commit --amend)+abort' \
    --bind='alt-e:execute(${EDITOR:-vim} {+})' \
    --bind='f1:toggle-header' \
    --bind='f2:toggle-preview' \
    --bind='alt-u:preview-page-up' \
    --bind='alt-d:preview-page-down'
}
