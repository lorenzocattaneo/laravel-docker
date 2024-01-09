FROM php:8.2-fpm-bookworm

# Types: octane-swoole, octane-rr, fpm, octane-frankenphp
ENV SERVER_TYPE='fpm' 

# Install dependencies
RUN apt-get update  \
    && apt-get install -y \
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

# Setup working directory
WORKDIR /var/www/html
EXPOSE 80
EXPOSE 8000
ENTRYPOINT ["/entrypoint.sh"]
