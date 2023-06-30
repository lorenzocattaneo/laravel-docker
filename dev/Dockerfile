FROM lorenzocattaneo/laravel:8.2

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# Install dependencies
RUN apt-get update  \
    && apt-get install -y \
    git \
    wget \
    htop \
    vim \
    nodejs \
    && rm -rf /var/lib/apt/lists/*

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Setup working directory
WORKDIR /var/www/html
EXPOSE 8000
ENTRYPOINT ["/entrypoint.sh"]
