#!/bin/bash

# turn on bash's job control
set -m

# Cleanup env variables 
for i in $(set | grep "_SERVICE_\|_PORT" | cut -f1 -d=); do unset $i; done

# Start the primary process and put it in the background
FILEBROWSER_CONFIG_DIR=/usr/local/bin/  /usr/local/bin/filebrowser serve &

# Set a bash_profile with username and current directory
source /home/developer/.bash_profile

if [[ "$1" == "Y" ]] || [[ "$1" == "y" ]]
then
ttyd -a -p 9090  -I /usr/bin/index.html /usr/local/bin/session_start.sh
    exit 1
else
    ttyd -a -p 9090  -I /usr/bin/index.html /usr/local/bin/session_start.sh &
fi
# Start ttyd
#ttyd  -p 9090  /bin/bash
# custom index.html is hanging  once we figure it out we can remove it
# ttyd  -p 9090  -I /usr/bin/index.html /bin/bash
# ttyd -a -p 9090  -I /usr/bin/index.html /usr/local/bin/session_start.sh
