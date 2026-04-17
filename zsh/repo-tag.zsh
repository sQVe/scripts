# Tag the current directory's git repo with a color slot, stored in
# $_REPO_TAG. Consumed by the terminal-title functions in zshrc and matched
# on by niri window-rules to color the window border per repo.
#
# Also tints the kitty background with a subtle shade of the same slot,
# fading smoothly between repos via OSC 11 escape codes (no kitten @ forks).
#
# Slot resolution:
#   1. This shell already claimed a slot for this repo  -> reuse it.
#   2. Another live shell holds a slot for the same repo -> join it.
#   3. User preferences pin this repo to a slot          -> take if free.
#   4. Hash slot (deterministic default)                 -> take if free.
#   5. Linear probe through the perceptually-ordered     -> first free wins.
#      slot ring starting after the hash slot
#   6. All 11 live-claimed                               -> accept collision.

zmodload zsh/zselect 2>/dev/null
zmodload zsh/datetime 2>/dev/null
zmodload zsh/stat 2>/dev/null
zmodload zsh/system 2>/dev/null   # zsystem flock (no fork, vs external flock)
zmodload -F zsh/files b:mv b:mkdir 2>/dev/null  # builtin mv/mkdir (no fork)

typeset -g _REPO_TAG=""
typeset -g _REPO_PREV_TINT="#d6d6d6"
typeset -g _REPO_FADE_PID=0
typeset -g _REPO_LAST_ROOT=""
typeset -g _REPO_LAST_KEY=""
typeset -g _REPO_HAS_CLAIM=0

# Slot order is perceptual: adjacent entries have high CIE Lab ΔE. This makes
# linear +1 probing land on a visually distant color on every step, so hash
# collisions don't produce near-duplicate pairs.
typeset -ga _REPO_SLOTS=(pink teal yellow blue green mauve peach sky maroon lavender red)

# Barely-there washes of base (#d6d6d6), generated in OKLCh at C=0.015,
# L≈0.877 (matching base lightness) with ±0.012 L nudges to separate
# hue-adjacent pairs like teal/green and sky/blue. Verified with ΔE2000
# (not ΔE76, which is badly non-uniform near neutral): ring-adjacent min
# ≈ 2.5 (just above JND), vs-base = 1.6-9.5 — reads as gray with only the
# faintest hint of hue; some tints are nearly indistinguishable from base
# in isolation, but the probe ring ensures any two adjacent windows differ.
typeset -gA _REPO_TINTS=(
  pink      '#dfd3d6'
  mauve     '#dad2db'
  red       '#dfd1cf'
  maroon    '#dccfd0'
  peach     '#e2d7d1'
  yellow    '#dfdcd1'
  green     '#cdd6ce'
  teal      '#cedbda'
  sky       '#d0dde1'
  blue      '#cfd5df'
  lavender  '#d6d7e2'
)

# Shared-state paths.
typeset -g _REPO_DIR="${XDG_RUNTIME_DIR:-/tmp/repo-tag-$UID}/repo-tag"
typeset -g _REPO_CLAIMS="$_REPO_DIR/claims"
typeset -g _REPO_LOCK="$_REPO_DIR/claims.lock"
typeset -g _REPO_PINS_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/repo-tag/pins"
mkdir -p "$_REPO_DIR" 2>/dev/null
# zsystem flock needs the lockfile to exist; it won't create one.
# Grouped so a redirection-open failure (e.g. $_REPO_DIR missing) is suppressed;
# `: >> file 2>/dev/null` alone lets zsh still print the open error.
{ : >> "$_REPO_LOCK" } 2>/dev/null

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

# Fade kitty background from $1 to $2 over ~220ms with ease-out, 15 steps.
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
    _repo_set_bg "$to"
    _REPO_PREV_TINT="$to"
    _REPO_FADE_PID=0
    return
  fi
  _repo_fade_tint "$_REPO_PREV_TINT" "$to" &!
  _REPO_FADE_PID=$!
  _REPO_PREV_TINT="$to"
}

# Load preferences file into _REPO_PINS. Cached by mtime: re-reads only when
# the file changes, so edits take effect without resourcing. Invalid slot
# names are ignored.
typeset -gA _REPO_PINS
typeset -g _REPO_PINS_MTIME=-1
function _repo_load_pins() {
  if [[ ! -r "$_REPO_PINS_FILE" ]]; then
    (( _REPO_PINS_MTIME == 0 )) && return
    _REPO_PINS=()
    _REPO_PINS_MTIME=0
    return
  fi
  local -a st
  zstat -A st +mtime "$_REPO_PINS_FILE" 2>/dev/null
  local mtime=${st[1]:-0}
  (( mtime == _REPO_PINS_MTIME )) && return
  _REPO_PINS_MTIME=$mtime
  _REPO_PINS=()
  local key slot valid=" ${_REPO_SLOTS[*]} "
  while read -r key slot; do
    [[ -z "$key" || "$key" == '#'* ]] && continue
    [[ -z "$slot" ]] && continue
    if [[ "$valid" == *" $slot "* ]]; then
      _REPO_PINS[$key]="$slot"
    fi
  done < "$_REPO_PINS_FILE"
}

# Resolve a slot for $1=repo_key with hash fallback $2. Acquires the shared
# flock, sweeps dead PIDs, rewrites the claims file with our new line, writes
# the chosen slot to $REPLY.
function _repo_acquire() {
  local repo_key="$1" hash_slot="$2"
  local lock_fd p s r e i j
  local -a claim_lines claim_slots claim_repos
  local -A repo_by_slot

  if ! zsystem flock -f lock_fd -t 1 "$_REPO_LOCK" 2>/dev/null; then
    # Can't safely touch claims without the lock, but a pin is a pure
    # function of repo_key — honor it so collisions stay resolved.
    REPLY="${_REPO_PINS[$repo_key]:-$hash_slot}"
    return
  fi

  # Sweep dead PIDs, drop our own old line, index the rest.
  if [[ -r "$_REPO_CLAIMS" ]]; then
    while IFS=$'\t' read -r p s r e; do
      [[ -z "$p" || "$p" == "$$" ]] && continue
      kill -0 "$p" 2>/dev/null || continue
      claim_lines+=("$p	$s	$r	$e")
      claim_slots+=("$s")
      claim_repos+=("$r")
      repo_by_slot[$s]="$r"
    done < "$_REPO_CLAIMS"
  fi

  # Rule 2: another live shell holds this repo -> join its slot.
  local resolved=""
  for (( j=1; j<=${#claim_repos}; j++ )); do
    if [[ "${claim_repos[j]}" == "$repo_key" ]]; then
      resolved="${claim_slots[j]}"
      break
    fi
  done

  if [[ -z "$resolved" ]]; then
    # Rules 3-5: pin -> hash -> linear probe after hash index.
    local pin_slot="${_REPO_PINS[$repo_key]}"
    local -a candidates
    [[ -n "$pin_slot" ]] && candidates=("$pin_slot")
    candidates+=("$hash_slot")
    local hash_idx=1 n=${#_REPO_SLOTS}
    for (( i=1; i<=n; i++ )); do
      [[ "${_REPO_SLOTS[i]}" == "$hash_slot" ]] && { hash_idx=$i; break }
    done
    for (( i=1; i<n; i++ )); do
      candidates+=("${_REPO_SLOTS[(( (hash_idx + i - 1) % n + 1 ))]}")
    done
    local cand holder
    for cand in "${candidates[@]}"; do
      holder="${repo_by_slot[$cand]}"
      if [[ -z "$holder" || "$holder" == "$repo_key" ]]; then
        resolved="$cand"
        break
      fi
    done
    [[ -z "$resolved" ]] && resolved="$hash_slot"  # Rule 6: all 11 live.
  fi

  # Write file atomically: surviving lines + our new claim.
  {
    for (( i=1; i<=${#claim_lines}; i++ )); do
      print -r -- "${claim_lines[i]}"
    done
    print -r -- "$$	$resolved	$repo_key	$EPOCHSECONDS"
  } >| "$_REPO_CLAIMS.tmp.$$"
  mv -f "$_REPO_CLAIMS.tmp.$$" "$_REPO_CLAIMS" 2>/dev/null

  exec {lock_fd}>&-
  _REPO_HAS_CLAIM=1
  REPLY="$resolved"
}

# Remove our PID's line from the claims file (called on zshexit and when
# leaving a repo).
function _repo_release() {
  (( _REPO_HAS_CLAIM )) || return
  [[ -r "$_REPO_CLAIMS" ]] || { _REPO_HAS_CLAIM=0; return }
  local lock_fd p s r e
  if ! zsystem flock -f lock_fd -t 1 "$_REPO_LOCK" 2>/dev/null; then
    return
  fi
  {
    while IFS=$'\t' read -r p s r e; do
      [[ -z "$p" || "$p" == "$$" ]] && continue
      print -r -- "$p	$s	$r	$e"
    done < "$_REPO_CLAIMS"
  } >|"$_REPO_CLAIMS.tmp.$$" 2>/dev/null
  mv -f "$_REPO_CLAIMS.tmp.$$" "$_REPO_CLAIMS" 2>/dev/null
  exec {lock_fd}>&-
  _REPO_HAS_CLAIM=0
}

function _repo_chpwd() {
  local root name slot sum dir git_is_file i c gitdir

  # Walk up from PWD looking for .git — directory means main checkout,
  # regular file means worktree or submodule.
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

  # For bare-worktree layouts (project/.bare + project/<branch> worktrees),
  # resolve the worktree back to its project dir so all worktrees of the
  # same repo share a color. Non-bare worktrees fall through with their
  # own dir as the identity.
  if [[ -n "$root" && $git_is_file -eq 1 ]]; then
    gitdir="$(< "$root/.git")"
    gitdir="${gitdir#gitdir: }"
    [[ "$gitdir" != /* ]] && gitdir="$root/$gitdir"
    gitdir="${gitdir:a}"  # collapse any ../ segments.
    if [[ "$gitdir" == */.bare* ]]; then
      root="${gitdir%%/.bare*}"
      git_is_file=0
    fi
  fi

  # Fast path: still in the same repo root. Nothing changes.
  if [[ -n "$root" && "$root" == "$_REPO_LAST_ROOT" ]]; then
    return
  fi

  if [[ -z "$root" ]]; then
    # Left the repo entirely. Release any claim this shell holds.
    [[ -n "$_REPO_LAST_KEY" ]] && _repo_release
    _REPO_TAG=""
    _REPO_LAST_ROOT=""
    _REPO_LAST_KEY=""
    if _repo_can_tint && [[ "$_REPO_PREV_TINT" != "#d6d6d6" ]]; then
      _repo_start_fade "#d6d6d6"
    fi
    return
  fi
  _REPO_LAST_ROOT="$root"

  # Key = basename of the project dir. For bare-worktree layouts the code
  # above has already resolved root to the project dir. Non-bare worktrees
  # (rare) keep their own dir basename, matching the old behavior.
  name="${root:t}"
  if (( git_is_file )); then
    name="${root:h:t}/${name}"
  fi
  _REPO_LAST_KEY="$name"

  # Hash the name with a polynomial rolling hash over char codes.
  sum=0
  for (( i=1; i<=${#name}; i++ )); do
    c=${name[i]}
    sum=$(( (sum * 31 + #c) & 0x7fffffff ))
  done
  local hash_slot="${_REPO_SLOTS[sum % ${#_REPO_SLOTS} + 1]}"

  _repo_load_pins
  _repo_acquire "$name" "$hash_slot"
  slot="$REPLY"
  _REPO_TAG="${name} · "

  local new_tint="${_REPO_TINTS[$slot]}"
  if _repo_can_tint && [[ "$new_tint" != "$_REPO_PREV_TINT" ]]; then
    _repo_start_fade "$new_tint"
  fi
}

# Reset kitty background and release our claim on shell exit.
function _repo_zshexit() {
  _repo_release
  _repo_can_tint && { printf '\e]111\a' >/dev/tty; } 2>/dev/null
}
# External programs (yazi, vim, etc.) often repaint the terminal background
# and don't restore it on exit. Track when a command ran and re-assert our
# tint on the next prompt.
typeset -g _REPO_NEEDS_REASSERT=0
function _repo_preexec() { _REPO_NEEDS_REASSERT=1 }
function _repo_precmd() {
  (( _REPO_NEEDS_REASSERT )) || return
  _REPO_NEEDS_REASSERT=0
  _repo_can_tint || return
  (( _REPO_FADE_PID )) && kill -0 $_REPO_FADE_PID 2>/dev/null && return
  _repo_set_bg "$_REPO_PREV_TINT"
}

autoload -Uz add-zsh-hook
add-zsh-hook zshexit _repo_zshexit
add-zsh-hook preexec _repo_preexec
add-zsh-hook precmd _repo_precmd

_repo_chpwd
