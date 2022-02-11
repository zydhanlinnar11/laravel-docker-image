FROM php:8.1.2-fpm-alpine

# Change timezone
RUN echo "Asia/Jakarta" > /etc/timezone

# Install composer
COPY --from=composer /usr/bin/composer /usr/bin/composer

# Configure supervisor
RUN apk add --no-cache supervisor
RUN mkdir -p /etc/supervisor.d/
RUN mkdir -p /var/log/supervisord/
COPY config/supervisord.ini /etc/supervisor.d/supervisord.ini

# Configure nginx
RUN apk add --no-cache nginx
RUN mkdir -p /etc/nginx
COPY config/laravel.conf /etc/nginx/http.d/default.conf

# Configure php extensions
RUN docker-php-ext-install bcmath

# Additional php configuration
COPY config/php-jakarta-timezone.ini /usr/local/etc/php/conf.d/php-jakarta-timezone.ini

EXPOSE 80

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor.d/supervisord.ini"]