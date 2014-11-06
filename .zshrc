ZSH=$HOME/.oh-my-zsh
ZSH_THEME=simple

export CFLAGS="-march=native -O2"
export CXXFLAGS=${CFLAGS}
export EDITOR='/Applications/MacVim.app/Contents/MacOS/Vim'
export JAVA_HOME='/Library/Java/JavaVirtualMachines/jdk1.8.0_25.jdk/Contents/Home'
export JRUBY_OPTS='-Xcompile.invokedynamic=false -J-XX:+TieredCompilation -J-XX:TieredStopAtLevel=1 -J-noverify -Xcompile.mode=OFF'
export PATH=~/bin:$PATH
export ANDROID_HOME=~/Applications/android-sdk-macosx

plugins=(zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

alias install="brew install"
alias extract="tar xf"
alias reload!='source ~/.zshrc'
alias w='tmux attach -t'
alias g='git'
alias mux='tmux new-session -s `basename \`pwd\``'
alias vim='/Applications/MacVim.app/Contents/MacOS/Vim'
alias be='bundle exec'

[[ -s /home/andrei/.nvm/nvm.sh ]] && . /home/andrei/.nvm/nvm.sh # This loads NVM

source /usr/local/opt/chruby/share/chruby/chruby.sh
source /usr/local/opt/chruby/share/chruby/auto.sh

#autoload -U promptinit && promptinit
#prompt pure

zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
