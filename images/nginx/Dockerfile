FROM nginx:latest

ADD nginx.conf /etc/nginx/
ADD conf.d /etc/nginx/conf.d/
ADD sites/default.conf /etc/nginx/sites-available/

ARG DOMAIN=localhost
ARG REGEXP
ARG CONDITION_NUMBER

RUN if [ -z "$REGEXP" ]; then sed -ri '/# Dynamic prefix/,/}/d' /etc/nginx/sites-available/default.conf; fi
RUN sed -ri "s~@PROJECT_DOMAIN@~$DOMAIN~" /etc/nginx/sites-available/default.conf
RUN sed -ri "s/@NGINX_ROOT_REGEXP@/$REGEXP/" /etc/nginx/sites-available/default.conf
RUN sed -ri "s~@NGINX_ROOT_CONDITION_NUMBER@~$CONDITION_NUMBER~" /etc/nginx/sites-available/default.conf

RUN usermod -u 1000 www-data
RUN openssl req -x509 -nodes -days 365 -subj "/C=CA/ST=QC/O=Company, Inc./CN=$DOMAIN" -addext "subjectAltName=DNS:$DOMAIN" -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt;
CMD ["nginx"]

EXPOSE 80 443