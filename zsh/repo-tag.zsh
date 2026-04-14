# Tag the current directory's git repo with a color slot, stored in
# $_REPO_TAG. Consumed by the terminal-title functions in zshrc and matched
# on by niri window-rules to color the window border per repo.

typeset -g _REPO_TAG=""

function _repo_chpwd() {
  local root name slot sum c
  local slots=(peach teal mauve green sky rosewater yellow lavender)
  root=$(git rev-parse --show-superproject-working-tree 2>/dev/null)
  [[ -z "$root" ]] && root=$(git rev-parse --show-toplevel 2>/dev/null)
  if [[ -z "$root" ]]; then
    _REPO_TAG=""
    return
  fi
  name="${root:t}"
  sum=0
  for c in ${(s::)name}; do
    sum=$(( (sum * 31 + #c) & 0x7fffffff ))
  done
  slot="${slots[sum % 8 + 1]}"
  _REPO_TAG="repo-${slot}:${name} · "
}

_repo_chpwd
