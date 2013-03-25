setxkbmap -layout "us, ro(std)" -option "grp:caps_toggle"

systemd --user &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
xscreensaver -no-splash &
xrdb ~/.Xresources &
exec awesome
