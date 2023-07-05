FROM php:8.2-fpm-bookworm

# Types: octane-swoole, octane-rr, fpm
ENV SERVER_TYPE='octane-swoole' 

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
    zip \
    unzip \
    cron \
    nginx \
    supervisor \
    && rm -rf /var/lib/apt/lists/*

# Install php extensions
RUN pecl install \
        redis \
        swoole \
        imagick \
        && docker-php-ext-enable \
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

COPY ./nginx /etc/nginx/templates
COPY ./supervisor /etc/supervisor/templates
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Setup working directory
WORKDIR /var/www/html
EXPOSE 8000
ENTRYPOINT ["/entrypoint.sh"]
