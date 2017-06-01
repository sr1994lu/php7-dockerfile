FROM php:7.1-fpm
COPY ./php.ini /usr/local/etc/php/php.ini

ENV XDEBUG_VERSION 2.5.1
ENV XDEBUG_MD5 6167b1e104f1108d77f08eb561a12b22
RUN set -x \
  && curl -SL "http://www.xdebug.org/files/xdebug-$XDEBUG_VERSION.tgz" -o xdebug.tgz \
  && echo $XDEBUG_MD5 xdebug.tgz | md5sum -c - \
  && mkdir -p /usr/src/xdebug \
  && tar -xf xdebug.tgz -C /usr/src/xdebug --strip-components=1 \
  && rm xdebug.* \
  && cd /usr/src/xdebug \
  && phpize \
  && ./configure \
  && make -j"$(nproc)" \
  && make install \
  && make clean
COPY ./ext-xdebug.ini /usr/local/etc/php/conf.d/ext-xdebug.ini

RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
    && docker-php-ext-install -j$(nproc) iconv mcrypt \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd mbstring pdo pdo_mysql
