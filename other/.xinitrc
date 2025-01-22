# !/bin/bash

setxkbmap -option caps:none
setxkbmap -layout us,ru -option "grp:caps_toggle"

feh --no-fehbg --bg-fill ~/Documents/Wallpapers/mountains_peaks_fog_134301_3840x2400.jpg
xrandr --output eDP-1 --gamma 1.0:0.9:0.85

flameshot &
diodon &
picom --config $HOME/.config/picom/picom.conf  &

slstatus &
exec dbus-launch --sh-syntax --exit-with-session dwm

