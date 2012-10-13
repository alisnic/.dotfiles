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

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
