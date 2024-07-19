# 1 Set master image
FROM php:8.3-apache
# 2 Set working directory
WORKDIR /var/www/html
# 3 Add and enable Extensions
RUN docker-php-ext-install pdo pdo_mysql mysqli
RUN docker-php-ext-enable pdo_mysql mysqli
# 4 Server settings
RUN echo "ServerName php-server" >> /etc/apache2/apache2.conf
# 5 Install and configure xDebug
RUN pecl install xdebug
RUN docker-php-ext-enable xdebug
RUN echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini
RUN echo "xdebug.mode=debug" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.client_port=9003" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.client_host=host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
# 6 Install PHP Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
# 7 Remove Cache
RUN rm -rf /var/cache/apt/*
# 8 Copy existing application directory permissions
COPY --chown=www-data:www-data . /var/www/html
# 9 Change current user to www
USER www-data
# 10 Export port 80
EXPOSE 80