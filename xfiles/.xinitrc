#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# emergency x shutdown
setxkbmap -option terminate:ctrl_alt_bksp

# Set the friggin numlock
numlockx &

# Set default cursor to not be X-shaped
xsetroot -cursor_name left_ptr&

# Notification server
dunst &

# Start ibus
export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus
ibus-daemon -drx

# Trackpoint middle button scroll
tpset() { xinput set-prop "TPPS/2 IBM TrackPoint" "$@"; }
tpset "Evdev Wheel Emulation" 1
tpset "Evdev Wheel Emulation Button" 2
tpset "Evdev Wheel Emulation Timeout" 200
tpset "Evdev Wheel Emulation Axes" 6 7 4 5
tpset "Device Accel Constant Deceleration" 1

# check if existing socket exists and killl for bspwm(doesn't play nice with logging out and in)
rm /tmp/$(ls /tmp | grep bspwm)

# Thunar daemon for detect hot plugs of hard drive / usb drive
thunar --daemon &

# Wallpaper
. ~/src/wallpaper

# WM
compton -b
sxhkd -f 35 &
exec bspwm