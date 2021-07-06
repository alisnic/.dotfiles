fpath=(~/.zsh-completions $fpath)
autoload -U compinit && compinit
autoload -U colors && colors

export FZF_DEFAULT_COMMAND='rg --files ---hidden --follow -g "!.git" 2> /dev/null'

source ~/.dotfiles/.env
source ~/.dotfiles/zsh/history.zsh
export PATH="$HOME/.cargo/bin:$PATH"
