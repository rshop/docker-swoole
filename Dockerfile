FROM rshop/php:8.0-mssql

ENV SWOOLE_VERSION v4.4.25

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
    && ln -s /usr/bin/phpize8 /usr/local/bin/phpize \
    && ln -s /usr/bin/php-config8 /usr/local/bin/php-config \
    && ( \
        cd swoole \
        && phpize \
        && ./configure --enable-mysqlnd --enable-openssl --enable-http2 \
        && make -s -j$(nproc) && make install \
    ) \
    && echo "extension=swoole.so" > /etc/php8/conf.d/50_swoole.ini \
    && apk del .build-deps \
    && apk del --purge *-dev \
    && rm -rf /var/cache/apk/* /tmp/* /usr/share/man /usr/local/bin/php*

COPY conf.d/* /etc/php8/conf.d/

EXPOSE 9501
