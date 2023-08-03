FROM composer:2.5 as composer
WORKDIR /app
COPY . .
RUN composer install --optimize-autoloader --no-dev

FROM node:18 as node-builder
WORKDIR /app
COPY . .
COPY --from=composer /app/vendor /app/vendor
RUN npm install  \
    && npm run build

FROM lorenzocattaneo/laravel:8.2
COPY . /var/www/html
COPY --from=composer /app/vendor ./vendor
COPY --from=node-builder /app/public /var/www/html/public-npm
RUN rsync -ar /var/www/html/public-npm/ /var/www/html/public/ \
    && rm -rf /var/www/html/public-npm \
    && chown -R www-data:www-data /var/www/html

