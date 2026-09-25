# Troubleshooting

## The ISO does not boot

Verify the ISO checksum before writing it to USB. If the computer refuses to start the USB drive, disable Secure Boot temporarily and select the USB drive from the firmware boot menu.

## The screen is blank after boot

Try the ISO in a virtual machine first to separate an image problem from hardware support. For physical hardware, note the GPU model and whether the machine uses NVIDIA, AMD, or Intel graphics when reporting the issue.

## Wi-Fi, Bluetooth, or audio is missing

Record the hardware model and whether wired networking works. Do not install random drivers or run internet commands on an early live image; report the result so Kafy can include the right default support.

## The installer fails

The Kafy installer is experimental. Return to the live session, do not repeatedly retry against a disk containing important files, and save the error text or a photograph of the screen for the issue report.

## Getting help

File an issue in the Kafy repository with the ISO filename, hardware/VM details, what you expected, what happened, and any error output or screenshot.
