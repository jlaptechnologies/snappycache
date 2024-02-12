FROM php:8.3.2-cli-alpine3.19 as base

RUN apk add --no-cache --virtual .build-deps g++ make automake autoconf libev-dev && \
    pecl install -a --configureoptions 'enable-ev-debug="no"' ev

LABEL authors="justin.patchett@jlaptech.co.uk"

FROM php:8.3.2-cli-alpine3.19 as app

RUN apk add --no-cache libev

COPY --from=base \
    /usr/local/lib/php/extensions/no-debug-non-zts-20230831/ev.so \
    /usr/local/lib/php/extensions/no-debug-non-zts-20230831/ev.so

# Run as www-data with same user id
RUN deluser --remove-home www-data \
    && adduser -u1000 -D www-data

LABEL authors="justin.patchett@jlaptech.co.uk"
