#!/bin/sh
# Re-apply the wallpaper whenever the monitor layout changes.
#
# i3 emits an "output" event on every RandR change, so we get plug/unplug for
# free without polling or an extra daemon like autorandr.

SELF="$(basename "$0")"
DIR="$(dirname "$(readlink -f "$0")")"

# Singleton: i3 runs this from exec_always, so a restart would otherwise stack
# up a new watcher on every reload. Kill any previous instance but not ourselves.
for pid in $(pgrep -f "$SELF"); do
    [ "$pid" = "$$" ] || kill "$pid" 2>/dev/null
done

"$DIR/layout.sh"
"$DIR/wallpaper.sh"

i3-msg -t subscribe -m '[ "output" ]' 2>/dev/null | while read -r _; do
    # Let X settle on the new screen dimensions before feh reads them; without
    # this feh can race the resize and paint at the old geometry again.
    sleep 1
    # Modes and positions first, then the wallpaper that has to fit them.
    # layout.sh no-ops when the layout is already correct, which matters here:
    # its own xrandr call emits the very output event we're subscribed to.
    "$DIR/layout.sh"
    "$DIR/wallpaper.sh"
done
