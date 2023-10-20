FROM php:8.2-apache

WORKDIR /var/www/html

COPY --chown=www-data:www-data www/composer.json www/package.json /var/www/html/
COPY etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/000-default.conf

RUN a2enmod rewrite && service apache2 restart

RUN apt-get -y update && apt-get -y install vim libcurl4-openssl-dev pkg-config libssl-dev git libpng-dev libxml2-dev libzip-dev unzip

RUN curl -sL https://deb.nodesource.com/setup_18.x | bash - && apt-get install -y nodejs

RUN docker-php-ext-install mysqli pdo pdo_mysql gd soap zip

RUN pecl install mongodb && docker-php-ext-enable mongodb

RUN apt install -y libnss3-dev libgdk-pixbuf2.0-dev libgtk-3-dev libxss-dev chromium

RUN php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium

RUN chown -R 33:33 /var/www/

USER 0

RUN mkdir -p /var/www/html/vendor/ /var/www/html/node_modules/ /var/www/html/public/js/ /var/www/html/public/css/

RUN touch /var/www/html/package-lock.json /var/www/html/yarn.lock

RUN chown www-data:www-data /var/www/html/vendor/ /var/www/html/node_modules/ /var/www/html/package-lock.json /var/www/html/yarn.lock /var/www/html/public/js/ /var/www/html/public/css/

USER www-data
