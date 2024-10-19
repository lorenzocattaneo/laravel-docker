FROM php:8.2-fpm-bookworm

# Types: octane-swoole, octane-rr, fpm, octane-frankenphp
ENV SERVER_TYPE='fpm' 

# Install dependencies
RUN apt-get update  \
    && apt-get install -y \
    libffi-dev \
    libicu-dev \
    libpq-dev \
    libmagickwand-dev \
    libfreetype-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libzip-dev \
    libxml2-dev \
    zip \
    unzip \
    cron \
    nginx \
    supervisor \
    rsync \
    && rm -rf /var/lib/apt/lists/*

# Install php extensions
RUN pecl install \
        apcu \
        redis \
        swoole \
        imagick \
        && docker-php-ext-enable \
        apcu \
        redis \
        swoole \
        imagick \
        && docker-php-ext-configure gd --with-freetype --with-jpeg \
        && docker-php-ext-install \
        ffi \
        bcmath \
        calendar \
        exif \
        gd \
        intl \
        pdo_mysql \
        pdo_pgsql \
        pcntl \
        soap \
        zip

COPY ./common/nginx /etc/nginx/templates
COPY ./common/supervisor /etc/supervisor/templates
COPY ./common/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set file permissions
RUN chown -R www-data:www-data /var/www/
RUN chown -R www-data:www-data /var/log/
RUN chown -R www-data:www-data /etc/nginx/
RUN chown -R www-data:www-data /etc/supervisor/
RUN chown -R www-data:www-data /var/run/
RUN chown -R www-data:www-data /var/lib/nginx/

# Setup working directory
WORKDIR /var/www/html
USER www-data

EXPOSE 80
EXPOSE 8000
ENTRYPOINT ["/entrypoint.sh"]
