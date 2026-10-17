//@ pragma ShellId kafy-shell
//@ pragma StateDir $BASE/kafy/shell

import Quickshell
import Quickshell.Io
import Quickshell.Services.Notifications

ShellRoot {
    id: shell
    property bool launcherOpen: false
    property bool controlCenterOpen: false
    property bool notificationCenterOpen: false

    function closeOverlays(): void {
        launcherOpen = false
        controlCenterOpen = false
        notificationCenterOpen = false
    }

    IpcHandler {
        target: "kafy"
        function toggleLauncher(): void { shell.launcherOpen = !shell.launcherOpen; shell.controlCenterOpen = false; shell.notificationCenterOpen = false; }
        function toggleControlCenter(): void { shell.controlCenterOpen = !shell.controlCenterOpen; shell.launcherOpen = false; shell.notificationCenterOpen = false; }
        function toggleNotifications(): void { shell.notificationCenterOpen = !shell.notificationCenterOpen; shell.launcherOpen = false; shell.controlCenterOpen = false; }
        function closeOverlays(): void { shell.closeOverlays(); }
    }

    NotificationServer {
        id: notifications
        bodySupported: true
        bodyMarkupSupported: true
        actionsSupported: true
        keepOnReload: true
        onNotification: notification.tracked = !notification.transient
    }

    KafyBar { shell: shell; notifications: notifications }
    KafyLauncher { shell: shell }
    KafyControlCenter { shell: shell; notifications: notifications }
    KafyNotificationCenter { shell: shell; notifications: notifications }
    KafyDock { shell: shell }
}
