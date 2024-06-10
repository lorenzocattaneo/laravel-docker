FROM php:8.3-fpm-bookworm

# Types: octane-swoole, octane-rr,octane-frankenphp, fpm
ENV SERVER_TYPE='fpm' 
ENV LARAVEL_QUEUES='default'

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

# Install imagick extension
# The latest tagged version 3.7.0 is incompatible with php 8.3
# Build and install from master where the error is fixed
WORKDIR /home
RUN curl -L -o /tmp/imagick.tar.gz https://github.com/Imagick/imagick/archive/7088edc353f53c4bc644573a79cdcd67a726ae16.tar.gz \
    && tar --strip-components=1 -xf /tmp/imagick.tar.gz \
    && phpize \
    && ./configure \
    && make \
    && make install \
    && echo "extension=imagick.so" > /usr/local/etc/php/conf.d/ext-imagick.ini \
    && rm -rf /tmp/*

# Install php extensions
RUN pecl install \
        apcu \
        redis \
        swoole \
        #imagick \
        && docker-php-ext-enable \
        apcu \
        redis \
        swoole \
        #imagick \
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
