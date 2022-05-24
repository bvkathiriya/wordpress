FROM bruceemmanuel/php7.4-apache
RUN docker-php-ext-install mysqli
# App Settings
COPY vhost.conf /etc/apache2/sites-available/000-default.conf
COPY ./application/ /var/www/html
WORKDIR /var/www/html
WORKDIR /var/www/html/wp-content/plugins
WORKDIR /var/www/html/wp-content/uploads
RUN chown -R www-data:www-data /var/www/html
RUN find /var/www/html -type d -exec chmod 0755 {} \;
RUN find /var/www/html -type f -exec chmod 644 {} \;

