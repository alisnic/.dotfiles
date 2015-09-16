ZSH=$HOME/.oh-my-zsh
ZSH_THEME=simple

LANG="en_US.UTF-8"
LC_ALL="en_US.UTF-8"

export CFLAGS="-march=native -O2"
export CXXFLAGS=${CFLAGS}
export EDITOR='vim'
export JAVA_HOME='/Library/Java/JavaVirtualMachines/jdk1.8.0_25.jdk/Contents/Home'
export JRUBY_OPTS='-Xcompile.invokedynamic=false -J-XX:+TieredCompilation -J-XX:TieredStopAtLevel=1 -J-noverify -Xcompile.mode=OFF'
export PATH=~/bin:$PATH
export ANDROID_HOME=~/Applications/android-sdk-macosx
export GOPATH=~/.go
export PGDATA=/usr/local/var/postgres
export NVM_DIR=~/.nvm

source $ZSH/oh-my-zsh.sh

alias install="brew install"
alias extract="tar xf"
alias reload!='source ~/.zshrc'
alias w='tmux attach -t'
alias g='git'
alias mux='tmux new-session -s `basename \`pwd\``'
alias be='bundle exec'

source /usr/local/opt/nvm/nvm.sh
source /usr/local/opt/chruby/share/chruby/chruby.sh
source /usr/local/opt/chruby/share/chruby/auto.sh
chruby 2.2.3

zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
