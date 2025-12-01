
FROM lorenzocattaneo/laravel:8.4

# Types: octane-swoole, octane-rr, octane-frankenphp, fpm
ENV SERVER_TYPE='fpm' 
ENV SHELL /bin/bash

USER root

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# Install dependencies
RUN apt-get update  \
    && apt-get install -y \
    git \
    lsof \
    wget \
    htop \
    vim \
    && rm -rf /var/lib/apt/lists/*

COPY ./common/dev/supervisor /etc/supervisor/templates
COPY ./common/dev/entrypoint.sh /entrypoint.sh
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

EXPOSE 5173
EXPOSE 8000
EXPOSE 13714
ENTRYPOINT ["/entrypoint.sh"]
