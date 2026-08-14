#!/bin/bash
# Start nm-applet pinned to the right-hand end of i3bar's systray.
#
# i3bar has no tray-ordering option, but the order is not arbitrary either:
# configure_trayclients() qsorts the docked icons with strcasecmp on WM_CLASS
# (class first, then instance) and lays them out from the right edge leftwards,
# so the icon whose class sorts LAST is the rightmost one. Position therefore
# depends only on the class string -- not on dock order -- which is why
# restarting nm-applet by itself never moves it.
#
# Left alone, nm-applet's class is "Nm-applet", and every SNI app bridged in by
# snixembed (copycat-ui, and most modern GTK/Qt/Electron tray apps) docks as
# "tray-icon tray app <pid>-N". "n" < "t", so the wifi icon gets pushed left of
# each of those as they appear. Launching under argv[0] "zz-nm-applet" makes
# GTK derive the class "Zz-nm-applet" instead, which sorts after "tray-icon" --
# and stays there, however many tray apps come and go.
#
# `exec -a` is why this file has a bash shebang; the process's comm is still
# "nm-applet", so pgrep/pkill -x nm-applet keep working.

exec -a zz-nm-applet /usr/bin/nm-applet "$@"
