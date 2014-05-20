ZSH=$HOME/.oh-my-zsh
#ZSH_THEME=soliah

export CFLAGS="-march=native -O2"
export CXXFLAGS=${CFLAGS}
export EDITOR=vim
export PATH="/usr/local/Cellar/vim/7.4.273/bin":$PATH

plugins=(zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

alias tmux="TERM=screen-256color-bce tmux"
alias git="nocorrect git"
alias sudo="nocorrect sudo"

alias install="brew install"
alias resume="tmux attach -t"
alias extract="tar xf"
alias service="sudo service"
alias reload!='source ~/.zshrc'
alias w='tmux attach -t'
alias mux='tmux new-session -s `basename \`pwd\``'
alias ack='ack-grep --color'

[[ -s /home/andrei/.nvm/nvm.sh ]] && . /home/andrei/.nvm/nvm.sh # This loads NVM

source /usr/local/opt/chruby/share/chruby/chruby.sh
source /usr/local/opt/chruby/share/chruby/auto.sh

#autoload -U promptinit && promptinit
#prompt pure

zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
