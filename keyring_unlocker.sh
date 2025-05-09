#!/bin/bash

while true; do
    read -rsp "Keyring Password: " pass
    export $(echo -n "$pass" | gnome-keyring-daemon --replace --unlock 2>/dev/null)
    unset pass
    if gdbus call --session \
        --dest org.freedesktop.secrets \
        --object-path /org/freedesktop/secrets/collection/login \
        --method org.freedesktop.DBus.Properties.Get \
        org.freedesktop.Secret.Collection Locked | grep -q '(<false>,)'; then
        echo "SUCCESS Keyring is unlocked"
        break
    else
        echo "FAIL Wrong Password"
    fi
done
exit 0
