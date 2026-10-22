# Updates and Recovery

Kafy is not yet a stable public release. These commands define the update and recovery process used for release-candidate testing.

To see available Arch updates and pending Kafy migrations, run:

```sh
kafy-update --check
```

To install Arch updates and then run Kafy migrations, run:

```sh
sudo kafy-update --apply
```

Kafy migrations are one-time fixes for Kafy-owned system state. They never overwrite your home-directory configuration. Reboot after an update when the kernel, graphics stack, or systemd changed.

If an update fails, do not delete files or retry random commands. First collect a read-only diagnostic report:

```sh
kafy-recover --check
systemctl --failed
journalctl -b -p warning
```

If the desktop will not start, boot the previous working ISO, mount the installed system, and use an Arch chroot only with the matching Kafy recovery instructions for that release. Include the ISO version, `kafy-recover --check` output, and the journal in a support report.
