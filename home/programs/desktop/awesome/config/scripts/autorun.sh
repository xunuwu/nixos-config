#!/usr/bin/env bash
xrandr --output DisplayPort-2 --mode 1920x1080 --rate 165 &
/nix/store/$(ls -la /nix/store | grep polkit-gnome | grep '^d' | awk '{print $9}')/libexec/polkit-gnome-authentication-agent-1 &
