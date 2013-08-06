ZSH=$HOME/.oh-my-zsh
ZSH_THEME="robbyrussell"

export CFLAGS="-march=native -O2"
export CXXFLAGS=${CFLAGS}
export EDITOR=vim
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export WINEARCH=win32

plugins=()

source $ZSH/oh-my-zsh.sh

alias tmux="TERM=screen-256color-bce tmux"
alias git="nocorrect git"
alias sudo="nocorrect sudo"
alias install="yaourt -Syua"
alias uninstall="sudo pacman -Rs"
alias extract="tar xf"
alias service="sudo systemctl"
alias cleanup="sudo pacman -Rc $(pacman -Qtdq) && sudo pacman -Sc"
alias date="cal -3m"
alias rm="trash-put"
alias reload!='source ~/.zshrc'
alias w='tmux attach -t'
alias g='git'
unalias sl


[[ -s /home/andrei/.nvm/nvm.sh ]] && . /home/andrei/.nvm/nvm.sh # This loads NVM

PATH=$PATH:$HOME/bin:$HOME/.gem/ruby/2.0.0/bin
source /usr/share/chruby/chruby.sh
source /usr/share/chruby/auto.sh

zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

alsi -n
