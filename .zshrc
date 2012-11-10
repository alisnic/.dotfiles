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
alias weather="weatherman \"Chisinau, Moldova\""
alias ff="grep -rsl"

#job workflow stuff
function fix-issue {
  git co master && \
    git pl && \
    git co -b JIRA-$1
}

function test-issue {
  git co JIRA-$1 && \
    git ph origin JIRA-$1 && \
    git co edge && \
    git pl && \
    git merge JIRA-$1 && \
    git ph origin edge && \
    git ph test edge:master
}

alias jsonprint='python -c "import sys, json; print json.dumps(json.load(sys.stdin), sort_keys=True, indent=4)"'

