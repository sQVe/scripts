# Tag the current directory's git repo with a color slot, stored in
# $_REPO_TAG. Consumed by the terminal-title functions in zshrc and matched
# on by niri window-rules to color the window border per repo.
#
# Also tints the kitty background with a subtle shade of the same slot,
# fading smoothly between repos via OSC 11 escape codes (no kitten @ forks).

zmodload zsh/zselect 2>/dev/null

typeset -g _REPO_TAG=""
typeset -g _REPO_PREV_TINT="#d4d6de"
typeset -g _REPO_FADE_PID=0
typeset -g _REPO_LAST_ROOT=""

# 8% blend of each accent into the latte base (#d4d6de).
typeset -gA _REPO_TINTS=(
  pink      '#cfcad6'
  mauve     '#ccc8d9'
  red       '#d1c7d0'
  maroon    '#cfc8d2'
  peach     '#d0cbcf'
  yellow    '#cdcccd'
  green     '#c6cdcf'
  teal      '#c6cdd4'
  sky       '#c4ced9'
  blue      '#c6cbd9'
  lavender  '#cacbd9'
)

# Only tint when running inside a bare kitty session (not tmux-inside-kitty,
# where KITTY_WINDOW_ID leaks into tmux panes and repaints the wrong window).
function _repo_can_tint() {
  [[ -n "$KITTY_WINDOW_ID" && -z "$TMUX" && -z "$SSH_CONNECTION" ]]
}

# Push a background color directly via OSC 11. No fork, no socket.
function _repo_set_bg() {
  { printf '\e]11;%s\a' "$1" >/dev/tty; } 2>/dev/null
}

# Linear interpolation between two "#rrggbb" hex colors, t in [0..1000].
# Writes result to $REPLY to avoid a subshell.
function _repo_hex_lerp() {
  local from=${1#\#} to=${2#\#} t=$3
  local fr=$((16#${from:0:2})) fg=$((16#${from:2:2})) fb=$((16#${from:4:2}))
  local tr=$((16#${to:0:2})) tg=$((16#${to:2:2})) tb=$((16#${to:4:2}))
  printf -v REPLY '#%02x%02x%02x' \
    $(( fr + (tr - fr) * t / 1000 )) \
    $(( fg + (tg - fg) * t / 1000 )) \
    $(( fb + (tb - fb) * t / 1000 ))
}

# Fade kitty background from $1 to $2 over ~150ms with ease-out, 15 steps.
function _repo_fade_tint() {
  local from="$1" to="$2" steps=15 i t_lin t_eased
  for (( i=1; i<=steps; i++ )); do
    t_lin=$(( i * 1000 / steps ))
    # Ease-out: 1 - (1-t)^2.
    t_eased=$(( 1000 - ((1000 - t_lin) * (1000 - t_lin)) / 1000 ))
    _repo_hex_lerp "$from" "$to" $t_eased
    _repo_set_bg "$REPLY"
    zselect -t 1 2>/dev/null || sleep 0.015
  done
}

# Kill any in-flight fade and start a new one.
function _repo_start_fade() {
  local to="$1"
  if (( _REPO_FADE_PID )) && kill -0 $_REPO_FADE_PID 2>/dev/null; then
    kill $_REPO_FADE_PID 2>/dev/null
    # Rapid repo switches snap to the new target instead of fading: we don't
    # know the actual on-screen color (the killed fade was writing it), and
    # starting a new fade from a guessed color causes visible jumps. Snap is
    # the least-jarring option for back-to-back cd's.
    _repo_set_bg "$to"
    _REPO_PREV_TINT="$to"
    _REPO_FADE_PID=0
    return
  fi
  _repo_fade_tint "$_REPO_PREV_TINT" "$to" &!
  _REPO_FADE_PID=$!
  _REPO_PREV_TINT="$to"
}

function _repo_chpwd() {
  local root name slot sum dir git_is_file i
  local slots=(pink mauve red maroon peach yellow green teal sky blue lavender)

  # Walk up from PWD looking for .git — directory means main checkout,
  # regular file means worktree or submodule (contains "gitdir: ..."). No forks.
  dir="$PWD"
  git_is_file=0
  while [[ "$dir" != "/" && -n "$dir" ]]; do
    if [[ -d "$dir/.git" ]]; then
      root="$dir"
      break
    elif [[ -f "$dir/.git" ]]; then
      root="$dir"
      git_is_file=1
      break
    fi
    dir="${dir:h}"
  done

  # Fast path: same repo root as last time. Skip hash/slot/tint work. Note we
  # still had to do the walk above to catch nested repos (submodules, embedded
  # worktrees) where PWD is under the old root but a closer .git exists.
  if [[ -n "$root" && "$root" == "$_REPO_LAST_ROOT" ]]; then
    return
  fi

  if [[ -z "$root" ]]; then
    _REPO_TAG=""
    _REPO_LAST_ROOT=""
    if _repo_can_tint && [[ "$_REPO_PREV_TINT" != "#d4d6de" ]]; then
      _repo_start_fade "#d4d6de"
    fi
    return
  fi
  _REPO_LAST_ROOT="$root"

  # Worktree/submodule: include parent dir (platform/main vs platform/pr-123).
  name="${root:t}"
  if (( git_is_file )); then
    name="${root:h:t}/${name}"
  fi

  sum=0
  local c
  for (( i=1; i<=${#name}; i++ )); do
    c=${name[i]}
    sum=$(( (sum * 31 + #c) & 0x7fffffff ))
  done
  slot="${slots[sum % 11 + 1]}"
  _REPO_TAG="repo-${slot}:${name} · "

  local new_tint="${_REPO_TINTS[$slot]}"
  if _repo_can_tint && [[ "$new_tint" != "$_REPO_PREV_TINT" ]]; then
    _repo_start_fade "$new_tint"
  fi
}

# Reset kitty background on shell exit so the next shell in this window
# starts clean (OSC 111 resets to the config default).
function _repo_zshexit() {
  _repo_can_tint && { printf '\e]111\a' >/dev/tty; } 2>/dev/null
}
autoload -Uz add-zsh-hook
add-zsh-hook zshexit _repo_zshexit

_repo_chpwd
