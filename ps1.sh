# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	color_prompt=yes
    else
	color_prompt=
    fi
fi

# Git prompt
if [ -f /usr/share/git/completion/git-prompt.sh ]; then
    source /usr/share/git/completion/git-prompt.sh
fi
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM="auto"
export GIT_PS1_SHOWCOLORHINTS=1
export GIT_PS1_HIDE_IF_PWD_IGNORED=1


# Hex (#RRGGBB или RRGGBB) → ANSI truecolor foreground
txc() {
    local hex="${1#\#}"
    local r=$((16#${hex:0:2}))
    local g=$((16#${hex:2:2}))
    local b=$((16#${hex:4:2}))
    printf '\e[38;2;%d;%d;%dm' $r $g $b
}

# Hex → ANSI truecolor background
bgc() {
    local hex="${1#\#}"
    local r=$((16#${hex:0:2}))
    local g=$((16#${hex:2:2}))
    local b=$((16#${hex:4:2}))
    printf '\e[48;2;%d;%d;%dm' $r $g $b
}

# Сброс цвета
RSC='\e[0m'

if [ "$color_prompt" = yes ]; then

C_FRAME=$(txc '#7AA2F7')
C_TIME=$(txc '#9ECE6A')
C_USER=$(txc '#BB9AF7')
C_HOST=$(txc '#7AA2F7')
C_PATH=$(txc '#89B4FA')
C_VENV=$(txc '#F7768E')
C_GIT=$(txc '#E0AF68')

base_PS1='\
\[$C_FRAME\]┌\
\[$RSC\][\
\[$C_TIME\]\T\
\[$RSC\]] \
\[$C_USER\]\u\
\[$$RSC\]@\
\[$C_HOST\]\h\
\[$RSC\]:\
\[$C_PATH\]\w\
\[$C_VENV\]$( [ -n "$VIRTUAL_ENV" ] && echo " ($(basename "$VIRTUAL_ENV"))" )\
\[$C_GIT\]$( __git_ps1 " {%s}")\
\n\
\[$C_FRAME\]└\
\[\033[00m\]\$ '

PROMPT_COMMAND='PS1="\n$base_PS1"'

else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt
