#!/bin/bash
set -euo pipefail

HOST_UID=${LOCAL_UID:-1000}
HOST_GID=${LOCAL_GID:-1000}
TARGET_USER=ubuntu

# user/group 操作は root 権限が必要
if [ "$(id -u)" -ne 0 ]; then
    echo "Error: entrypoint must run as root" >&2
    exit 1
fi

if ! getent group "$TARGET_USER" >/dev/null 2>&1; then
    groupadd "$TARGET_USER"
fi

if ! id -u "$TARGET_USER" >/dev/null 2>&1; then
    useradd -m -g "$TARGET_USER" "$TARGET_USER"
fi

CURRENT_UID="$(id -u "$TARGET_USER")"
CURRENT_GID="$(id -g "$TARGET_USER")"
TARGET_GROUP="$(id -gn "$TARGET_USER")"

if [ "$HOST_GID" != "$CURRENT_GID" ]; then
    if getent group "$HOST_GID" >/dev/null 2>&1; then
        usermod -g "$HOST_GID" "$TARGET_USER"
    else
        groupmod -g "$HOST_GID" "$TARGET_GROUP"
    fi
fi

if [ "$HOST_UID" != "$CURRENT_UID" ]; then
    usermod -o -u "$HOST_UID" "$TARGET_USER"
fi

if [ ! -d "/home/$TARGET_USER" ]; then
    mkdir -p "/home/$TARGET_USER"
fi

chown -R "$TARGET_USER":"$(id -g "$TARGET_USER")" "/home/$TARGET_USER"

if [ "$#" -eq 0 ]; then
    set -- /bin/bash
fi

exec runuser -u "$TARGET_USER" -- "$@"
