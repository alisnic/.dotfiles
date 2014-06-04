#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
EDITOR=vim

alias ls='ls --color=auto'
alias temp='/opt/vc/bin/vcgencmd measure_temp'
alias freq='/opt/vc/bin/vcgencmd get_config arm_freq'

# Run twolfson/sexy-bash-prompt
. ~/.dotfiles/.bash_prompt

source /usr/local/share/chruby/chruby.sh
source /usr/local/share/chruby/auto.sh
