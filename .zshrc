ZSH=$HOME/.oh-my-zsh
ZSH_THEME=rgm

export CFLAGS="-march=native -O2"
export CXXFLAGS=${CFLAGS}
export EDITOR='/Applications/MacVim.app/Contents/MacOS/Vim'

plugins=(zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

alias install="brew install"
alias extract="tar xf"
alias reload!='source ~/.zshrc'
alias w='tmux attach -t'
alias g='git'
alias mux='tmux new-session -s `basename \`pwd\``'
alias vim='/Applications/MacVim.app/Contents/MacOS/Vim'

[[ -s /home/andrei/.nvm/nvm.sh ]] && . /home/andrei/.nvm/nvm.sh # This loads NVM

source /usr/local/opt/chruby/share/chruby/chruby.sh
source /usr/local/opt/chruby/share/chruby/auto.sh

#autoload -U promptinit && promptinit
#prompt pure

zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
