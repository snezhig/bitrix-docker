ARG DB_VERSION
ARG DB_TYPE=mariadb
FROM ${DB_TYPE}:${DB_VERSION}

MAINTAINER snezhig

ARG INNODB_FLUSH_METHOD=O_DIRECT

COPY conf.d /etc/mysql/conf.d/
RUN sed -ri "s~@INNODB_FLUSH_METHOD@~${INNODB_FLUSH_METHOD}~" /etc/mysql/conf.d/base.cnf
CMD ["mysqld", "--innodb-use-native-aio=0", "--ignore-db-dir=losf+found"]

EXPOSE 3306
