ARG PHP_VERSION=7.2
FROM php:${PHP_VERSION}-fpm

MAINTAINER snezhig

WORKDIR /var/www

####################BASE INSTALL####################
ARG COMPOSER_VERSION=1.10.16

RUN apt-get update && apt-get install -y curl wget openssh-client git libgd-dev libfreetype6 libmcrypt-dev && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer --version="${COMPOSER_VERSION}" && \
    docker-php-ext-install mysqli -j$(nproc) gd calendar mbstring opcache && \
    docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && \
    docker-php-ext-configure opcache --enable-opcache && \
    docker-php-ext-install gd && docker-php-ext-install sockets

RUN if [ "${PHP_VERSION%.*}" \< "7.3" ];then docker-php-ext-install -j$(nproc) zip; fi

ARG XDEBUG_VERSION=3.0.0
ARG XDG_PACKAGE="xdebug-${XDEBUG_VERSION}"

RUN pecl install ${XDG_PACKAGE} mcrypt \
    && if [ "${PHP_VERSION%.*}" \> "7.2" ];\
    then apt-get update && apt-get install -y libzip-dev && docker-php-ext-install zip;\
    fi



COPY php.ini                       $PHP_INI_DIR/php.ini
COPY php-fpm.d                     $PHP_INI_DIR/pool.d/
COPY conf.d                        $PHP_INI_DIR/conf.d/
COPY php-starter.sh /tmp/

ARG PHP_MBSTRING_FUNC_OVERLOAD=2
RUN sed -ri 's/@mbstring_func_overload@/'$PHP_MBSTRING_FUNC_OVERLOAD'/' $PHP_INI_DIR/php.ini

###############region SSH###############
ARG SET_UP_SSH_SERVER=N
ENV SET_UP_SSH_SERVER $SET_UP_SSH_SERVER


RUN if [ "$SET_UP_SSH_SERVER" = "Y" ]; \
    then apt update && apt install -y openssh-server supervisor \
    && mkdir /var/run/sshd \
    && sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config \
    && echo 'root:root' | chpasswd; fi

COPY supervisor.conf /etc/supervisor/conf.d/
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

###############region cron###############
COPY cron.d /etc/cron.d
RUN apt install -y cron && chmod 644 /etc/cron.d/www && crontab /etc/crontab && rm -rf /var/lib/apt/lists/*
###############endregion###############

RUN usermod -u 1000 -a -G www-data www-data
EXPOSE 9000 22