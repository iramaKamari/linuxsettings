fd -t f . /home/tobias/Documents/wallpapers/ > wallpapers
num_wallpapers="$(wc -l < wallpapers)"
wallpaper="$(shuf -i 1-$num_wallpapers -n 1)"
ln -sf "$(sed -n "$wallpaper p" wallpapers)" ~/Documents/wallpapers/terminal_bg.png
rm wallpapers
