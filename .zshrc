autoload -U compinit compdef promptinit
compinit
promptinit
prompt pure

LANG="en_US.UTF-8"
LC_ALL="en_US.UTF-8"
GOPATH='/Users/andrei/.go'
EDITOR='vim'
PATH=~/.dotfiles/bin:/Users/andrei/go/bin:$PATH
PGDATA=/usr/local/var/postgres
ANDROID_HOME=/usr/local/opt/android-sdk
HOMEBREW_GITHUB_API_TOKEN=995128975d5615332b7aab40ecdda3cf11f03d8c
PURE_GIT_PULL=0
HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

bindkey -v
bindkey '^R' history-incremental-search-backward

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
  cd ~/Work/$1
}

function _p() {
  local -a projects
  projects=($(ls ~/Work))
  compadd -a projects
}
compdef _p p
