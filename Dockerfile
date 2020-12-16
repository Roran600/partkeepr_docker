FROM debian:buster

MAINTAINER Roran60
WORKDIR /var/www

ENV VERSION 1.4.0

RUN apt-get update && apt-get install -y \
    apache2     \
    apache2-doc \
    curl        \ 
	cron        \ 
	ntp         \
    php         \
	php-apcu    \
	php-apcu-bc \
	php-curl    \
	php-gd      \
	php-intl    \  
	php-ldap    \ 
	php-mysql   \
	php-dom     \
	php-xml     \ 
	nano        \ 
	bsdtar      \
	&& rm -rf /var/lib/apt/lists/*

# Create the log file
RUN touch /var/log/schedule.log
RUN chmod 0777 /var/log/schedule.log  

# Add crontab file in the cron directory
ADD scheduler /etc/cron.d/scheduler

RUN cd /var/www/html \
    # A Release was not created with a .tbz2 extension for 1.3.0 on Github.
    # && curl -sL https://github.com/partkeepr/PartKeepr/releases/download/${VERSION}/partkeepr-${VERSION}.tbz2 |bsdtar --strip-components=1 -xvf- \
    && curl -sL https://downloads.partkeepr.org/partkeepr-{$VERSION}.tbz2 |bsdtar --strip-components=1 -xvf- \
    && chown -R www-data:www-data /var/www/html \
    \
    && a2enmod rewrite \
    && a2enmod userdir \

COPY php.ini /usr/local/etc/php/
COPY 000-default.conf /etc/apache2/sites-available/

RUN service apache2 restart


COPY ./entrypoint.sh /
ENTRYPOINT /entrypoint.sh



