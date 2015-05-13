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

# Creare an empty settings file if no settings file is present.
if [ ! -e "/data/settings.toml" ]; then
	touch /data/settings.toml
fi

# Fix permissions.
chown -R bud:bud /data /go
chmod -R 770 /go /data

# Run as bud user. Preserve the PATH variable.
CMD="$@"
set -x; exec su - bud -m -c "PATH=\"$PATH\" $CMD"