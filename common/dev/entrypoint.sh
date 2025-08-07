#!/usr/bin/env sh

echo "entrypoint init"

if [ $SERVER_TYPE != "octane-frankenphp" ]; then
  echo "copying nginx config files"
  cp /etc/nginx/templates/nginx-$SERVER_TYPE.conf /etc/nginx/sites-enabled/default
  cp /etc/supervisor/templates/nginx.conf /etc/supervisor/conf.d/nginx.conf
fi

echo "copying default supervisor config files"
cp /etc/supervisor/templates/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
cp /etc/supervisor/templates/npm.conf /etc/supervisor/conf.d/npm.conf
cp /etc/supervisor/templates/$SERVER_TYPE.conf /etc/supervisor/conf.d/$SERVER_TYPE.conf

if [ -d /var/www/html/.docker/dev/supervisor ]; then
  echo "copying additional supervisor config files"
  cp /var/www/html/.docker/dev/supervisor/*.conf /etc/supervisor/conf.d/
fi

if [ -d /var/www/html/.docker/dev/php ]; then
  echo "copying additional php .ini files"
  cp /var/www/html/.docker/dev/php/*.ini /usr/local/etc/php/conf.d/
fi

if [ -d /var/www/html/.docker/dev/pre-init-scripts ]; then
  echo "running pre init scripts"
  for f in /var/www/html/.docker/dev/pre-init-scripts/*.sh; do
    bash "$f" || break
  done
fi

case "$SERVER_TYPE" in
octane*) if grep -q "laravel/octane" "composer.json"; then
  echo 'laravel/octane already installed'
else
  echo "installing laravel octane" && composer require laravel/octane
fi ;;
*) echo using php-fpm ;;
esac

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

php /var/www/html/artisan storage:link -q
echo "y" | php /var/www/html/artisan migrate

if [ -d /var/www/html/.docker/dev/post-init-scripts ]; then
  echo "running post init scripts"
  for f in /var/www/html/.docker/dev/post-init-scripts/*.sh; do
    bash "$f" || break
  done
fi

if [ $# -gt 0 ]; then
  echo "executing command"
  exec "$@"
else
  echo "starting supervisord"
  exec supervisord -c /etc/supervisor/supervisord.conf
fi
