FROM rshop/php:7.4

ENV SWOOLE_VERSION v4.6.5

RUN apk update \
    && apk add --no-cache \
        libstdc++ \
        openssl \
    && apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
        libaio-dev \
        openssl-dev \
    && curl -SL "https://github.com/swoole/swoole-src/archive/${SWOOLE_VERSION}.tar.gz" -o /tmp/swoole.tar.gz \
    && cd /tmp \
    && mkdir swoole \
    && tar -xf swoole.tar.gz -C swoole --strip-components=1 \
    && ln -s /usr/bin/phpize7 /usr/local/bin/phpize \
    && ln -s /usr/bin/php-config7 /usr/local/bin/php-config \
    && ( \
        cd swoole \
        && phpize \
        && ./configure --enable-mysqlnd --enable-openssl --enable-http2 \
        && make -s -j$(nproc) && make install \
    ) \
    && echo "extension=swoole.so" > /etc/php7/conf.d/50_swoole.ini \
    && rm /etc/php7/conf.d/xdebug.ini \
    && apk del .build-deps \
    && apk del --purge *-dev \
    && rm -rf /var/cache/apk/* /tmp/* /usr/share/man /usr/local/bin/php*

COPY conf.d/* /etc/php7/conf.d/

EXPOSE 9501
