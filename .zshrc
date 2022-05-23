bindkey -v
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd 'v' edit-command-line

bindkey "^[[1;3D" backward-word
bindkey "^[[1;3C" forward-word

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

setopt PROMPT_SUBST
setopt auto_pushd
setopt +o nomatch

precmd() {
  if [ -d ".git" ]
  then
    export GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
    PS1=$'\n%~ $fg[blue]$GIT_BRANCH$reset_color$(parse_git_stash) (%j)\n$ '
  else
    PS1=$'\n%~ (%j)\n$ '
  fi
  print -Pn "\e]2;%n@%M | %~\a"
}

parse_git_stash() {
  if [[ -n $(git stash list 2> /dev/null) ]]; then
    echo " 📦"
  else
    echo ""
  fi
}

export EDITOR=nvim
export BAT_THEME='Solarized (light)'
export FZF_DEFAULT_COMMAND='rg --files ---hidden --follow -g "!.git" -g "!node_modules" -g "!.cache" 2> /dev/null'
export FZF_DEFAULT_OPTS="
  --bind ctrl-a:select-all
  --preview 'bat {}'
"
export HOMEBREW_INSTALL_CLEANUP=true
export KEYTIMEOUT=1
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export LSCOLORS="Gxfxcxdxbxegedabagacad"
export PATH=~/.dotfiles/bin:~/Library/Python/3.9/bin:/usr/local/bin:/usr/local/sbin:/opt/homebrew/sbin:$PATH

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
source ~/.fzf.zsh
export PATH="$PATH:$HOME/.rvm/bin"
export PATH=/opt/homebrew/bin:$PATH
export PATH="/opt/homebrew/opt/openssl@1.1/bin:$PATH"
export PATH="/opt/homebrew/opt/node@14/bin:$PATH"
export MANPAGER='nvim +Man!'
export MANWIDTH=999

alias ls='ls -G'
alias reload!='source ~/.zshrc'
alias be='bundle exec'
alias sp='bin/spring'
alias rm='trash'
alias dc='docker-compose'
alias k=kubectl
alias vagrant=~/Play/vagrant/exec/vagrant

function gentags() {
  echo "Exporting tags..."
  ripper-tags -R -f .git/rubytags --tag-relative=yes
  # ctags -R -f .git/tags --tag-relative=yes --languages=coffee,javascript,python,php,java
}

function j {
  cd -P "$MARKDIR/$1"
}


function p {
  cd -P "$HOME/Play/$1"
}

function _completemarks {
  reply=($(ls $MARKDIR))
}

function _completeplays {
  reply=($(ls ~/Play))
}

compctl -K _completemarks j
compctl -K _completeplays p
