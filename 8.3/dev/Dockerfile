FROM lorenzocattaneo/laravel:8.3

# Types: octane-swoole, octane-rr, octane-frankenphp, fpm
ENV SERVER_TYPE='fpm' 

USER root

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

RUN curl -sL https://deb.nodesource.com/setup_20.x | bash -
# Install dependencies
RUN apt-get update  \
    && apt-get install -y \
    git \
    lsof \
    wget \
    htop \
    vim \
    nodejs \
    #npm \
    # Browsershot dependencies
    # gconf-service libasound2 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 libexpat1 libfontconfig1 libgbm1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 ca-certificates fonts-liberation libappindicator1 libnss3 lsb-release xdg-utils wget libgbm-dev libxshmfence-dev \
    # && npm install -g npm \
    # && npm install --unsafe-perm puppeteer \
    # End Browsershot dependencies
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
