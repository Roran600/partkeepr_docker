#!/bin/sh

cron -f &
docker-php-entrypoint php-fpm