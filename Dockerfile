# Dockerfile
FROM php:8.1-fpm-alpine

# Install dependencies
RUN apk add --no-cache nginx supervisor bash \
    && docker-php-ext-install pdo pdo_mysql

# Copy Laravel app code
COPY . /var/www/html

WORKDIR /var/www/html

# Install Composer and dependencies
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
RUN composer install --no-dev --optimize-autoloader

# Copy nginx config
COPY ./nginx.conf /etc/nginx/nginx.conf

# Supervisor config to run PHP-FPM + Nginx
COPY ./supervisord.conf /etc/supervisord.conf

# Expose port 10000 as Render expects
EXPOSE 10000

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]