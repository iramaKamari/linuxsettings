# My little linux settings dabbling
TODO: Add script that will set up everything. Either by moving or using symlink.

## config
These are the directories/files that goes under the /home/user/.config folder

## themes
Put under /home/user/.themes

## xkbcustom
Custom keyboard layout for xkb
Put .keymap.xkb and .xkb folder in your home directory
Enable with:
xkbcomp -I$HOME/.xkb $HOME/.colemakdh.xkb $DISPLAY
xkbcomp -I$HOME/.xkb $HOME/.keymap.xkb $DISPLAY
