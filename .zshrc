ZSH=$HOME/.oh-my-zsh
ZSH_THEME="robbyrussell"

export CFLAGS="-march=native -O2"
export CXXFLAGS=${CFLAGS}
export EDITOR=vim
JAVA_OPTS="-d32 -client"

plugins=()

source $ZSH/oh-my-zsh.sh

alias tmux="TERM=screen-256color-bce tmux"
alias git="nocorrect git"
alias sudo="nocorrect sudo"

alias daily-upgrade="sudo apt-get update && sudo apt-get upgrade"
alias install="sudo apt-get install --no-install-recommends"
alias uninstall="sudo apt-get autoremove"
alias resume="tmux attach -t"
alias extract="dtrx"
alias service="sudo sudo service"
alias extract="tar xf"
alias service="sudo service"
alias reload!='source ~/.zshrc'
alias w='tmux attach -t'
alias g='git'
alias ack='ack-grep'
unalias sl


[[ -s /home/andrei/.nvm/nvm.sh ]] && . /home/andrei/.nvm/nvm.sh # This loads NVM

PATH=$PATH:$HOME/bin:$HOME/.gem/ruby/2.0.0/bin
source /usr/local/share/chruby/chruby.sh
source /usr/local/share/chruby/auto.sh

zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
