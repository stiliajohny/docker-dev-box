#!/bin/bash
set -e

export noVNC_version=1.2.0

# Run init.sh if it exists
[[ -f /scripts/init.sh ]] && /scripts/init.sh && rm /scripts/init.sh

umask 0077                # use safe default permissions
mkdir -p "$HOME/.vnc"
chmod go-rwx "$HOME/.vnc" # enforce safe permissions

# Start TigerVNC
if [ ! -z $VNC_PASSWD ]; then
	vncpasswd -f <<< "$VNC_PASSWD" > "$HOME/.vnc/passwd"
fi

vncsession root :0

# Start noVNC
/noVNC-${noVNC_version}/utils/launch.sh
