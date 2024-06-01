#!/bin/bash
_WATCH_EXP="type=signal, \
            path=/org/blueman/Applet, \
            interface=org.blueman.Applet, \
            member=IconNameChanged"
_MSG_PREFIX='string "blueman-'


print_disabled() {
    echo "%{F$COLOR_DISABLED}%{F-}"
}

print_disconnected() {
    echo 
}

print_connected() {
    echo '%{F#2193ff}%{F-}'
}


if [ "$(bluetoothctl show | grep 'Powered: yes')" == '' ]; then
    print_disabled
else
    if [ "$(bluetoothctl info | grep 'DeviceSet (null)')" == '' ]; then
        print_connected
    else
        print_disconnected
    fi
fi


while read event_line; do
    case $event_line in
        "${_MSG_PREFIX}disabled\"")
            print_disabled
            ;;
        "${_MSG_PREFIX}tray\"")
            print_disconnected
            ;;
        "${_MSG_PREFIX}active\"")
            print_connected
            ;;
    esac
done < <(dbus-monitor "$_WATCH_EXP")
