var panelIds = panelIds;
for (var i = 0; i < panelIds.length; ++i) {
    var oldPanel = panelById(panelIds[i]);
    if (oldPanel) oldPanel.remove();
}

for (var screen = 0; screen < screenCount; ++screen) {
    var desktop = new Activity;
    desktop.screen = screen;
    desktop.wallpaperPlugin = "org.kde.image";
    desktop.currentConfigGroup = ["Wallpaper", "org.kde.image", "General"];
    desktop.writeConfig("Image", "file:///usr/share/wallpapers/kafy/contents/images/1920x1080.png");
}

var menuBar = new Panel;
menuBar.location = "top";
menuBar.height = Math.round(gridUnit * 1.5);
var launcher = menuBar.addWidget("org.kde.plasma.kickoff");
launcher.currentConfigGroup = ["General"];
launcher.writeConfig("icon", "start-here-kde");
menuBar.addWidget("org.kde.plasma.appmenu");
menuBar.addWidget("org.kde.plasma.panelspacer");
menuBar.addWidget("org.kde.plasma.systemtray");
var clock = menuBar.addWidget("org.kde.plasma.digitalclock");
clock.currentConfigGroup = ["Appearance"];
clock.writeConfig("showSeconds", "false");

var dock = new Panel;
dock.location = "bottom";
dock.alignment = "center";
dock.hiding = "dodgewindows";
dock.height = Math.round(gridUnit * 2.5);
dock.currentConfigGroup = ["General"];
dock.writeConfig("floating", "1");
var tasks = dock.addWidget("org.kde.plasma.icontasks");
tasks.currentConfigGroup = ["General"];
tasks.writeConfig("launchers", [
    "applications:org.kde.dolphin.desktop",
    "applications:firefox.desktop",
    "applications:org.kde.discover.desktop",
    "applications:systemsettings.desktop"
]);
dock.addWidget("org.kde.plasma.trash");
