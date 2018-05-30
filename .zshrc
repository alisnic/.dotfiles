export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="amuse"
plugins=()
source $ZSH/oh-my-zsh.sh

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export GOPATH='/Users/andrei/.go'
export EDITOR='nvim'
export PATH=~/.dotfiles/bin:/Users/andrei/go/bin:/usr/local/bin:$PATH
export PGDATA=/usr/local/var/postgres
export ANDROID_HOME=/usr/local/opt/android-sdk
export HOMEBREW_GITHUB_API_TOKEN=995128975d5615332b7aab40ecdda3cf11f03d8c
export FZF_DEFAULT_COMMAND='rg --files ---hidden --follow -g "" 2> /dev/null'

alias brails='bin/spring rails'
alias reload!='source ~/.zshrc'
alias mux='tmux new-session -s `basename \`pwd\``'
alias be='bundle exec'
alias sp='bin/spring'
alias rm='trash'
alias rebrew='brew update && brew upgrade && brew cleanup'
alias w='tmux attach -t'

bindkey "^[[1;3D" backward-word
bindkey "^[[1;3C" forward-word

source /usr/local/opt/chruby/share/chruby/chruby.sh
chruby 2.4.4

function gentags() {
  echo "Exporting tags..."
  ripper-tags -R -f .git/rubytags --tag-relative=yes
  noglob ctags -R -f .git/tags --tag-relative=yes --exclude=*.rb
}
