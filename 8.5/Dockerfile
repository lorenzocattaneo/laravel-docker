
FROM php:8.5-fpm-bookworm

# Types: octane-swoole, octane-rr,octane-frankenphp, fpm
ENV SERVER_TYPE='fpm'
ENV SHELL /bin/bash

RUN curl -sL https://deb.nodesource.com/setup_22.x | bash -
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
    # puppeteer dependencies
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libatspi2.0-0 \
    libc6 \
    libcairo2 \
    libcups2 \
    libdbus-1-3 \
    libdrm2 \
    libexpat1 \
    libgbm1 \
    libglib2.0-0 \
    libnspr4 \
    libnss3 \
    libpango-1.0-0 \
    libpangocairo-1.0-0 \
    libstdc++6 \
    libudev1 \
    libuuid1 \
    libx11-6 \
    libx11-xcb1 \
    libxcb-dri3-0 \
    libxcb1 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxi6 \
    libxkbcommon0 \
    libxrandr2 \
    libxrender1 \
    libxshmfence1 \
    libxss1 \
    libxtst6 \
    # end puppeteer dependencies
    zip \
    unzip \
    cron \
    nginx \
    supervisor \
    rsync \
    nodejs \
    && rm -rf /var/lib/apt/lists/*


WORKDIR /home

# Install php extensions - Swoole is not supported yet
RUN pecl install \
        apcu \
        redis \
        #swoole \
        imagick \
        && docker-php-ext-enable \
        apcu \
        redis \
        #swoole \
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

RUN npm install puppeteer --location=global

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
