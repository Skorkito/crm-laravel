FROM dunglas/frankenphp:1.8-php8.4

# Set Caddy server name to "http://" to serve on 80 and not 443
# Read more: https://frankenphp.dev/docs/config/#environment-variables
ENV SERVER_NAME="http://"

ENV WITH_HORIZON=false \
    WITH_SCHEDULER=false \
    USER=www-data \
    ROOT=/var/www/html

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    git \
    curl \
    wget \
    nano \
    ncdu \
    procps \
    ca-certificates \
    supervisor \
    libsodium-dev \
    # Install Node.js and npm
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    # Install PHP extensions
    && install-php-extensions \
    bz2 \
    pcntl \
    mbstring \
    bcmath \
    sockets \
    pgsql \
    pdo_pgsql \
    opcache \
    exif \
    pdo_mysql \
    zip \
    intl \
    gd \
    redis \
    rdkafka \
    memcached \
    igbinary \
    ldap

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

# Copy the Laravel application files into the container.
COPY ./src ./

# Start with base PHP config, then add extensions.
COPY ./docker/php/php.ini /usr/local/etc/php/
COPY ./docker/etc/supervisor.d/supervisord.dev.conf /etc/supervisor/conf.d/supervisord.conf

# Install Laravel dependencies using Composer (with dev dependencies for development)
RUN composer install --optimize-autoloader

# Install Node.js dependencies
RUN npm install

# Set permissions for Laravel.
RUN chown -R ${USER}:${USER} storage bootstrap/cache

EXPOSE 80 443

# Start Supervisor.
CMD ["/usr/bin/supervisord", "-n", "-c",  "/etc/supervisor/conf.d/supervisord.conf"]
