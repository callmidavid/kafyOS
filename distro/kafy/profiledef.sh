#!/usr/bin/env bash

iso_name="kafy-os"
iso_label="KAFY_$(date +%Y%m)"
iso_publisher="Kafy Project <https://github.com/kafy-os/kafy>"
iso_application="Kafy OS — elegant, simple Linux"
iso_version="$(date +%Y.%m.%d)"
install_dir="kafy"
buildmodes=('iso')
bootmodes=('bios.syslinux' 'uefi.systemd-boot')
arch="x86_64"
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'zstd' '-Xcompression-level' '15')
file_permissions=(
  ["/usr/local/bin/kafy-installer"]="0:0:755"
  ["/usr/local/bin/kafy-welcome"]="0:0:755"
)
