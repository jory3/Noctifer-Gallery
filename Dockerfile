FROM php:8.1.0RC2-apache

RUN a2enmod rewrite
RUN docker-php-ext-install pdo_mysql exif

RUN apt-get update -y && apt-get install -y libwebp-dev libjpeg62-turbo-dev libpng-dev libjpeg-dev libxpm-dev \
    libfreetype6-dev
RUN apt-get update && \
    apt-get install -y \
        zlib1g-dev

RUN apt-get install -y libzip-dev
RUN docker-php-ext-install zip

# RUN docker-php-ext-configure gd
RUN docker-php-ext-configure gd --with-jpeg

#RUN docker-php-ext-install gd
RUN docker-php-ext-install -j$(nproc) gd

RUN apt-get install -y sqlite3 libsqlite3-dev
RUN mkdir /db
RUN /usr/bin/sqlite3 /db/test.db

RUN docker-php-ext-install pdo_sqlite

RUN apt-get install -y libicu-dev && docker-php-ext-configure intl && docker-php-ext-install intl

RUN echo "php_admin_value[error_reporting] = E_ALL & ~E_NOTICE & ~E_WARNING & ~E_STRICT & ~E_DEPRECATED">>/usr/local/etc/php/php.ini

#USER www-data
#VOLUME /var/www/html/assets
#USER root

#COPY web-entrypoint.sh /tmp/web-entrypoint.sh
#RUN apt-get install -y dos2unix
#RUN dos2unix /tmp/web-entrypoint.sh
#RUN chmod a+x /tmp/web-entrypoint.sh
#ENTRYPOINT ["/tmp/web-entrypoint.sh"]
CMD ["apache2-foreground"]