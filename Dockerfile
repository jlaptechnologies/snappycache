############################################
############################################
FROM php:8.3.2-cli-alpine3.19 as base

RUN apk add --no-cache --virtual .build-deps g++ make automake autoconf libev-dev && \
    pecl install -a --configureoptions 'enable-ev-debug="no"' ev

############################################
############################################
FROM php:8.3.2-cli-alpine3.19 as build

LABEL authors="justin.patchett@jlaptech.co.uk"

COPY ./docker/php/usr/local/etc/php/php.ini /usr/local/etc/php/php.ini

RUN apk add --no-cache libev

COPY --from=base \
    /usr/local/lib/php/extensions/no-debug-non-zts-20230831/ev.so \
    /usr/local/lib/php/extensions/no-debug-non-zts-20230831/ev.so

RUN docker-php-ext-enable ev.so sodium.so

# Run as www-data with same user id
RUN deluser --remove-home www-data && \
    adduser -u1000 -D www-data && \
    mkdir /app && \
    chown www-data:www-data /app

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

USER www-data

WORKDIR /app

############################################
############################################
FROM build as app

COPY ./src /app

WORKDIR /app

CMD ["php", "-a"]

############################################
############################################
FROM build as phpunit

WORKDIR /tmp

USER root

RUN wget -O phpunit.phar https://phar.phpunit.de/phpunit-10.phar && \
    mv ./phpunit.phar /usr/bin/phpunit && \
    chmod +x /usr/bin/phpunit

USER www-data

WORKDIR /app
