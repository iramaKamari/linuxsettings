# vim:ft=zsh ts=2 sw=2 sts=2

ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg[green]%} "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[yellow]%}>"
ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE="%{$fg[red]%}*"
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%}+"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%}?"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%}x"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[red]%}!"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN=""

PROMPT='%{$fg_bold[red]%}[%{$fg_bold[yellow]%}%n%{$fg_bold[green]%}@%{$fg_bold[blue]%}%m%{$fg_bold[red] %{$fg_bold[magenta]%}%1d%}%{$fg_bold[red]%}]$(git_prompt_branch)$(git_prompt_dirty) ⌚ %{$fg_bold[red]%}%*%{$fg_bold[cyan]%}
$%{$reset_color%} '
