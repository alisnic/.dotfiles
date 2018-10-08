source ~/.oh-my-zsh/lib/history.zsh

fpath=(~/.zsh-completions $fpath)
autoload -U compinit && compinit
autoload -U colors && colors

bindkey -v
bindkey "^[[1;3D" backward-word
bindkey "^[[1;3C" forward-word

zstyle ':completion:*' menu select
PROMPT="
$fg[black]%~$reset_color
$ "

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export GOPATH='/Users/andrei/.go'
export EDITOR='nvim'
export PATH=~/.dotfiles/bin:/Users/andrei/go/bin:/usr/local/bin:$PATH
export PGDATA=/usr/local/var/postgres
export ANDROID_HOME=/usr/local/opt/android-sdk
export HOMEBREW_GITHUB_API_TOKEN=995128975d5615332b7aab40ecdda3cf11f03d8c
export FZF_DEFAULT_COMMAND='rg --files ---hidden --follow -g "!.git" 2> /dev/null'

alias brails='bin/spring rails'
alias brake='bin/spring rake'
alias rake='bundle exec rake'
alias rails='bundle exec rails'
alias reload!='source ~/.zshrc'
alias mux='tmux new-session -s `basename \`pwd\``'
alias be='bundle exec'
alias sp='bin/spring'
alias rm='trash'
alias rebrew='brew update && brew upgrade && brew cleanup'
alias w='tmux attach -t'
alias vim='nvim'

source /usr/local/opt/chruby/share/chruby/chruby.sh
chruby 2.4.4

function gentags() {
  echo "Exporting tags..."
  ripper-tags -R -f .git/rubytags --tag-relative=yes
  ctags -R -f .git/tags --tag-relative=yes --languages=coffee,javascript
}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
bindkey '^T' fzf-cd-widget
