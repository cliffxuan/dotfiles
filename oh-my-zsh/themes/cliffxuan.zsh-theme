function host_name {
    if command -v hostname >/dev/null 2>&1; then
        if [ "$OSTYPE" = "cygwin" ]; then
            hostname
        else
            hostname -s
        fi
    else
        echo unknown
    fi
} 

PROMPT='
%{$fg[magenta]%}%n%{$reset_color%}@%{$fg[yellow]%}$(host_name)%{$reset_color%} %{$fg_bold[green]%}${PWD/#$HOME/~}%{$reset_color%}
%(?,,%{${fg_bold[white]}%}[%?]%{$reset_color%} )$ '

local return_status="%{$fg[red]%}%(?..✘)%{$reset_color%}"
RPROMPT='${return_status}%{$reset_color%}'
