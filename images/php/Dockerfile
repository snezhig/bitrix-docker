ARG PHP_VERSION=7.2
FROM php:${PHP_VERSION}-fpm as base

MAINTAINER snezhig

WORKDIR /var/www

####################BASE INSTALL####################
RUN apt-get update && apt-get install -y curl wget openssh-client git libgd-dev libfreetype6 libmcrypt-dev

ARG COMPOSER_VERSION=1.10.16

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer --version="${COMPOSER_VERSION}" && \
docker-php-ext-install mysqli -j$(nproc) gd calendar mbstring opcache && \
docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && \
docker-php-ext-configure opcache --enable-opcache

RUN if [ "${PHP_VERSION%.*}" \< "7.3" ];then docker-php-ext-install -j$(nproc) zip; fi
RUN usermod -u 1000 www-data

COPY php-starter.sh /tmp/

####################region SSH####################
ARG SET_UP_SSH_SERVER=false
ENV SET_UP_SSH_SERVER $SET_UP_SSH_SERVER


RUN if [ "$SET_UP_SSH_SERVER" = "true" ]; \
    then apt update && apt install -y openssh-server supervisor \
    && mkdir /var/run/sshd \
    && sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config \
    && echo 'root:root' | chpasswd; fi

COPY supervisor.conf /etc/supervisor/conf.d/
####################endregion####################

RUN rm -rf /var/lib/apt/lists/*

COPY php-fpm.d                     $PHP_INI_DIR/pool.d/
COPY conf.d                        $PHP_INI_DIR/conf.d/


EXPOSE 9000 22


####################PHP-5.6####################
FROM base as php-56
RUN if [ "${PHP_VERSION%.*}" = "5.6" ]; \
    then BEFORE_PWD=$(pwd) \
    && mkdir -p /opt/xdebug \
    && cd /opt/xdebug \
    && curl -k -L https://github.com/xdebug/xdebug/archive/XDEBUG_2_5_5.tar.gz | tar zx \
    && cd xdebug-XDEBUG_2_5_5 \
    && phpize \
    && ./configure --enable-xdebug \
    && make clean \
    && sed -i 's/-O2/-O0/g' Makefile \
    && make \
    && make install \
    && cd "${BEFORE_PWD}" \
    && docker-php-ext-enable xdebug \
    && rm -r /opt/xdebug \
    && docker-php-ext-install mysql; fi


####################PHP-7.x####################
FROM base as php-7
ARG XDEBUG_VERSION=3.0.0
ARG XDG_PACKAGE="xdebug-${XDEBUG_VERSION}"

RUN pecl install ${XDG_PACKAGE} mcrypt
RUN if [ "${PHP_VERSION%.*}" \> "7.2" ];\
then apt-get update && apt-get install -y libzip-dev && docker-php-ext-install zip;\
fi