#!/bin/sh
# Re-apply the keyboard remaps whenever an input device is added or removed.
#
# Why this is needed: X hands a newly hotplugged keyboard the *server default*
# keymap and rebuilds the master keyboard's map from its slaves. That silently
# undoes both `setxkbmap -option ctrl:nocaps` and every xmodmap tweak. Running
# them once at i3 startup therefore only ever covers the devices present at
# login -- plug the mechanical keyboard in and Caps reverts to Caps.
#
# XI_HierarchyChanged (XI2 event type 11) is what X emits on device add/remove.

SELF="$(basename "$0")"

# Singleton: i3 runs this from exec_always, so an i3 restart would otherwise
# stack up a watcher per reload. Kill previous instances, never ourselves.
for pid in $(pgrep -f "$SELF"); do
    [ "$pid" = "$$" ] || kill "$pid" 2>/dev/null
done

apply() {
    # Order matters: setxkbmap reloads the keymap from xkb and DISCARDS any
    # xmodmap edits, so xmodmap has to run second or keycode 206 (the external
    # keyboard's Super) drops out of mod4 and every i3 binding dies with it.
    setxkbmap -option ctrl:nocaps
    [ -f "$HOME/.Xmodmap" ] && xmodmap "$HOME/.Xmodmap"
}

apply

xinput --test-xi2 --root 2>/dev/null | while read -r line; do
    case "$line" in
        *"EVENT type 11"*)   # XI_HierarchyChanged: a device came or went
            # Let X finish enumerating the device before we remap it.
            sleep 1
            apply
            ;;
    esac
done
