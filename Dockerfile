FROM webdevops/php-nginx:8.1-alpine

ENV WEB_DOCUMENT_ROOT=/app \
    WEB_DOCUMENT_INDEX=index.php \
    WEB_ALIAS_DOMAIN=*.vm \
    WEB_PHP_TIMEOUT=600 \
    WEB_PHP_SOCKET=""
ENV WEB_PHP_SOCKET="127.0.0.1:9000"
ENV SERVICE_NGINX_CLIENT_MAX_BODY_SIZE="50m"

COPY conf/ /opt/docker/

RUN set -x \
    && apk update \
    && apk add \
        imagemagick \
        graphicsmagick \
        ghostscript \
        jpegoptim \
        pngcrush \
        libjpeg-turbo-utils \
        optipng \
        pngquant \
        # Install php (cli/fpm)
        php81-fpm \
        php81-json \
        php81-intl \
        php81-curl \
        php81-mysqli \
        php81-mysqlnd \
        php81-pdo_mysql \
        php81-pdo_pgsql \
        php81-pdo_sqlite \
        php81-gd \
        php81-pecl-imagick \
        php81-imap \
        php81-bcmath \
        php81-soap \
        php81-sqlite3 \
        php81-bz2 \
        php81-calendar \
        php81-ctype \
        php81-pcntl \
        php81-pgsql \
        php81-posix \
        php81-sockets \
        php81-sysvmsg \
        php81-sysvsem \
        php81-sysvshm \
        php81-xmlreader \
        php81-exif \
        php81-ftp \
        php81-gettext \
        php81-iconv \
        php81-zip \
        php81-zlib \
        php81-shmop \
        sqlite \
        php81-xsl \
        geoip \
        # php81-ldap \
        php81-pecl-memcached \
        # php81-redis \
        php81-pear \
        php81-phar \
        php81-openssl \
        php81-session \
        php81-opcache \
        php81-mbstring \
        php81-iconv \
        php81-pecl-apcu \
        php81-fileinfo \
        php81-simplexml \
        php81-tokenizer \
        php81-xmlwriter \
        nginx \
    && ln -s /usr/sbin/php-fpm7 /usr/sbin/php-fpm \
    && pecl channel-update pecl.php.net \
    # Temporarily disable pear due to https://twitter.com/pear/status/1086634389465956352
    # && pear channel-update pear.php.net \
    # && pear upgrade-all \
    && pear config-set auto_discover 1 \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer \
    # PECL workaround, see webdevops/Dockerfile#78
    && sed -i "s/ -n / /" $(which pecl) \
    # Enable php services
    && docker-service enable syslog \
    && docker-service enable cron \
    && docker-run-bootstrap \
    && docker-image-cleanup


EXPOSE 80 443