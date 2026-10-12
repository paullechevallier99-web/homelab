FROM php:8.4-fpm

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" \
 && docker-php-ext-install pdo_mysql
