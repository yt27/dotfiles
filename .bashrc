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

alias tmux='tmux -2' # for better colors

alias config='/usr/bin/git --git-dir=$HOME/git/dotfiles.git --work-tree=$HOME'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

export LC_ALL=UTF-8
export LANG=UTF-8

PATH=$HOME/local/bin:$PATH
PATH=$HOME/local/git/bin:$PATH
PATH=$HOME/local/tmux/bin:$PATH
PATH=$HOME/local/rtags/bin:$PATH
PATH=$HOME/local/global/bin:$PATH
PATH=$HOME/local/android-sdk-linux/tools:$PATH
PATH=$HOME/local/android-sdk-linux/platform-tools:$PATH
export PATH

export EDITOR=vim

export ANDROID_HOME=$HOME/local/android-sdk-linux

export ICECC_DISABLED=1

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/root/.sdkman"
[[ -s "/root/.sdkman/bin/sdkman-init.sh" ]] && source "/root/.sdkman/bin/sdkman-init.sh"
