autoload colors
colors

#use extended color pallete if available
if [[ $TERM = *256color* || $TERM = *rxvt* ]]; then
    turquoise="%F{81}"
    orange="%F{166}"
    purple="%F{135}"
    hotpink="%F{161}"
    limegreen="%F{118}"
else
    turquoise="$fg[cyan]"
    orange="$fg[yellow]"
    purple="$fg[magenta]"
    hotpink="$fg[red]"
    limegreen="$fg[green]"
fi
local return_code="%(?..%{$hotpink%}[%?]%{$reset_color%})"

PROMPT='
%{$purple%}[ %t ] [ %{$purple%}%n@%m:%~$(git_prompt_info)%{$orange%}$(rvm_prompt_info)%{$purple%} ]$reset_color
 $ '

RPROMPT='${return_code}'
# git theming
ZSH_THEME_GIT_PROMPT_PREFIX="%{$limegreen%}("
ZSH_THEME_GIT_PROMPT_SUFFIX=")"
ZSH_THEME_GIT_PROMPT_CLEAN="✔"
ZSH_THEME_GIT_PROMPT_DIRTY="✗"
