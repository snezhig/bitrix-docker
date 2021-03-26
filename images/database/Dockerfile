ARG DB_VERSION
ARG DB_TYPE=mariadb
FROM ${DB_TYPE}:${DB_VERSION}

MAINTAINER snezhig

ARG INNODB_FLUSH_METHOD=O_DIRECT

COPY conf.d /etc/mysql/conf.d/
RUN sed -ri "s~@INNODB_FLUSH_METHOD@~${INNODB_FLUSH_METHOD}~" /etc/mysql/conf.d/base.cnf

RUN apt-get update && apt-get install -y wget && \
    wget http://mysqltuner.pl/ -O mysqltuner.pl && \
    wget https://raw.githubusercontent.com/major/MySQLTuner-perl/master/basic_passwords.txt -O basic_passwords.txt && \
    wget https://raw.githubusercontent.com/major/MySQLTuner-perl/master/vulnerabilities.csv -O vulnerabilities.csv

CMD ["mysqld", "--innodb-use-native-aio=0", "--ignore-db-dir=losf+found"]

EXPOSE 3306
