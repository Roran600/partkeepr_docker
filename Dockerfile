FROM debian:buster

MAINTAINER Roran60

ENV VERSION 1.4.0

RUN apt-get update && apt-get install -y \
    apache2     \
    apache2-doc \
    curl        \ 
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


RUN cd /var/www/html \
    # A Release was not created with a .tbz2 extension for 1.3.0 on Github.
    # && curl -sL https://github.com/partkeepr/PartKeepr/releases/download/${VERSION}/partkeepr-${VERSION}.tbz2 |bsdtar --strip-components=1 -xvf- \
    && curl -sL https://downloads.partkeepr.org/partkeepr-{$VERSION}.tbz2 |bsdtar --strip-components=1 -xvf- \
    && chown -R www-data:www-data /var/www/html \
    \
    && a2enmod rewrite \
    && a2enmod userdir \1

COPY php.ini /etc/php/7.3/cli/php.ini
COPY apache.conf /etc/apache2/sites-available/000-default.conf

RUN service apache2 restart






