FROM php:7.1.9-apache

MAINTAINER Roran60
ENV VERSION 1.4.0

WORKDIR /var/www/html

RUN set -ex \
    && apt-get update && apt-get install -y \
        bsdtar \
        libcurl4-openssl-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        cron \
        nano \
        libicu-dev \
        libxml2-dev \
        libpng12-dev \
        libldap2-dev \
    --no-install-recommends && rm -r /var/lib/apt/lists/* \
    \
    && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) curl ldap bcmath gd dom intl opcache pdo pdo_mysql \
    \
    && pecl install apcu \
    && docker-php-ext-enable apcu \
    \
    && cd /var/www/html \
    # A Release was not created with a .tbz2 extension for 1.3.0 on Github.
    # && curl -sL https://github.com/partkeepr/PartKeepr/releases/download/${VERSION}/partkeepr-${VERSION}.tbz2 |bsdtar --strip-components=1 -xvf- \
    && curl -sL https://downloads.partkeepr.org/partkeepr-{$VERSION}.tbz2 |bsdtar --strip-components=1 -xvf- \
    && chown -R www-data:www-data /var/www/html \
    \
    && a2enmod rewrite

# Create the log file
RUN touch /var/log/schedule.log
RUN chmod 0777 /var/log/schedule.log  

# Add crontab file in the cron directory
ADD scheduler /etc/cron.d/scheduler

COPY php.ini /usr/local/etc/php/php.ini
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf

VOLUME /var/www/html/data

# Run the cron
RUN crontab /etc/cron.d/scheduler

CMD ["apache2-foreground"]





