FROM php:7.3-apache
RUN apt-get update
 
 
# 2. apache configs + document root
RUN sed -ri -e 's!/var/www/html!/var/www/html!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!/var/www/html!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf
 
# 3. mod_rewrite for URL rewrite and mod_headers for .htaccess extra headers like Access-Control-Allow-Origin-
RUN a2enmod rewrite headers
 
# 4. start with base php config, then add extensions
#RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"
 
# RUN docker-php-ext-configure gd --with-freetype --with-jpeg
 
RUN docker-php-ext-install \
    iconv \
    calendar \
    mbstring \
    pdo_mysql \
    gd \
    zip \
    exif \
    ldap  
 
RUN docker-php-ext-install mysqli
# GRPC
#RUN pecl install grpc
#RUN bash -c "echo extension=grpc.so > $PHP_INI_DIR/php.ini"
 
# Install composer
#RUN curl -sS https://getcomposer.org/installer | php
#RUN mv composer.phar /usr/local/bin/composer && chmod +x /usr/local/bin/composer && composer self-update --preview
#RUN command -v composer
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf
RUN chown -R www-data:www-data /var/www/html
RUN find /var/www/html -type d -exec chmod 0755 {} \;
RUN find /var/www/html -type f -exec chmod 644 {} \;
 
# App Settings
COPY vhost.conf /etc/apache2/sites-available/000-default.conf
COPY ./application/ /var/www/html
#COPY .env.example /var/www/html/.env
# COPY --chown=www:www . /var/www/html
 
WORKDIR /var/www/html
WORKDIR /var/www/html/wp-content/plugins
WORKDIR /var/www/html/wp-content/uploads
