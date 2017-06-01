ARG PHP_VERSION=7.1-fpm
FROM php:${PHP_VERSION}
COPY ./php.ini /usr/local/etc/php/php.ini

ARG XDEBUG_VERSION=2.5.3
ARG XDEBUG_MD5=daefc2b4dc85c47ddd3a3d50b258342e
RUN curl -SL "http://www.xdebug.org/files/xdebug-${XDEBUG_VERSION}.tgz" -o xdebug.tgz \
    && echo ${XDEBUG_MD5} xdebug.tgz | md5sum -c - \
    && mkdir -p ./xdebug \
    && tar -xf xdebug.tgz -C ./xdebug --strip-components=1

RUN cd /usr/src/xdebug \
    && phpize \
    && ./configure \
    && make -j"$(nproc)" \
    && make install \
    && make clean \
    && cd .. \
    && rm -rf xdebug

COPY ./ext-xdebug.ini /usr/local/etc/php/conf.d/ext-xdebug.ini
RUN apt-get update \
    && apt-get install -y libmagickwand-dev --no-install-recommends \
    && rm -rf /var/lib/apt/lists/* \
    && pecl install imagick \
    && docker-php-ext-enable imagick \
    && docker-php-ext-configure gd --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j4 gd mbstring mysqli pdo pdo_mysql shmop
