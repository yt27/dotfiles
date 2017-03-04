if [ -f /etc/bashrc ]; then
  . /etc/bashrc   # --> Read /etc/bashrc, if present.
fi

P_DEFAULT="\e[0m\]"
P_RED="\e[31m\]"
P_GREEN="\e[32m\]"
P_YELLOW="\e[33m\]"
P_BLUE="\e[34m\]"
P_VIOLET="\e[35m\]"
P_CYAN="\e[36m\]"

PS1="${P_CYAN}[\t][\u@\h][\w]${P_DEFAULT}\n"

if [ "`uname -s`" == "Darwin" ]; then
  alias ls='ls -G -l -F'
else
  alias ls='ls --color -l -F'
fi
alias rm='rm -i'
alias cp='cp -ir'
alias mv='mv -i'
alias scp='scp -r'

alias config='/usr/bin/git --git-dir=$HOME/git/dotfiles.git --work-tree=$HOME'

PATH=$HOME/local/tmux/bin:$PATH
PATH=$HOME/local/rtags/bin:$PATH
PATH=$HOME/Development/git/git/contrib/workdir:$PATH
export PATH

unset TMUX

export EDITOR=vim
