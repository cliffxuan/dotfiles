# cliff-mac.zsh-theme
#
# Author: Cliff Xuan
#
# Created on:		6 Jan, 2013

# color vars
eval my_gray='$FG[237]'
eval my_orange='$FG[214]'

if [ $UID -eq 0 ]
then
    NCOLOR="red"
else
    NCOLOR="green"
fi
local return_code="%(?..%{$fg[red]%}[%?]%{$reset_color%})"

# primary prompt
PROMPT='$my_gray------------------------------------------------------------%{$reset_color%}
$FG[032]%~\
$(git_prompt_info) \
${return_code}$FG[105]%(!.#.»)%{$reset_color%} '
PROMPT2='%{$fg[red]%}\ %{$reset_color%}'

# right prompt
RPROMPT='$my_gray%n@%m[%*]%{$reset_color%}%'

# git settings
ZSH_THEME_GIT_PROMPT_PREFIX="$FG[075] ("
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="$my_orange*%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="$FG[075])%{$reset_color%}"
