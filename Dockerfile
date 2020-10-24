FROM ubuntu:focal

MAINTAINER Roran60

ENV DEBIAN_FRONTEND=noninteractive
ENV VERSION 1.4.0



# RUN ldap --with-libdir=lib/x86_64-linux-gnu/ 
# RUN gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ 

RUN pecl install apcu 
RUN sudo bash -c "echo extension=apcu.so > /etc/php7.X-sp/conf.d/apcu.ini"
RUN sudo service php7.X-fpm-sp restart

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
















