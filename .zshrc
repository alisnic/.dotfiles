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
setopt share_history
setopt +o nomatch

FPATH=/opt/homebrew/share/zsh/site-functions:/opt/homebrew/share/zsh-completions:$FPATH
autoload -Uz compinit

precmd() {
  if [ -d ".git" ]
  then
    export GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
    PS1=$'\n%~ $fg[blue]$GIT_BRANCH$reset_color$(parse_git_stash) (%j)\n$ '
  else
    PS1=$'\n%~ (%j)\n$ '
  fi
  print -Pn "\e]2;%~\a"
}

parse_git_stash() {
  if [[ -n $(git stash list 2> /dev/null) ]]; then
    echo " 🧳"
  else
    echo ""
  fi
}

_fix_cursor() {
   echo -ne '\e[5 q'
}

precmd_functions+=(_fix_cursor)

export EDITOR=nvim
export BAT_THEME='Solarized (light)'
export FZF_DEFAULT_COMMAND='rg --files ---hidden --follow -g "!.git" -g "!node_modules" -g "!.cache" 2> /dev/null'
export FZF_DEFAULT_OPTS="--bind ctrl-a:select-all"
export HOMEBREW_INSTALL_CLEANUP=true
export KEYTIMEOUT=1
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export LSCOLORS="Gxfxcxdxbxegedabagacad"
export PATH=~/.dotfiles/bin:~/Library/Python/3.9/bin:/usr/local/bin:/usr/local/sbin:/opt/homebrew/sbin:$PATH

source ~/.fzf.zsh
export PATH=/opt/homebrew/bin:$PATH
export PATH="/opt/homebrew/opt/openssl@1.1/bin:$PATH"
export MANPAGER='nvim +Man!'
export MANWIDTH=999

alias ls='ls -G'
alias reload!='source ~/.zshrc'
alias be='bundle exec'
alias sp='bin/spring'
alias dc='docker-compose'

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

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
