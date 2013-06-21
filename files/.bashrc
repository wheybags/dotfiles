
# Check for an interactive session
[ -z "$PS1" ] && return

cd

PATH=$PATH:`readlink -f bin`:`readlink -f dotfiles/bin`

export EDITOR="vim"
stty ixoff -ixon

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
alias ls='ls --color=auto'
alias menu='obmenugen;openbox --reconfigure'
alias lock='xscreensaver-command --lock'
alias smb='fusesmb /home/wheybags/shares/'
alias slumber='sudo slumber'
alias :D='sm :D'
alias :3='sm :3'
alias :q='exit'
alias grep="grep --color=auto"
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



complete -cf sudo
complete -cf optirun

export PS1="\[\033[1;37m\][\[\033[1;32m\]\\h\[\033[1;37m\]] \[\033[1;34m\]\w\[\033[1;37m\] > $\[\033[0m\] "
export TERM="xterm"

export BROWSER="chromium"

if [ -e TODO ]; then cat ~/TODO; fi
if [ -f .bashrc_local ]; then source .bashrc_local; fi

