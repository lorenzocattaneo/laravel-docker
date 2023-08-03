#!/usr/bin/env sh

cp /etc/nginx/templates/nginx-$SERVER_TYPE.conf /etc/nginx/sites-enabled/default
cp /etc/supervisor/templates/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
cp /etc/supervisor/templates/nginx.conf /etc/supervisor/conf.d/nginx.conf
cp /etc/supervisor/templates/$SERVER_TYPE.conf /etc/supervisor/conf.d/$SERVER_TYPE.conf

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
