#!/usr/bin/env bash
set -euo pipefail

useradd -m -G wheel,audio,video,storage -s /bin/bash liveuser
passwd -d liveuser
chown -R liveuser:liveuser /home/liveuser

systemctl enable NetworkManager.service bluetooth.service cups.service power-profiles-daemon.service sddm.service
systemctl set-default graphical.target

pacman-key --init
pacman-key --populate archlinux
