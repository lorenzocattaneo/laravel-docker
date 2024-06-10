#!/usr/bin/env sh


if [ $SERVER_TYPE != "octane-frankenphp" ]; then
  cp /etc/nginx/templates/nginx-$SERVER_TYPE.conf /etc/nginx/sites-enabled/default
  cp /etc/supervisor/templates/nginx.conf /etc/supervisor/conf.d/nginx.conf
fi

cp /etc/supervisor/templates/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
cp /etc/supervisor/templates/npm.conf /etc/supervisor/conf.d/npm.conf
cp /etc/supervisor/templates/$SERVER_TYPE.conf /etc/supervisor/conf.d/$SERVER_TYPE.conf

if [ -d /var/www/html/.docker/dev/scripts ]; then
    for f in /var/www/html/.docker/dev/scripts/*.sh; do
        bash "$f" || break
    done
fi

if [ $SERVER_TYPE =~ "octane" ]; then
    composer require laravel/octane
fi

if [ ! -d /var/www/html/frankenphp -a $SERVER_TYPE = "octane-frankenphp" ]; then
    echo "yes" | php artisan octane:install --server=frankenphp
fi

if [ ! -d /var/www/html/rr -a $SERVER_TYPE = "octane-rr" ]; then
    echo "yes" | php /var/www/html/artisan octane:install --server=roadrunner
fi

if [ $SERVER_TYPE = "octane-swoole" ]; then
    echo "yes" | php /var/www/html/artisan octane:install --server=swoole
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
