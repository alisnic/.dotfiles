ZSH=$HOME/.oh-my-zsh
ZSH_THEME=amuse

LANG="en_US.UTF-8"
LC_ALL="en_US.UTF-8"

export EDITOR='/Applications/MacVim.app/Contents/MacOS/Vim'
export PATH=~/.dotfiles/bin:/Users/andrei/go/bin:$PATH
export PGDATA=/usr/local/var/postgres
export ANDROID_HOME=/usr/local/opt/android-sdk
export HOMEBREW_GITHUB_API_TOKEN=995128975d5615332b7aab40ecdda3cf11f03d8c

source $ZSH/oh-my-zsh.sh

alias rails='bundle exec rails'
alias brails='bin/rails'
alias rake='bundle exec rake'
alias brake='bin/rake'
alias vim='reattach-to-user-namespace /Applications/MacVim.app/Contents/MacOS/Vim'
alias reload!='source ~/.zshrc'
alias w='tmux attach -t'
alias mux='tmux new-session -s `basename \`pwd\``'
alias be='bundle exec'
alias focusvim="osascript -e 'activate application \"MacVim\"'"
alias focussubl="osascript -e 'activate application \"Sublime Text\"'"
alias sp='bin/spring'
alias rm='trash'
alias gitx='reattach-to-user-namespace gitx'
alias rebrew='brew update && brew upgrade && brew cleanup'
alias dc='docker-compose'
alias mvim='FEATURE=true chruby-exec system -- reattach-to-user-namespace mvim'

source /usr/local/opt/chruby/share/chruby/chruby.sh
chruby 2.2.6

function git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

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

function f_notifyme {
  LAST_EXIT_CODE=$?
  CMD=$(fc -ln -1)
  # No point in waiting for the command to complete
  notifyme "$CMD" "$LAST_EXIT_CODE" &
}
