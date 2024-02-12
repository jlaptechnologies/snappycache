FROM php:8.3.2-cli-alpine3.19

RUN wget -O phpunit.phar https://phar.phpunit.de/phpunit-10.phar && \
    mv ./phpunit.phar /usr/bin/phpunit && \
    chmod +x /usr/bin/phpunit

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

COPY ../../../src /app

COPY ../../../docker/php/usr/local/etc/php/php.ini /usr/local/etc/php/php.ini

WORKDIR /app

RUN composer install -vvv && \
    phpunit
