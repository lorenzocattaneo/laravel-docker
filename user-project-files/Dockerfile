FROM composer:2.5 AS composer
WORKDIR /app
COPY . .
RUN composer install --optimize-autoloader --no-dev --ignore-platform-reqs

FROM node:18 AS node-builder
WORKDIR /app
COPY . .
COPY --from=composer /app/vendor /app/vendor
RUN npm install  \
    && npm run build

FROM lorenzocattaneo/laravel:8.4
COPY --chown=www-data . /var/www/html
COPY --from=composer --chown=www-data /app/vendor ./vendor/
COPY --from=node-builder --chown=www-data /app/public /var/www/html/public/
