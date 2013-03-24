ZSH=$HOME/.oh-my-zsh
ZSH_THEME="robbyrussell"

export CFLAGS="-march=native -O2"
export CXXFLAGS=${CFLAGS}
export EDITOR=vim
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8


plugins=(command-not-found dircycle)

source $ZSH/oh-my-zsh.sh
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"

alias tmux="TERM=screen-256color-bce tmux"
alias git="nocorrect git"
alias sudo="nocorrect sudo"
alias daily-upgrade="sudo pacman -Syu && sudo aura -Akua"
alias install="sudo pacman -S"
alias uninstall="pacman -R $(pacman -Qdtq)"
alias ppa-add="sudo add-apt-repository $1"
alias ppa-rm="sudo add-apt-repository --remove $1"
alias resume="tmux attach -t"
alias extract="dtrx"
alias service="sudo systemctl"
unalias sl

function psa {
  ps -A | grep $1
}

function psport {
  lsof -i :$1
}

alias jsonprint='python -c "import sys, json; print json.dumps(json.load(sys.stdin), sort_keys=True, indent=4)"'

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
[[ -s /home/andrei/.nvm/nvm.sh ]] && . /home/andrei/.nvm/nvm.sh # This loads NVM

PATH=$PATH:$HOME/bin
