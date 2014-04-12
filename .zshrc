ZSH=$HOME/.oh-my-zsh

export EDITOR=vim
plugins=(zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

alias tmux="TERM=screen-256color-bce tmux"
alias git="nocorrect git"

alias install="apt-cyg install"
alias uninstall="apt-cyg remove"
alias reload!='source ~/.zshrc'
alias w='tmux attach -t'
alias mux='tmux new-session -s `basename \`pwd\``'
alias ack='ack-grep --color'
alias power="acpi -VVV"

[[ -s /home/andrei/.nvm/nvm.sh ]] && . /home/andrei/.nvm/nvm.sh # This loads NVM

PATH=$PATH:$HOME/bin
#source /usr/local/share/chruby/auto.sh

autoload -U promptinit && promptinit
prompt pure

zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
