ZSH=$HOME/.oh-my-zsh
ZSH_THEME="robbyrussell"

export CFLAGS="-march=native -O2"
export CXXFLAGS=${CFLAGS}
export EDITOR=vim

plugins=(command-not-found dircycle)

source $ZSH/oh-my-zsh.sh
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"

alias untar='tar xvf'
alias tmux="TERM=screen-256color-bce tmux"
alias git="nocorrect git"
alias sudo="nocorrect sudo"
alias weather="weatherman \"Chisinau, Moldova\""
alias ft="ack-grep"
alias daily-upgrade="sudo apt-get update && sudo apt-get upgrade"
alias install="sudo apt-get install --no-install-recommends"
alias uninstall="sudo apt-get autoremove"
alias ppa-add="sudo add-apt-repository $1"
alias ppa-rm="sudo add-apt-repository --remove $1"
alias resume="tmux attach -t"

function psa {
  ps -A | grep $1
}

function psport {
  lsof -i :$1
}

alias jsonprint='python -c "import sys, json; print json.dumps(json.load(sys.stdin), sort_keys=True, indent=4)"'

ANDROID_HOME=$ANDROID_HOME:$HOME/SDKs/android
PATH=$PATH:$HOME/SDKs/android/tools:$HOME/SDKs/android/platform-tools
PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
[[ -s /home/andrei/.nvm/nvm.sh ]] && . /home/andrei/.nvm/nvm.sh # This loads NVM

PATH=$PATH:$HOME/bin
