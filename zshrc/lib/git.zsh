# Outputs current branch info in prompt format
function git_prompt_info() {
  local ref
  ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
  ref=$(command git rev-parse --short HEAD 2> /dev/null) || return 0
  echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

function parse_git_branch() {
	BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
	if [ ! "${BRANCH}" == "" ]
	then
		STAT=`parse_git_dirty`
		echo "[${BRANCH}${STAT}]"
	else
		echo ""
	fi
}

# Get current status of git repo
function parse_git_dirty {
	status=`git status 2>&1 | tee`
	dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
	untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
	ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
	newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
	renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
	deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
	bits=''
	if [ "${renamed}" == "0" ]; then
		bits=">${bits}"
	fi
	if [ "${ahead}" == "0" ]; then
		bits="*${bits}"
	fi
	if [ "${newfile}" == "0" ]; then
		bits="+${bits}"
	fi
	if [ "${untracked}" == "0" ]; then
		bits="?${bits}"
	fi
	if [ "${deleted}" == "0" ]; then
		bits="x${bits}"
	fi
	if [ "${dirty}" == "0" ]; then
		bits="!${bits}"
	fi
	if [ ! "${bits}" == "" ]; then
		echo " ${bits}"
	else
		echo ""
	fi
}

## Checks if working tree is dirty
#function parse_git_dirty() {
#  local STATUS
#  local -a FLAGS
#  FLAGS=('--porcelain' '--ignore-submodules=dirty' '--untracked-files=no')
#  STATUS=$(command git status ${FLAGS} 2> /dev/null | tail -n1)
#  if [[ -n $STATUS ]]; then
#    echo "$ZSH_THEME_GIT_PROMPT_DIRTY"
#  else
#    echo "$ZSH_THEME_GIT_PROMPT_CLEAN"
#  fi
#}
#
## Gets the difference between the local and remote branches
#function git_remote_status() {
#    local remote ahead behind git_remote_status git_remote_status_detailed
#    remote=${$(command git rev-parse --verify ${hook_com[branch]}@{upstream} --symbolic-full-name 2>/dev/null)/refs\/remotes\/}
#    if [[ -n ${remote} ]]; then
#        ahead=$(command git rev-list ${hook_com[branch]}@{upstream}..HEAD 2>/dev/null | wc -l)
#        behind=$(command git rev-list HEAD..${hook_com[branch]}@{upstream} 2>/dev/null | wc -l)
#
#        if [[ $ahead -eq 0 ]] && [[ $behind -eq 0 ]]; then
#            git_remote_status="$ZSH_THEME_GIT_PROMPT_EQUAL_REMOTE"
#        elif [[ $ahead -gt 0 ]] && [[ $behind -eq 0 ]]; then
#            git_remote_status="$ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE"
#            git_remote_status_detailed="$ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE_COLOR$ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE$((ahead))%{$reset_color%}"
#        elif [[ $behind -gt 0 ]] && [[ $ahead -eq 0 ]]; then
#            git_remote_status="$ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE"
#            git_remote_status_detailed="$ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE_COLOR$ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE$((behind))%{$reset_color%}"
#        elif [[ $ahead -gt 0 ]] && [[ $behind -gt 0 ]]; then
#            git_remote_status="$ZSH_THEME_GIT_PROMPT_DIVERGED_REMOTE"
#            git_remote_status_detailed="$ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE_COLOR$ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE$((ahead))%{$reset_color%}$ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE_COLOR$ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE$((behind))%{$reset_color%}"
#        fi
#
#        if [[ -n $ZSH_THEME_GIT_PROMPT_REMOTE_STATUS_DETAILED ]]; then
#            git_remote_status="$ZSH_THEME_GIT_PROMPT_REMOTE_STATUS_PREFIX$remote$git_remote_status_detailed$ZSH_THEME_GIT_PROMPT_REMOTE_STATUS_SUFFIX"
#        fi
#
#        echo $git_remote_status
#    fi
#}
#
## Outputs the name of the current branch
## Usage example: git pull origin $(git_current_branch)
## Using '--quiet' with 'symbolic-ref' will not cause a fatal error (128) if
## it's not a symbolic ref, but in a Git repo.
#function git_current_branch() {
#  local ref
#  ref=$(command git symbolic-ref --quiet HEAD 2> /dev/null)
#  local ret=$?
#  if [[ $ret != 0 ]]; then
#    [[ $ret == 128 ]] && return  # no git repo.
#    ref=$(command git rev-parse --short HEAD 2> /dev/null) || return
#  fi
#  echo ${ref#refs/heads/}
#}
#
#
## Gets the number of commits ahead from remote
#function git_commits_ahead() {
#  if command git rev-parse --git-dir &>/dev/null; then
#    local commits="$(git rev-list --count @{upstream}..HEAD 2>/dev/null)"
#    if [[ -n "$commits" && "$commits" != 0 ]]; then
#      echo "$ZSH_THEME_GIT_COMMITS_AHEAD_PREFIX$commits$ZSH_THEME_GIT_COMMITS_AHEAD_SUFFIX"
#    fi
#  fi
#}
#
## Gets the number of commits behind remote
#function git_commits_behind() {
#  if command git rev-parse --git-dir &>/dev/null; then
#    local commits="$(git rev-list --count HEAD..@{upstream} 2>/dev/null)"
#    if [[ -n "$commits" && "$commits" != 0 ]]; then
#      echo "$ZSH_THEME_GIT_COMMITS_BEHIND_PREFIX$commits$ZSH_THEME_GIT_COMMITS_BEHIND_SUFFIX"
#    fi
#  fi
#}
#
## Outputs if current branch is ahead of remote
#function git_prompt_ahead() {
#  if [[ -n "$(command git rev-list origin/$(git_current_branch)..HEAD 2> /dev/null)" ]]; then
#    echo "$ZSH_THEME_GIT_PROMPT_AHEAD"
#  fi
#}
#
## Outputs if current branch is behind remote
#function git_prompt_behind() {
#  if [[ -n "$(command git rev-list HEAD..origin/$(git_current_branch) 2> /dev/null)" ]]; then
#    echo "$ZSH_THEME_GIT_PROMPT_BEHIND"
#  fi
#}
#
## Outputs if current branch exists on remote or not
#function git_prompt_remote() {
#  if [[ -n "$(command git show-ref origin/$(git_current_branch) 2> /dev/null)" ]]; then
#    echo "$ZSH_THEME_GIT_PROMPT_REMOTE_EXISTS"
#  else
#    echo "$ZSH_THEME_GIT_PROMPT_REMOTE_MISSING"
#  fi
#}
#
## Formats prompt string for current git commit short SHA
#function git_prompt_short_sha() {
#  local SHA
#  SHA=$(command git rev-parse --short HEAD 2> /dev/null) && echo "$ZSH_THEME_GIT_PROMPT_SHA_BEFORE$SHA$ZSH_THEME_GIT_PROMPT_SHA_AFTER"
#}
#
## Formats prompt string for current git commit long SHA
#function git_prompt_long_sha() {
#  local SHA
#  SHA=$(command git rev-parse HEAD 2> /dev/null) && echo "$ZSH_THEME_GIT_PROMPT_SHA_BEFORE$SHA$ZSH_THEME_GIT_PROMPT_SHA_AFTER"
#}
#
## Get the status of the working tree
#function git_prompt_status() {
#  local INDEX STATUS
#  INDEX=$(command git status --porcelain -b 2> /dev/null)
#  STATUS=""
#  if $(echo "$INDEX" | command grep -E '^\?\? ' &> /dev/null); then
#    STATUS="$ZSH_THEME_GIT_PROMPT_UNTRACKED$STATUS"
#  fi
#  if $(echo "$INDEX" | grep '^A  ' &> /dev/null); then
#    STATUS="$ZSH_THEME_GIT_PROMPT_ADDED$STATUS"
#  elif $(echo "$INDEX" | grep '^M  ' &> /dev/null); then
#    STATUS="$ZSH_THEME_GIT_PROMPT_ADDED$STATUS"
#  elif $(echo "$INDEX" | grep '^MM ' &> /dev/null); then
#    STATUS="$ZSH_THEME_GIT_PROMPT_ADDED$STATUS"
#  fi
#  if $(echo "$INDEX" | grep '^ M ' &> /dev/null); then
#    STATUS="$ZSH_THEME_GIT_PROMPT_MODIFIED$STATUS"
#  elif $(echo "$INDEX" | grep '^AM ' &> /dev/null); then
#    STATUS="$ZSH_THEME_GIT_PROMPT_MODIFIED$STATUS"
#  elif $(echo "$INDEX" | grep '^MM ' &> /dev/null); then
#    STATUS="$ZSH_THEME_GIT_PROMPT_MODIFIED$STATUS"
#  elif $(echo "$INDEX" | grep '^ T ' &> /dev/null); then
#    STATUS="$ZSH_THEME_GIT_PROMPT_MODIFIED$STATUS"
#  fi
#  if $(echo "$INDEX" | grep '^R  ' &> /dev/null); then
#    STATUS="$ZSH_THEME_GIT_PROMPT_RENAMED$STATUS"
#  fi
#  if $(echo "$INDEX" | grep '^ D ' &> /dev/null); then
#    STATUS="$ZSH_THEME_GIT_PROMPT_DELETED$STATUS"
#  elif $(echo "$INDEX" | grep '^D  ' &> /dev/null); then
#    STATUS="$ZSH_THEME_GIT_PROMPT_DELETED$STATUS"
#  elif $(echo "$INDEX" | grep '^AD ' &> /dev/null); then
#    STATUS="$ZSH_THEME_GIT_PROMPT_DELETED$STATUS"
#  fi
#  if $(command git rev-parse --verify refs/stash >/dev/null 2>&1); then
#    STATUS="$ZSH_THEME_GIT_PROMPT_STASHED$STATUS"
#  fi
#  if $(echo "$INDEX" | grep '^UU ' &> /dev/null); then
#    STATUS="$ZSH_THEME_GIT_PROMPT_UNMERGED$STATUS"
#  fi
#  if $(echo "$INDEX" | grep '^## [^ ]\+ .*ahead' &> /dev/null); then
#    STATUS="$ZSH_THEME_GIT_PROMPT_AHEAD$STATUS"
#  fi
#  if $(echo "$INDEX" | grep '^## [^ ]\+ .*behind' &> /dev/null); then
#    STATUS="$ZSH_THEME_GIT_PROMPT_BEHIND$STATUS"
#  fi
#  if $(echo "$INDEX" | grep '^## [^ ]\+ .*diverged' &> /dev/null); then
#    STATUS="$ZSH_THEME_GIT_PROMPT_DIVERGED$STATUS"
#  fi
#  echo $STATUS
#}
#
## Outputs the name of the current user
## Usage example: $(git_current_user_name)
#function git_current_user_name() {
#  command git config user.name 2>/dev/null
#}
#
## Outputs the email of the current user
## Usage example: $(git_current_user_email)
#function git_current_user_email() {
#  command git config user.email 2>/dev/null
#}
#
# Go to the root of git repository or other directory
function gitroot() {
  cd $(git rev-parse --show-toplevel)"/"$1
}

# List files in current/specified/root directory in git repo
function gf() {
  command git ls-files $2 | grep $1
}

function gfr() {
  command git ls-files $(git rev-parse --show-toplevel)"/"$2 | grep $1
}

# Usefull aliases
alias ga="git add"
alias gap="git add -p"
alias gbr="git branch"
alias gci="git commit"
alias gcim="git commit -m"
alias gco="git checkout"
alias gdi="git diff"
alias gg="git grep -n"
alias gps="git push"
alias gpu="git pull"
alias gst="git status"
alias gstaged="git diff --staged"
alias gupdate="git pull --rebase"
