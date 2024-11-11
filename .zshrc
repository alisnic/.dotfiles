#bindkey -v
#autoload -Uz edit-command-line
#zle -N edit-command-line
#bindkey -M vicmd 'v' edit-command-line

bindkey "^[[1;3D" backward-word
bindkey "^[[1;3C" forward-word

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

HISTSIZE=999999999
setopt auto_pushd
setopt share_history
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt +o nomatch
FPATH=/opt/homebrew/share/zsh/site-functions:/opt/homebrew/share/zsh-completions:$FPATH
autoload -Uz compinit

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
export PATH=~/.dotfiles/bin:/usr/local/bin:/usr/local/sbin:/opt/homebrew/sbin:$PATH

source <(fzf --zsh)
export PATH=/opt/homebrew/bin:$PATH
export PATH="/opt/homebrew/opt/openssl@1.1/bin:$PATH"

alias ls='ls -G'
alias reload!='source ~/.zshrc'

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

eval "$(starship init zsh)"
export PATH=/Users/alisnic/.meteor:$PATH
