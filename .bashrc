if [ -f /etc/bashrc ]; then
  . /etc/bashrc   # --> Read /etc/bashrc, if present.
fi

P_DEFAULT="\e[0m\]"

P_BLACK="\e[30m\]"
P_RED="\e[31m\]"
P_GREEN="\e[32m\]"
P_YELLOW="\e[33m\]"
P_BLUE="\e[34m\]"
P_VIOLET="\e[35m\]"
P_CYAN="\e[36m\]"
P_WHITE="\e[37m\]"

P_BLACK_HI="\e[90m\]"
P_RED_HI="\e[91m\]"
P_GREEN_HI="\e[92m\]"
P_YELLOW_HI="\e[93m\]"
P_BLUE_HI="\e[94m\]"
P_VIOLET_HI="\e[95m\]"
P_CYAN_HI="\e[96m\]"
P_WHITE_HI="\e[97m\]"

parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/[\1]/'
}

PS1="${P_GREEN_HI}[\t][\u@\h]${P_YELLOW_HI}[\w]${P_CYAN_HI}\$(parse_git_branch)${P_DEFAULT}\n"

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

alias xterm='xterm -fa "Ubuntu Mono derivative Powerline" -fs 11 +sb'

alias config='git --git-dir=$HOME/git/dotfiles.git --work-tree=$HOME'

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

export LC_ALL=en_US.utf8
export LANG=en_US.utf8

PATH=$HOME/local/bin:$PATH
PATH=$HOME/local/scripts:$PATH
PATH=$HOME/local/nvim/bin:$PATH
PATH=$HOME/local/git/bin:$PATH
PATH=$HOME/local/tmux/bin:$PATH
PATH=$HOME/local/rtags/bin:$PATH
PATH=$HOME/local/global/bin:$PATH
PATH=$HOME/local/python/bin:$PATH
PATH=$HOME/local/python3/bin:$PATH
PATH=$HOME/local/ag/bin:$PATH
PATH=$HOME/local/cmatrix/bin:$PATH
PATH=$HOME/local/eclipse:$PATH
PATH=$HOME/local/node/bin:$PATH
PATH=$HOME/.local/bin:$PATH
PATH=$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH
PATH=$HOME/local/android-sdk-linux/tools:$PATH
PATH=$HOME/local/android-sdk-linux/platform-tools:$PATH
export PATH

export EDITOR=nvim

MANPATH=/home/linuxbrew/.linuxbrew/share/man:$MANPATH
MANPATH=/home/ytakebuc/.linuxbrew/share/man:$MANPATH
MANPATH=$HOME/local/neovim/share/man:$MANPATH
MANPATH=$HOME/local/tmux/share/man:$MANPATH
MANPATH=$HOME/local/global/share/man:$MANPATH
MANPATH=$HOME/local/ag/share/man:$MANPATH
export MANPATH

INFOPATH=/home/linuxbrew/.linuxbrew/share/info:$INFOPATH
INFOPATH=/home/ytakebuc/.linuxbrew/share/info:$INFOPATH
export INFOPATH

PKG_CONFIG_PATH=$HOME/local/libevent/lib/pkgconfig:$PKG_CONFIG_PATH
export PKG_CONFIG_PATH

LD_LIBRARY_PATH=$HOME/local/libevent/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH

export ANDROID_HOME=$HOME/local/android-sdk-linux

export ICECC_DISABLED=1

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/root/.sdkman"
[[ -s "/root/.sdkman/bin/sdkman-init.sh" ]] && source "/root/.sdkman/bin/sdkman-init.sh"

# Begin ssh agent init
# https://confluence.atlassian.com/bitbucket/my-gitbash-ssh-environment-always-asks-for-my-passphrase-what-can-i-do-277252540.html
SSH_ENV=$HOME/.ssh/environment

# start the ssh-agent
function start_agent {
  echo "Initializing new SSH agent..."
  # spawn ssh-agent
  /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
  echo succeeded
  chmod 600 "${SSH_ENV}"
  . "${SSH_ENV}" > /dev/null
  /usr/bin/ssh-add
}

if [ -f "${SSH_ENV}" ]; then
  . "${SSH_ENV}" > /dev/null
  ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
  start_agent;
}
else
  start_agent;
fi
# End ssh agent init

# Begin share history among sessions
# https://unix.stackexchange.com/questions/1288/preserve-bash-history-in-multiple-terminal-windows
# Avoid duplicates
export HISTCONTROL=ignoredups:erasedups  
# When the shell exits, append to the history file instead of overwriting it
shopt -s histappend

# After each command, append to the history file and reread it
#export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"
# End share history among sessions

[ -f ~/.fzf.conf ] && source ~/.fzf.conf

PATH="/home/ytakebuc/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/home/ytakebuc/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/ytakebuc/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/ytakebuc/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/ytakebuc/perl5"; export PERL_MM_OPT;
