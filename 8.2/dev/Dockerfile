FROM lorenzocattaneo/laravel:8.2

# Types: octane-swoole, octane-rr, octane-frankenphp, fpm
ENV SERVER_TYPE='fpm' 
ENV LARAVEL_QUEUES='default'

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# Install dependencies
RUN apt-get update  \
    && apt-get install -y \
    git \
    lsof \
    wget \
    htop \
    vim \
    nodejs \
    npm \
    && rm -rf /var/lib/apt/lists/*

COPY ./common/dev/supervisor /etc/supervisor/templates
COPY ./common/dev/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Setup working directory
WORKDIR /var/www/html
EXPOSE 5173
EXPOSE 8000
EXPOSE 13714
ENTRYPOINT ["/entrypoint.sh"]
