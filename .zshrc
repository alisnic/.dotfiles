# load pure prompt
autoload -U promptinit
promptinit
prompt pure

bindkey -v
bindkey '^R' history-incremental-search-backward

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export GOPATH='/Users/andrei/.go'
export EDITOR='vim'
export PATH=~/.dotfiles/bin:/Users/andrei/go/bin:$PATH
export PGDATA=/usr/local/var/postgres
export ANDROID_HOME=/usr/local/opt/android-sdk
export HOMEBREW_GITHUB_API_TOKEN=995128975d5615332b7aab40ecdda3cf11f03d8c
export PURE_GIT_PULL=0
export HISTFILE=$HOME/.zsh_history
export HISTSIZE=10000
export SAVEHIST=10000

alias rails='bundle exec rails'
alias brails='bin/spring rails'
alias rake='bundle exec rake'
alias brake='bin/spring rake'
alias reload!='source ~/.zshrc'
alias w='tmux attach -t'
alias mux='tmux new-session -s `basename \`pwd\``'
alias be='bundle exec'
alias sp='bin/spring'
alias rm='trash'
alias rebrew='brew update && brew upgrade && brew cleanup'

source /usr/local/opt/chruby/share/chruby/chruby.sh
chruby 2.4.2

function gentags() {
  echo "Exporting tags..."
  ctags -R -f .git/tags --tag-relative=yes
}

function p() {
  cd ~/Work/$1 && (tmux attach-session -t $1 || tmux new-session -s $1)
}

function _p() {
  local -a projects
  projects=($(ls ~/Work))
  compadd -a projects
}

autoload -U compinit compdef
compinit
compdef _p p
