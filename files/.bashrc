
# Check for an interactive session
[ -z "$PS1" ] && return

cd

PATH=$PATH:$HOME/bin:$HOME/dotfiles/bin:/sbin:/usr/sbin

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

alias sudo='sudo env PATH=$PATH'

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

export PS1="\[\033[1;37m\][\[\033[$val1;3$val2""m\]\\h\[\033[1;37m\]] \[\033[1;34m\]\w\$(__git_ps1 ' \\033[1;36m[\\033[0;37m%s\\033[1;36m]\\033[0m' )\[\033[1;37m\] >\n$\[\033[0m\] "


export TERM="xterm"

export BROWSER="chromium"

if [ -f .bashrc_local ]; then source .bashrc_local; fi

if [ -e ~/Dropbox/TODO.txt ]; then cat ~/Dropbox/TODO.txt; fi
echo
date
