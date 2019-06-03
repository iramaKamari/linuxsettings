alias journalctl='sudo journalctl'
alias pacrepo='sudo reflector -l 20 -f 10 --save /etc/pacman.d/mirrorlist'
alias pacman='sudo pacman'
alias upgrade='sudo pacman -Syu'
alias install='sudo pacman -S'
alias delete='sudo pacman -Rs'
alias search='sudo pacman -Ss'
alias auru='yaourt -Syua --noconfirm'
alias systemctl='sudo systemctl'
alias se='ls /usr/bin | grep'
alias files='ranger'

# Directory handling
alias d="dirs -v"
alias 1="pushd +1"
alias 2="pushd +2"
alias 3="pushd +3"
alias 4="pushd +4"
alias 5="pushd +5"
alias 6="pushd +6"
alias 7="pushd +7"
alias 8="pushd +8"
alias 9="pushd +9"
alias sd="pushd "$@""
alias ed="dirs -c"

# Functions
function cdl {
  builtin cd "$@" && ls -l
}

# Git
alias ga="git add"
alias gap="git add -p"
alias gbr="git branch"
alias gci="git commit"
alias gcim="git commit -m"
alias gco="git checkout"
alias gdi="git diff"
alias gg="git grep -n"
alias gps="git push"
alias gpu="git pull"
alias gst="git status"
alias gstaged="git diff --staged"
alias gupdate="git pull --rebase"

function gitroot() {    
  cd $(git rev-parse --show-toplevel)"/"$1    
}

# List files in current/specified/root directory in git repo
function gf() {
  command git ls-files $2 | grep $1
}

function gfr() {
  command git ls-files $(git rev-parse --show-toplevel)"/"$2 | grep $1
}

# Misc aliases
alias h="history"
alias j="jobs -l"
alias ll="ls -lh"
alias ls='ls --color=auto'
alias n='nvim'
alias clr="clear"
