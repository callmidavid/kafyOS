# Trying and Installing Kafy

## Try the live session

Write the Kafy ISO to a USB drive with a trusted image writer, boot the computer from that USB drive, and choose **Kafy OS** from the boot menu. The live image signs in automatically as `liveuser` and starts the Kafy desktop.

Use the live session to verify Wi-Fi, audio, display scaling, sleep/wake, Bluetooth, and graphics before considering installation.

## Install status

The **Install Kafy OS** desktop entry opens Kafy's experimental installer. It collects your keyboard layout, account, time zone, computer name, and destination disk, then calls Archinstall.

The current installer is destructive: choosing a disk means that disk is intended to be erased. It does not yet provide a tested dual-boot, manual partitioning, encryption, or rollback experience. Back up anything important and use a spare disk while this part of Kafy is under development.

## Before installation

- Back up all files on the selected disk.
- Use a wired connection if Wi-Fi has not been tested on your hardware.
- Disable Secure Boot if the ISO does not boot. Kafy does not yet ship a Secure Boot signing/enrollment flow.
- Keep the USB drive connected until installation completes and the computer has restarted.

## Report the result

When testing, record the ISO filename, whether you booted a physical machine or virtual machine, graphics hardware, network result, audio result, and any visible error. This turns a vague failure into an actionable Kafy issue.
