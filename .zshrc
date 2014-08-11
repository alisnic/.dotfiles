ZSH=$HOME/.oh-my-zsh
ZSH_THEME=rgm

export CFLAGS="-march=native -O2"
export CXXFLAGS=${CFLAGS}
export EDITOR=vim
JAVA_OPTS="-d32 -client -J-Xmx1024m"
LANG="en_US.UTF-8"
LC_ALL="en_US.UTF-8"

plugins=(zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

alias install="sudo aptitude install"
alias service="sudo service"
alias extract="tar xf"
alias reload!='source ~/.zshrc'
alias w='tmux attach -t'
alias mux='tmux new-session -s `basename \`pwd\``'
alias ack='ack-grep --color'

[[ -s /home/andrei/.nvm/nvm.sh ]] && . /home/andrei/.nvm/nvm.sh # This loads NVM

PATH=$PATH:$HOME/bin

zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

#load erlang
. /home/andrei/.kerl/installs/r17/activate
test -s "$HOME/.kiex/scripts/kiex" && source "$HOME/.kiex/scripts/kiex"
kiex use stable
