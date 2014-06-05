#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
EDITOR=vim
export GEM_HOME=$(ruby -e 'puts Gem.user_dir')

alias ls='ls --color=auto'
alias temp='/opt/vc/bin/vcgencmd measure_temp'
alias freq='/opt/vc/bin/vcgencmd get_config arm_freq'
alias mux='tmux new-session -s `basename \`pwd\``'
alias w='tmux attach -t'
alias upgrade='sudo pacman -Syu'
alias install='sudo pacman -S'
alias uninstall='sudo pacman -Rs'

# Run twolfson/sexy-bash-prompt
. ~/.dotfiles/.bash_prompt

source /usr/local/share/chruby/chruby.sh
source /usr/local/share/chruby/auto.sh

