fpath=(~/.zsh-completions $fpath)
autoload -U compinit && compinit
autoload -U colors && colors

source /usr/local/opt/chruby/share/chruby/chruby.sh
source ~/.dotfiles/zsh/history.zsh
source /usr/local/Cellar/fzf/0.18.0/shell/key-bindings.zsh
source ~/.dotfiles/.env

bindkey -v
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd 'v' edit-command-line

bindkey "^[[1;3D" backward-word
bindkey "^[[1;3C" forward-word

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

setopt PROMPT_SUBST

precmd() {
  if [ -d ".git" ]
  then
    export GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
    PS1=$'\n$fg[black]%~$reset_color $GIT_BRANCH\n$ '
  else
    PS1=$'\n$fg[black]%~$reset_color\n$ '
  fi
}

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export EDITOR='nvim'
export PATH=~/.dotfiles/bin:/usr/local/bin:$PATH
export PGDATA=/usr/local/var/postgres
export ANDROID_HOME=/usr/local/opt/android-sdk
export FZF_DEFAULT_COMMAND='rg --files ---hidden --follow -g "!.git" 2> /dev/null'
export PATH="/usr/local/opt/postgresql@10/bin:$PATH"
export HOMEBREW_INSTALL_CLEANUP=true
export KEYTIMEOUT=1

alias brails='bin/spring rails'
alias brake='bin/spring rake'
alias reload!='source ~/.zshrc'
alias be='bundle exec'
alias sp='bin/spring'
alias rm='trash'
alias vim='nvim'

function gentags() {
  echo "Exporting tags..."
  ripper-tags -R -f .git/rubytags --tag-relative=yes
  ctags -R -f .git/tags --tag-relative=yes --languages=coffee,javascript
}

function j {
	cd -P "$MARKDIR/$1"
}

function _completemarks {
  reply=($(ls $MARKDIR))
}

compctl -K _completemarks j
