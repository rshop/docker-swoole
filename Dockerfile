FROM rshop/php:7.3

RUN apk update \
    && apk add --no-cache \
        php7-swoole \
    && apk del --purge *-dev \
    && rm -rf /var/cache/apk/* /tmp/* /usr/share/man

COPY conf.d/* /etc/php7/conf.d/

EXPOSE 9501
