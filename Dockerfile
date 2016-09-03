FROM php:5.6-apache
MAINTAINER André Scholz <info@rothaarsystems.de>
# Version 2016-09-03

ENV DEBIAN_FRONTEND noninteractive
ARG HOST_NAME=""
ARG egr_timezone=Europe/Berlin
RUN apt-get update \
        && apt-get install -y wget bzip2 zlib1g-dev re2c libmcrypt-dev pwgen dnsutils
RUN a2enmod proxy_http proxy_ajp proxy_balancer rewrite headers ssl       

RUN mkdir --parents /var/keys/
RUN mkdir --parents /var/log/apache2/

COPY docker-entrypoint.sh /entrypoint.sh 
COPY apache.conf /etc/apache2/apache2.conf


RUN chmod +x /entrypoint.sh  

EXPOSE 80 443

ENTRYPOINT ["/entrypoint.sh"]
CMD [$HOST_NAME]