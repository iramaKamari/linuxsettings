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

# Misc aliases
alias h="history"
alias j="jobs -l"
alias n='nvim'
alias v='vim'
alias fg='fg %'
alias bg='bg %'
