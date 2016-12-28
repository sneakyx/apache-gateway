FROM php:5.6-apache
MAINTAINER André Scholz <info@rothaarsystems.de>
# Version 2016-12-28-12-00

ENV DEBIAN_FRONTEND noninteractive
ARG HOST_NAME=""
ARG ACTION=""
RUN apt-get update \
        && apt-get install -y wget bzip2 zlib1g-dev re2c libmcrypt-dev pwgen dnsutils
RUN touch /usr/local/etc/php/conf.d/uploads.ini \
    && echo date.timezone = $egr_timezone  >> /usr/local/etc/php/conf.d/uploads.ini \
    && echo session.save_path = /var/tmp  >> /usr/local/etc/php/conf.d/uploads.ini

RUN a2enmod proxy_http proxy_ajp proxy_balancer rewrite headers ssl

RUN mkdir --parents /var/keys/
RUN mkdir --parents /var/log/apache2/

COPY docker-entrypoint.sh /entrypoint.sh
COPY apache.conf /etc/apache2/apache2.conf


RUN chmod +x /entrypoint.sh

EXPOSE 80 443

ENTRYPOINT ["/entrypoint.sh"]
CMD [$ACTION, $HOST_NAME]
