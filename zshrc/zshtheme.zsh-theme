# vim:ft=zsh ts=2 sw=2 sts=2

ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg[green]%}\uE0A0 "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}!"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%}?"
ZSH_THEME_GIT_PROMPT_CLEAN=""

ZSH_THEME_RUBY_PROMPT_PREFIX="%{$fg_bold[red]%}‹"
ZSH_THEME_RUBY_PROMPT_SUFFIX="›%{$reset_color%}"

PROMPT='%{$fg_bold[red]%}[%{$fg_bold[yellow]%}%n%{$fg_bold[green]%}@%{$fg_bold[blue]%}%m%{$fg_bold[red] %{$fg_bold[magenta]%}%1d%}%{$fg_bold[red]%}]$(git_prompt_info)$(git_prompt_status) ⌚ %{$fg_bold[red]%}%*%{$fg_bold[cyan]%}
$%{$reset_color%} '

RPROMPT='$(ruby_prompt_info)'
