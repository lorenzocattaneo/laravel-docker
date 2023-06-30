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

chown -R www-data:www-data /var/www/html

echo "y" | php /var/www/html/artisan migrate

if [ $# -gt 0 ]; then
    exec "$@"
else
    (npm run dev&)
    exec php /var/www/html/artisan octane:start --server=swoole --host=0.0.0.0 --port=8000 --watch
fi
