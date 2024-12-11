
FROM php:8.4-fpm-bookworm

# Types: octane-swoole, octane-rr,octane-frankenphp, fpm
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
        swoole-6.0.0RC1 \
        #imagick \
        && docker-php-ext-enable \
        apcu \
        redis \
        swoole \
        #imagick \
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
