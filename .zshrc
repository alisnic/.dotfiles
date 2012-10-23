ZSH=$HOME/.oh-my-zsh
ZSH_THEME="afowler"

plugins=(git)

source $ZSH/oh-my-zsh.sh

alias sysinstall='sudo apt-get install'
alias sysupdate='sudo apt-get update'
alias sysupgrade='sudo apt-get upgrade'
alias aptsearch='apt-cache search'
alias untar='tar xvf'
alias tmux="TERM=screen-256color-bce tmux"
alias git="nocorrect git"
alias sudo="nocorrect sudo"
alias ff="grep -Iir"

alias weather="weatherman \"Chisinau, Moldova\""

#job workflow stuff
function fix-issue {
  git co master && \
    git co -b JIRA-$1
}

function test-issue {
  git co edge && \
    git merge JIRA-$1 && \
    git ph origin edge && \
    git ph test edge:master
}


PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
PATH=$PATH:$HOME/.bin # Add local scripts
