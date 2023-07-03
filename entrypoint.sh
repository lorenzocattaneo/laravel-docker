#!/usr/bin/env sh

if [ -d /var/www/html/.docker/prod/scripts ]; then
    for f in /var/www/html/.docker/prod/scripts/*.sh; do
        bash "$f" || break
    done
fi

if [ $# -gt 0 ]; then
    exec "$@"
else
    exec supervisord -c /etc/supervisor/supervisord.conf
fi
