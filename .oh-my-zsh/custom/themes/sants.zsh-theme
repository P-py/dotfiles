# Sants Theme for oh-my-zsh
#
# Based on the "bureau" theme from oh-my-zsh
# Original theme: https://github.com/ohmyzsh/ohmyzsh/blob/master/themes/bureau.zsh-theme
#
# Modifications, refactors and visual changes by Sant | P-py | Pedro Salviano Santos
#
# License: MIT License

### Git [±master ▾●]

ZSH_THEME_GIT_PROMPT_PREFIX="[%{$fg_bold[green]%}±%{$reset_color%}%{$fg_bold[white]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}]"

ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%}✓%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg_bold[green]%}●%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNSTAGED="%{$fg_bold[yellow]%}●%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg_bold[red]%}●%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg[cyan]%}▴%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_BEHIND="%{$fg[magenta]%}▾%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_STASHED="%{$fg_bold[blue]%}✹%{$reset_color%}"

sants_git_info() {
  emulate -L zsh
  local ref

  ref=$(git symbolic-ref HEAD 2>/dev/null) \
    || ref=$(git rev-parse --short HEAD 2>/dev/null) \
    || return

  print -r -- "${ref#refs/heads/}"
}

sants_git_status() {
  emulate -L zsh
  local gitstatus result gitfiles gitbranch

  gitstatus="$(git status --porcelain -b 2>/dev/null)" || return
  gitfiles="${gitstatus#*$'\n'}"

  # File state (semantic order: dirty → clean)
  if [[ -n "$gitfiles" ]]; then
    [[ "$gitfiles" =~ $'(^|\n)[AMRD]. ' ]] && result+="$ZSH_THEME_GIT_PROMPT_STAGED"
    [[ "$gitfiles" =~ $'(^|\n).[MTD] ' ]] && result+="$ZSH_THEME_GIT_PROMPT_UNSTAGED"
    [[ "$gitfiles" =~ $'(^|\n)\\?\\? ' ]] && result+="$ZSH_THEME_GIT_PROMPT_UNTRACKED"
  else
    result+="$ZSH_THEME_GIT_PROMPT_CLEAN"
  fi

  # Branch sync state
  gitbranch="${gitstatus%%$'\n'*}"
  [[ "$gitbranch" =~ ahead ]]   && result+="$ZSH_THEME_GIT_PROMPT_AHEAD"
  [[ "$gitbranch" =~ behind ]]  && result+="$ZSH_THEME_GIT_PROMPT_BEHIND"

  # Stash (always last)
  git rev-parse --verify refs/stash &>/dev/null && result+="$ZSH_THEME_GIT_PROMPT_STASHED"

  print -r -- "$result"
}

typeset -g SANTS_GIT_CACHE=""
typeset -g SANTS_GIT_CACHE_DIR=""

sants_git_prompt_uncached() {
  git rev-parse --git-dir &>/dev/null || return
  [[ "$(git config --get oh-my-zsh.hide-info 2>/dev/null)" == 1 ]] && return

  local info git_status output
  info="$(sants_git_info)" || return
  git_status="$(sants_git_status)"

  output="${info:gs/%/%%}"
  [[ -n "$git_status" ]] && output+=" $git_status"

  print -r -- "${ZSH_THEME_GIT_PROMPT_PREFIX}${output}${ZSH_THEME_GIT_PROMPT_SUFFIX}"
}


sants_git_prompt() {
  local dir="$(pwd -P)"

  if [[ "$dir" != "$SANTS_GIT_CACHE_DIR" ]]; then
    SANTS_GIT_CACHE="$(sants_git_prompt_uncached)"
    SANTS_GIT_CACHE_DIR="$dir"
  fi

  print -r -- "$SANTS_GIT_CACHE"
}

_PATH="%{$fg_bold[blue]%}%~%{$reset_color%}"

if [[ $EUID -eq 0 ]]; then
  _USERNAME="%{$fg_bold[red]%}%n"
  _LIBERTY="%{$fg[red]%}#"
else
  _USERNAME="%{$fg_bold[magenta]%}%n"
  _LIBERTY="%{$fg[magenta]%}$"
fi
_USERNAME="$_USERNAME%{$reset_color%} @"
_LIBERTY="$_LIBERTY%{$reset_color%}"


get_space() {
  emulate -L zsh
  local STR="$1$2"
  local zero='%([BSUbfksu]|([FB]|){*})'
  local LENGTH=${#${(S%%)STR//$~zero/}}
  local SPACES=$(( COLUMNS - LENGTH - ${ZLE_RPROMPT_INDENT:-1} ))

  (( SPACES > 0 )) || return
  printf ' %.0s' {1..$SPACES}
}

_1LEFT="$_USERNAME $_PATH"
_1RIGHT="[%{$fg[blue]%}%*%{$reset_color%}]"

sants_precmd() {
  local spaces
  spaces="$(get_space "$_1LEFT" "$_1RIGHT")"

  print
  print -rP "$_1LEFT$spaces$_1RIGHT"
}

setopt prompt_subst
PROMPT='> $_LIBERTY '
RPROMPT='$(sants_git_prompt)'

autoload -U add-zsh-hook
add-zsh-hook -d precmd sants_precmd  # Remove if exists
add-zsh-hook precmd sants_precmd