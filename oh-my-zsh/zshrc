# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
if [[ $OSTYPE == darwin* ]]
then
    ZSH_THEME="cliff-mac"
else
    prof_file=$(print /etc/*-release) 2>/dev/null
    if [[ -z $prof_file ]]
    then
        ZSH_THEME="cliff-linux"
    else
        if [[ $(cat `echo $prof_file`) =~ .*Ubuntu.* ]]
        then
            ZSH_THEME="cliff-ubuntu"
        elif [[ $(cat `echo $prof_file`) =~ .*Arch.* ]]
        then
            ZSH_THEME="cliff-arch"
        else
            ZSH_THEME="cliff-linux"
        fi
    fi
    unset prof_file
fi

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
DISABLE_AUTO_UPDATE="true"

# Uncomment to change how many often would you like to wait before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
#DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
#COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=()

source $ZSH/oh-my-zsh.sh

if [[ -f $HOME/.shrc ]]
then
    source $HOME/.shrc
fi
