FROM php:8.2-fpm-bookworm

# Types: octane-swoole, octane-rr, fpm
ARG SERVER_TYPE='octane-swoole' 

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

COPY ./nginx/nginx-${SERVER_TYPE}.conf /etc/nginx/sites-available/default
COPY ./supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY ./supervisor/nginx.conf /etc/supervisor/conf.d/nginx.conf
COPY ./supervisor/${SERVER_TYPE}.conf /etc/supervisor/conf.d
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Setup working directory
WORKDIR /var/www/html
EXPOSE 8000
ENTRYPOINT ["/entrypoint.sh"]
