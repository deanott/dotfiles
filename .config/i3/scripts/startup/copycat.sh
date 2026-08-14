#!/bin/sh
# Start copycat-ui at login, tray-only.
#
# Why this is a script and not a bare `exec copycat-ui`: the UI always maps its
# window on launch (eframe's ViewportBuilder is built without a start-hidden
# option), so autostarting it drops the clipboard browser in your face on every
# login. Closing that window is NOT a quit -- the app cancels the close and
# hides to the tray, only the tray's Quit item exits -- so one polite
# WM_DELETE_WINDOW right after startup leaves exactly the tray icon behind.
#
# NOTE: ~/.config/autostart/copycat-ui.desktop does nothing here. XDG autostart
# entries are run by systemd's xdg-desktop-autostart.target, which only a full
# desktop session starts; under i3 it stays inactive. i3's exec is the only
# startup hook that fires.

BIN="$HOME/.cargo/bin/copycat-ui"

pgrep -x copycat-ui >/dev/null 2>&1 && exit 0

"$BIN" &

# Wait for the window to map, then fold it away. Bounded (~15s) so a failed
# launch -- or a future --hidden flag in copycat-ui itself -- never leaves this
# spinning forever.
i=0
while [ "$i" -lt 30 ]; do
    if i3-msg -t get_tree 2>/dev/null | grep -q '"copycat-ui"'; then
        i3-msg '[class="copycat-ui"] kill' >/dev/null 2>&1
        exit 0
    fi
    sleep 0.5
    i=$((i + 1))
done
