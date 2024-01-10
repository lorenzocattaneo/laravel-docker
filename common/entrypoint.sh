#!/usr/bin/env sh


if [ $SERVER_TYPE != "octane-frankenphp" ]; then
  cp /etc/nginx/templates/nginx-$SERVER_TYPE.conf /etc/nginx/sites-enabled/default
  cp /etc/supervisor/templates/nginx.conf /etc/supervisor/conf.d/nginx.conf
fi

cp /etc/supervisor/templates/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
cp /etc/supervisor/templates/$SERVER_TYPE.conf /etc/supervisor/conf.d/server.conf

if [ -d /var/www/html/.docker/prod/scripts ]; then
    for f in /var/www/html/.docker/prod/scripts/*.sh; do
        bash "$f" || break
    done
fi

if [ ! -d /var/www/html/frankenphp -a $SERVER_TYPE = "octane-frankenphp" ]; then
    echo "yes" | php artisan octane:install --server=frankenphp
fi

if [ ! -d /var/www/html/rr -a $SERVER_TYPE = "octane-rr" ]; then
    echo "yes" | php /var/www/html/artisan octane:install --server=roadrunner
fi

/var/www/html/php artisan icons:clear
/var/www/html/php artisan optimize:clear
/var/www/html/php artisan optimize
/var/www/html/php artisan view:cache
/var/www/html/php artisan icons:cache
/var/www/html/php artisan event:cache

if [ $# -gt 0 ]; then
    exec "$@"
else
    exec supervisord -c /etc/supervisor/supervisord.conf
fi
