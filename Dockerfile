FROM composer:2.2.7 as build

WORKDIR /app
COPY . /app
RUN composer install
RUN php artisan key:generate

FROM php:7.4-apache
RUN docker-php-ext-install mysqli
RUN docker-php-ext-install \
    iconv \
    calendar \
    mbstring \
    pdo_mysql \
    gd \
    zip \
    exif \
    ldap  
RUN a2enmod rewrite headers

EXPOSE 80
COPY --from=build /app /var/www/html
WORKDIR /var/www/html/wp-content/plugins
WORKDIR /var/www/html/wp-content/uploads
RUN chown -R www-data:www-data /var/www/html
RUN find /var/www/html -type d -exec chmod 0755 {} \;
RUN find /var/www/html -type f -exec chmod 644 {} \;
#RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf
COPY vhost.conf /etc/apache2/sites-available/000-default.conf
RUN chown -R www-data:www-data /app \
    && a2enmod rewrite
