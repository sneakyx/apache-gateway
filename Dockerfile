FROM php:5.6-apache
MAINTAINER André Scholz <info@rothaarsystems.de>

ENV DEBIAN_FRONTEND noninteractive
ARG HOST_NAME=$HOST_NAME
ARG egr_timezone=Europe/Berlin
RUN apt-get update \
        && apt-get install -y wget bzip2 zlib1g-dev re2c libmcrypt-dev pwgen dnsutils
RUN a2enmod proxy_http proxy_ajp proxy_balancer rewrite headers ssl       
#RUN touch /usr/local/etc/php/conf.d/uploads.ini \
#    && echo date.timezone = $egr_timezone  >> /usr/local/etc/php/conf.d/uploads.ini \
#    && echo session.save_path = /var/tmp  >> /usr/local/etc/php/conf.d/uploads.ini


COPY docker-entrypoint.sh /entrypoint.sh 
COPY apache.conf /etc/apache2/apache2.conf
# COPY assets/apache-with*.conf /etc/apache2/sites-available/
RUN mkdir --parents /var/keys/
RUN chmod +x /entrypoint.sh  

EXPOSE 80 443

ENTRYPOINT ["/entrypoint.sh"]
CMD [$HOST_NAME]