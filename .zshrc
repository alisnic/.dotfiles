ZSH=$HOME/.oh-my-zsh
ZSH_THEME=amuse

LANG="en_US.UTF-8"
LC_ALL="en_US.UTF-8"

# export EDITOR=nvim
export JAVA_HOME=$(/usr/libexec/java_home)
export PATH=~/bin:$PATH
export PGDATA=/usr/local/var/postgres
export ANDROID_HOME=/usr/local/opt/android-sdk
export HOMEBREW_GITHUB_API_TOKEN=995128975d5615332b7aab40ecdda3cf11f03d8c

source $ZSH/oh-my-zsh.sh

alias brails='bin/spring rails'
alias brake='bin/spring rake'
alias vim='/Applications/MacVim.app/Contents/MacOS/Vim'
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
alias mvim='reattach-to-user-namespace mvim'

source /usr/local/opt/chruby/share/chruby/chruby.sh
chruby 2.3.1

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

function git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

function gentags() {
  echo "Exporting tags..."
  ctags -R --tag-relative -f .git/tags
}

function f_notifyme {
  LAST_EXIT_CODE=$?
  CMD=$(fc -ln -1)
  # No point in waiting for the command to complete
  notifyme "$CMD" "$LAST_EXIT_CODE" &
}
