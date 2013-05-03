#disable the bell
xset -b

#Keyring
# Start a D-Bus session
source /etc/X11/xinit/xinitrc.d/30-dbus
# Start GNOME Keyring
eval $(/usr/bin/gnome-keyring-daemon --start --components=gpg,pkcs11,secrets,ssh)
# You probably need to do this too:
export SSH_AUTH_SOCK
export GPG_AGENT_INFO
export GNOME_KEYRING_CONTROL
export GNOME_KEYRING_PID

systemd --user &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
xscreensaver -no-splash &
xrdb ~/.Xresources &

exec awesome
