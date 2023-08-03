#!/usr/bin/env sh

cp /etc/nginx/templates/nginx-$SERVER_TYPE.conf /etc/nginx/sites-enabled/default
cp /etc/supervisor/templates/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
cp /etc/supervisor/templates/nginx.conf /etc/supervisor/conf.d/nginx.conf
cp /etc/supervisor/templates/$SERVER_TYPE.conf /etc/supervisor/conf.d/$SERVER_TYPE.conf

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
