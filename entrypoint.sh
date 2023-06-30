#!/usr/bin/env sh

if [ -d /var/www/html/.docker/prod/scripts ]; then
    for f in /var/www/html/.docker/prod/scripts/*.sh; do
        bash "$f" || break
    done
fi

chown -R www-data:www-data /var/www/html

if [ $# -gt 0 ]; then
    exec "$@"
else
    exec php /var/www/html/artisan octane:start --server=swoole --host=0.0.0.0 --port=8000
fi
