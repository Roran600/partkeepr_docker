FROM ubuntu:focal

MAINTAINER Roran60

ENV DEBIAN_FRONTEND=noninteractive
ENV VERSION 1.4.0

RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install -y apache2 
RUN apt-get install -y apache2-doc 
RUN apt-get install -y curl
RUN apt-get install -y ntp       
RUN apt-get install -y libarchive-tools
RUN apt-get install -y libcurl4-openssl-dev 
RUN apt-get install -y libfreetype6-dev 
RUN apt-get install -y libjpeg62-dev
RUN apt-get install -y cron 
RUN apt-get install -y nano 
RUN apt-get install -y libicu-dev 
RUN apt-get install -y libxml2-dev 
RUN apt-get install -y libpng12-0
RUN apt-get install -y libldap2-dev 
RUN apt-get install -y php 
RUN apt-get install -y php-dev 
RUN apt-get install -y php-mysql 
RUN apt-get install -y libapache2-mod-php 
RUN apt-get install -y php-curl 
RUN apt-get install -y php-json 
RUN apt-get install -y php-common 
RUN apt-get install -y php-mbstring 
RUN apt-get install -y composer
RUN apt-get install -y software-properties-common
RUN apt-get install -y php7.2
RUN apt-get install -y php-apcu 
RUN apt-get install -y php-apcu-bc 
RUN apt-get install -y php-curl 
RUN apt-get install -y php-gd 
RUN apt-get install -y php-intl  
RUN apt-get install -y php-ldap 
RUN apt-get install -y php-mysql 
RUN apt-get install -y php-dom 
RUN apt-get install -y php-xml

RUN rm -r /var/lib/apt/lists/* 

RUN docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ 
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ 
RUN docker-php-ext-install -j$(nproc) curl ldap bcmath gd dom intl opcache pdo pdo_mysql 

RUN pecl install apcu 
RUN docker-php-ext-enable apcu 

RUN cd /var/www/html 
# A Release was not created with a .tbz2 extension for 1.3.0 on Github.
# && curl -sL https://github.com/partkeepr/PartKeepr/releases/download/${VERSION}/partkeepr-${VERSION}.tbz2 |bsdtar --strip-components=1 -xvf- 
RUN curl -sL https://downloads.partkeepr.org/partkeepr-{$VERSION}.tbz2 |bsdtar --strip-components=1 -xvf- 
RUN chown -R www-data:www-data /var/www/html 

RUN a2enmod rewrite

COPY php.ini /usr/local/etc/php/php.ini
COPY apache.conf /etc/apache2/sites-available/000-default.conf

CMD ["apachectl","-D","FOREGROUND"]
 
EXPOSE 80

VOLUME /var/www/html/data
















