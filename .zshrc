bindkey -v
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd 'v' edit-command-line

bindkey "^[[1;3D" backward-word
bindkey "^[[1;3C" forward-word

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

setopt PROMPT_SUBST
setopt +o nomatch

precmd() {
  if [ -d ".git" ]
  then
    export GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
    PS1=$'\n%~ $fg[blue]$GIT_BRANCH$reset_color\n$ '
  else
    PS1=$'\n%~\n$ '
  fi
}

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export EDITOR='vim'
export PATH=~/.dotfiles/bin:/usr/local/bin:/usr/local/sbin:$PATH
export FZF_DEFAULT_COMMAND='rg --files ---hidden --follow -g "!.git" 2> /dev/null'
export FZF_DEFAULT_OPTS='--bind ctrl-a:select-all'
export HOMEBREW_INSTALL_CLEANUP=true
export KEYTIMEOUT=1
export LSCOLORS="Gxfxcxdxbxegedabagacad"
export EDITOR=nvim

if [[ $(uname -m) == "arm64" ]]; then
  [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
  source /opt/homebrew/Cellar/fzf/$(ls /opt/homebrew/Cellar/fzf)/shell/key-bindings.zsh
  export PATH="$PATH:$HOME/.rvm/bin"
  export PATH=/opt/homebrew/bin:$PATH
  export PATH="/opt/homebrew/opt/postgresql@10/bin:$PATH"
  export PATH="/opt/homebrew/opt/node@14/bin:$PATH"
else
  source /usr/local/Cellar/fzf/$(ls /usr/local/Cellar/fzf)/shell/key-bindings.zsh
  source /usr/local/opt/chruby/share/chruby/chruby.sh
  export PATH="/usr/local/opt/postgresql@10/bin:$PATH"
  export PATH="/usr/local/opt/node@10/bin:$PATH"
  chruby 2.5
fi

alias ls='ls -G'
alias brails='bin/spring rails'
alias brake='bin/spring rake'
alias reload!='source ~/.zshrc'
alias be='bundle exec'
alias sp='bin/spring'
alias rm='trash'

function gentags() {
  echo "Exporting tags..."
  ripper-tags -R -f .git/rubytags --tag-relative=yes
  ctags -R -f .git/tags --tag-relative=yes --languages=coffee,javascript,python,php,java
}

function j {
	cd -P "$MARKDIR/$1"
}

function _completemarks {
  reply=($(ls $MARKDIR))
}

compctl -K _completemarks j
