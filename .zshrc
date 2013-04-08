ZSH=$HOME/.oh-my-zsh
ZSH_THEME="robbyrussell"

export CFLAGS="-march=native -O2"
export CXXFLAGS=${CFLAGS}
export EDITOR=vim
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

plugins=()

source $ZSH/oh-my-zsh.sh
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"

alias tmux="TERM=screen-256color-bce tmux"
alias git="nocorrect git"
alias sudo="nocorrect sudo"
alias daily-upgrade="sudo yaourt -Syua"
alias install="sudo yaourt -S"
alias uninstall="sudo pacman -Rcs"
alias resume="tmux attach -t"
alias extract="dtrx"
alias service="sudo systemctl"
alias cleanup="sudo pacman -Rc $(pacman -Qtdq)"
unalias sl

compdef _pacman_completions_all_packages yaourt

function psa {
  ps -A | grep $1
}

function psport {
  lsof -i :$1
}

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
[[ -s /home/andrei/.nvm/nvm.sh ]] && . /home/andrei/.nvm/nvm.sh # This loads NVM

PATH=$PATH:$HOME/bin
