#!/usr/bin/env sh

if [ -d /var/www/html/.docker/dev/scripts ]; then
    for f in /var/www/html/.docker/dev/scripts/*.sh; do
        bash "$f" || break
    done
fi

if [ ! -d /var/www/html/vendor ]; then
    composer install
fi

if [ ! -d /var/www/html/node_modules ]; then
    npm install
fi

echo "y" | php /var/www/html/artisan migrate

if [ $# -gt 0 ]; then
    exec "$@"
else
    exec supervisord -c /etc/supervisor/supervisord.conf
fi
