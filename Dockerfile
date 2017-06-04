FROM php:7.1-fpm
COPY ./php.ini /usr/local/etc/php/php.ini

ENV REDIS_VERSION 3.1.2
ENV XDEBUG_VERSION 2.5.4
RUN pecl install redis-$REDIS_VERSION \
    && pecl install xdebug-$XDEBUG_VERSION \
    && docker-php-ext-enable redis xdebug

RUN apt-get update && apt-get install -y \
      libfreetype6-dev \
      libjpeg62-turbo-dev \
      libmcrypt-dev \
      libpng12-dev \
      libxml2-dev \
      libxslt-dev \
  && docker-php-ext-install -j$(nproc) iconv mcrypt \
  && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
  && docker-php-ext-install -j$(nproc) gd pdo pdo_mysql tokenizer xmlrpc dom xsl \
  && rm -rf /var/lib/apt/lists/* \
  && apt-get autoremove \
  && apt-get autoclean
