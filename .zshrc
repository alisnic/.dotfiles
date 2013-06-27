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
alias daily-upgrade="yaourt -Syua"
alias install="yaourt -Syua"
alias uninstall="sudo pacman -Rs"
alias extract="dtrx"
alias service="sudo systemctl"
alias cleanup="sudo pacman -Rc $(pacman -Qtdq) && sudo pacman -Sc"
alias date="cal -3m"
alias rm="trash-put"
alias reload!='source ~/.zshrc'
unalias sl

function workon {
  tmux attach -t $1 || tmux new-session -s $1
}


[[ -s /home/andrei/.nvm/nvm.sh ]] && . /home/andrei/.nvm/nvm.sh # This loads NVM

PATH=$PATH:$HOME/bin
source /usr/share/chruby/chruby.sh
source /usr/share/chruby/auto.sh
