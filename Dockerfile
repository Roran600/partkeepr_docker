FROM debian:buster

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
	&& rm -rf /var/lib/apt/lists/*















