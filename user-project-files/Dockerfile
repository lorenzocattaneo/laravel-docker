FROM composer:2.9 AS composer
WORKDIR /app
COPY . .
RUN composer install --optimize-autoloader --no-dev --ignore-platform-reqs

FROM node:22 AS node-builder
WORKDIR /app
COPY . .
COPY --from=composer /app/vendor /app/vendor
RUN npm install  \
    && npm run build

FROM lorenzocattaneo/laravel:8.5
COPY --chown=www-data . /var/www/html
COPY --from=composer --chown=www-data /app/vendor ./vendor/
COPY --from=node-builder --chown=www-data /app/public /var/www/html/public/
