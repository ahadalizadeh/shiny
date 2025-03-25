#!/bin/sh

# Make sure the directory for individual app logs exists
mkdir -p /var/log/shiny-server
chown shiny.shiny /var/log/shiny-server

mkdir -p  /srv/shiny-server/app1
mkdir -p  /srv/shiny-server/app2

cp -r /srv/apps/app1 /srv/shiny-server/app1
cp -r /srv/apps/app2 /srv/shiny-server/app2


if [ "$APPLICATION_LOGS_TO_STDOUT" != "false" ];
then
    # push the "real" application logs to stdout with xtail in detached mode
    exec xtail /var/log/shiny-server/ &
fi

# start shiny server
exec shiny-server 2>&1
