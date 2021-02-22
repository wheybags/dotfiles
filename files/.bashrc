
# Check for an interactive session
[ -z "$PS1" ] && return

# load system-provided autocompletions
if [ -d /etc/profile.d ]; then
  for i in /etc/profile.d/*.sh; do
    if [ -r $i ]; then
      . $i
    fi
  done
  unset i
fi

#cd

PATH=$HOME/bin:$HOME/dotfiles/bin:$PATH:/sbin:/usr/sbin

export EDITOR="vim"
stty ixoff -ixon

bind "set completion-ignore-case on"

alias scrot="scrot -e 'mv \$f ~/Images/scrot/'"
#alias mplayer='mplayer -vo gl'
alias pause='killall -STOP'
alias resume='killall -CONT'
alias text='o2sms --config-file=/home/wheybags/.o2sms/config'
alias reboot='killall chromium;sudo /sbin/reboot'
alias halt='killall chromium;sudo /sbin/halt'
#alias spoonprox='ssh -ND 9999 wheybags@spoon.netsoc.tcd.ie'
alias prox='ssh -NL 8080:www-proxy.scss.tcd.ie:8080 ducss.ie'
alias c='ssh -t wheybags@cube.netsoc.tcd.ie tmux a -d -t master'
alias menu='obmenugen;openbox --reconfigure'
alias lock='xscreensaver-command --lock'
alias smb='fusesmb /home/wheybags/shares/'
alias slumber='sudo slumber'
alias :D='sm :D'
alias :3='sm :3'
alias :q='exit'
alias grep="grep --color=auto"
alias v='vim'
alias gh='fg'
alias sshp='ssh -o PreferredAuthentications=password -o PubkeyAuthentication=no'

alias sudo='/bin/sudo --preserve-env=PATH'

aurget() { wd=`pwd`; cd /tmp; `which aurget` $@; cd $wd ;} # Store temp files and finsihed package in /tmp, not current wd

# Adds git push all, to push to all git remotes
git() {
	git=`which git`

	if  [ $# -eq 2 ] && [ "$1" = "push" ] && [ "$2" = "all" ]
	then
		$git remote | xargs -L 1 $git push
	else
		gitargs=""
		for i in "$@"; do
			gitargs="$gitargs \"$i\""
		done
		echo $gitargs | xargs $git
	fi
}

#eval $(thefuck --alias)

~/dotfiles/gen_ssh_config.py

#complete -cf sudo
complete -cf optirun

if [ `uname -s` = "Darwin" ]; then
    alias hosthash='shasum -a 256'
    alias ls='ls -G'
else
    alias hosthash='sha256sum'
    alias ls='ls --color=auto'
fi
 
# hash hostname to a colour for the prompt
val=$((0x`hostname | hosthash | awk '{print $1}'`)); val=${val#-}; 
val1=$(($val % 2))
val2=$(($val % 5)); val2=$[$val2+2]

source $HOME/dotfiles/miscfiles/git-prompt.sh
source $HOME/dotfiles/miscfiles/git-completion.bash

export PS1="\[\033[1;37m\][\[\033[$val1;3$val2""m\]\\h\[\033[1;37m\]] \[\033[1;34m\]\w\$(__git_ps1 ' \\033[1;36m[\\033[0;37m%s\\033[1;36m]\\033[0m' )\[\033[1;37m\] >\n$\[\033[0m\] "


#export TERM="xterm"

export BROWSER="chromium"

if [ -f ~/.bashrc_local ]; then source ~/.bashrc_local; fi

if [ -e ~/Dropbox/TODO.txt ]; then cat ~/Dropbox/TODO.txt; fi


# UGH JAVA
if [ ! -z "`which java`" ]; then
    J_PATH=`which java`
    J_PATH=`readlink -f $J_PATH`
    JAVA_HOME=`dirname $J_PATH`
    JAVA_HOME=`dirname $JAVA_HOME`
    JAVA_HOME=`dirname $JAVA_HOME`
fi

unamestr=`uname`
if [ $unamestr != 'Darwin' ]; then
    alias open='xdg-open'
fi
 

echo
date

# configure bash history
shopt -s histappend # append .bash_history file, don't overwrite
PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a" # append after every command, not just on session close

# HISTSIZE sets unlimited in-session history size, HISTFILESIZE sets the history file size to unlimited
HISTSIZE=
HISTFILESIZE=

wsl=1
uname -a | grep WSL > /dev/null && wsl=0

ssh_socket_path=/tmp/wheybags_ssh_sock

if [ $wsl ]; then
    # https://github.com/rupor-github/wsl-ssh-agent/tree/a7e6af06b5c541b66903f3655e95832be3308015#wsl-2-compatibility
    export SSH_AUTH_SOCK=$ssh_socket_path

    ss -a | grep -q $SSH_AUTH_SOCK
    if [ $? -ne 0 ]; then
        if [ -e $SSH_AUTH_SOCK ]; then
            rm $SSH_AUTH_SOCK
        fi
        ( setsid socat UNIX-LISTEN:$ssh_socket_path,fork EXEC:"/home/wheybags/dotfiles/npiperelay.exe -ei -s //./pipe/openssh-ssh-agent",nofork & ) >/dev/null 2>&1
    fi

    xhost="`grep nameserver /etc/resolv.conf | sed 's/nameserver //'`"
    
    nc -z -v -w1 $xhost 6000 2>/dev/null
    if [ $? -eq 1 ]; then
        echo starting x server...
        cmd.exe /c "`wslpath -w ~/dotfiles/config.xlaunch`" 
    fi

    export DISPLAY="$xhost:0"
else
    if [ ! -z "$SSH_AUTH_SOCK" ]; then 
        if [ $SSH_AUTH_SOCK != $ssh_socket_path ]; then
            if [ -L $ssh_socket_path ]; then
                rm $ssh_socket_path
            fi
            ln -s $SSH_AUTH_SOCK $ssh_socket_path
        fi
    fi
    
    export SSH_AUTH_SOCK=$ssh_socket_path
fi

