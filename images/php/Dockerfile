ARG PHP_VERSION=7.2
FROM php:${PHP_VERSION}-fpm

LABEL maintainer="snezhig.git@gmail.com"

WORKDIR /var/www

####################BASE INSTALL####################
ARG COMPOSER_VERSION=''

RUN apt-get update && apt-get install -y curl wget openssh-client git libzip-dev libgd-dev libfreetype6 libmcrypt-dev zip supervisor

RUN if [ -n "${COMPOSER_VERSION}" ]; then COMPOSER_VERSION="--version=${COMPOSER_VERSION}";fi;\
 curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer ${COMPOSER_VERSION}

RUN docker-php-ext-install mysqli -j$(nproc) calendar opcache && \
    docker-php-ext-configure opcache --enable-opcache && \
    docker-php-ext-install sockets

ARG XDEBUG_VERSION=''
ARG XDBG_PACKAGE="xdebug"

RUN if [ -n "${XDEBUG_VERSION}" ];\
 then XDBG_PACKAGE="${XDBG_PACKAGE}-${XDEBUG_VERSION}";fi;\
 pecl install ${XDBG_PACKAGE} mcrypt

###############region conditions for php version###############
##7.2 or lower
RUN if [ "${PHP_VERSION%.*}" \< "7.3" ];then \
    docker-php-ext-configure zip --with-libzip; \
    fi
##7.3 or lower
RUN if [ "${PHP_VERSION%.*}" \< "7.4" ];then \
    docker-php-ext-install -j$(nproc) mbstring && \
    docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/; \
    fi
##only 7.4
RUN if [ "${PHP_VERSION%.*}" = "7.4" ];then \
    docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/; \
    fi

###############endregion###############

RUN docker-php-ext-install zip gd

COPY php.ini                       $PHP_INI_DIR/php.ini
COPY php-fpm.d                     $PHP_INI_DIR/pool.d/
COPY conf.d                        $PHP_INI_DIR/conf.d/

ARG PHP_MBSTRING_FUNC_OVERLOAD=2
RUN sed -ri 's/@mbstring_func_overload@/'$PHP_MBSTRING_FUNC_OVERLOAD'/' $PHP_INI_DIR/php.ini

ARG XDEBUG_MODE='debug'
RUN echo "xdebug.mode=$XDEBUG_MODE" >>  $PHP_INI_DIR/conf.d/99-xdebug.ini

###############region SSH###############
ARG SET_UP_SSH_SERVER=N
ENV SET_UP_SSH_SERVER $SET_UP_SSH_SERVER


RUN if [ "$SET_UP_SSH_SERVER" = "Y" ]; \
    then apt update && apt install -y openssh-server \
    && mkdir /var/run/sshd \
    && sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config \
    && echo 'root:root' | chpasswd; fi

###############endregion###############

###############region mailhog###############
ARG SET_UP_MAILHOG=N
RUN if [ "$SET_UP_MAILHOG" = "Y" ]; \
    then curl -sSL https://github.com/mailhog/mhsendmail/releases/download/v0.2.0/mhsendmail_linux_amd64 -o mhsendmail \
    && chmod +x mhsendmail \
    && mv mhsendmail /usr/local/bin/mhsendmail \
    && echo 'sendmail_path = "/usr/local/bin/mhsendmail --smtp-addr=mailhog:1025"' >> /usr/local/etc/php/php.ini; \
    fi
###############endregion###############


###############region memcache###############
ARG SET_UP_MEMCACHE=Y
ARG MEMCACHE_VERSION=''
ARG MEMCACHE_PACKAGE="memcache-${MEMCACHE_VERSION}"
RUN if [ "$SET_UP_MEMCACHE" = "Y" ]; \
    then pecl install  "${MEMCACHE_PACKAGE%-}" && echo "extension=memcache.so" > /usr/local/etc/php/conf.d/ext-memcache.ini; \
    fi
###############endregion###############

###############region cron###############
COPY cron.d /etc/cron.d
RUN apt --allow-releaseinfo-change update && apt install -y cron && chmod 644 /etc/cron.d/www && crontab /etc/crontab
RUN rm -rf /var/lib/apt/lists/*
###############endregion###############

ARG USER_ID
ARG GROUP
RUN usermod -u "$USER_ID" -a -G "$GROUP" www-data

COPY startup /startup
COPY supervisor.conf /etc/supervisor/conf.d/

EXPOSE 9000 22