ZSH=$HOME/.oh-my-zsh
ZSH_THEME="afowler"

CFLAGS="-march=native -O3"
CXXFLAGS=${CFLAGS}

plugins=(git)

source $ZSH/oh-my-zsh.sh

alias untar='tar xvf'
alias tmux="TERM=screen-256color-bce tmux"
alias git="nocorrect git"
alias sudo="nocorrect sudo"
alias weather="weatherman \"Chisinau, Moldova\""
alias ff="grep -rsl"

#job workflow stuff
function fix-issue {
  git co staging && \
    git pl && \
    (git co -b JIRA-$1 || git co JIRA-$1)
}

function test-issue {
  git co JIRA-$1 && \
    git ph origin JIRA-$1 && \
    git co edge && \
    git pl && \
    git merge JIRA-$1 && \
    git ph origin edge && \
    git ph test edge:master && \
    git co JIRA-$1
}

function psa {
  ps -A | grep $1
}

function psport {
  lsof -i :$1
}

alias jsonprint='python -c "import sys, json; print json.dumps(json.load(sys.stdin), sort_keys=True, indent=4)"'
. ~/.nvm/nvm.sh

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
