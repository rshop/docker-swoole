FROM hyperf/hyperf:7.4-alpine-v3.10-cli

RUN apk update \
    && apk add --no-cache \
        php7-bz2 \
        php7-intl \
        php7-imap \
        php7-opcache \
        php7-soap

ENV PHP_DISPLAY_ERRORS On
ENV PHP_MAX_EXECUTION_TIME -1
ENV PHP_MEMORY_LIMIT -1
ENV PHP_OPCACHE_REVALIDATE_FREQ 0
ENV PHP_OPCACHE_VALIDATE_TIMESTAMPS 0
ENV PHP_UPLOAD_MAX_FILESIZE 8M
ENV PHP_SESSION_SAVE_HANDLER files
ENV PHP_SESSION_SAVE_PATH /tmp
ENV PHP_SESSION_GC_MAXLIFETIME 1440

COPY conf.d/* /etc/php7/conf.d/

EXPOSE 9501
