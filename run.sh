#!/bin/bash

set -e

update_timezone() {
    echo -n "Setting timezone to $1... "
    ln -sf "/usr/share/zoneinfo/$1" /etc/localtime
    [[ $? -eq 0 ]] && echo "Done !" || echo "FAILURE"
}


# Update the timezone.
if [ ! -z "$TIMEZONE" ]; then
    update_timezone "$TIMEZONE"
fi


# Fix permissions.
chown -R bud:bud /data /go
chmod -R 770 /go /data

# Run supervisord.
set -x; exec "$@"