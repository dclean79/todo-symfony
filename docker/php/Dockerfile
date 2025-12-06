# LOKALIZACJA: todo-symfony/docker/php/Dockerfile

ARG PHP_VERSION=8.4

# Używamy standardowego obrazu php-fpm
FROM php:${PHP_VERSION}-fpm-alpine

# 1. Instalacja zależności systemowych i rozszerzeń PHP
RUN apk update && apk add --no-cache \
    git \
    unzip \
    acl \
    gosu \
    netcat-openbsd \
    mysql-client \
    # Rozszerzenia PHP wymagane przez Doctrine/Symfony
    libxml2-dev \
    libzip-dev \
    zip \
    icu-dev \
    # MySQL i inne
    mysql-dev \
    # Narzędzia do czyszczenia
    && rm -rf /var/cache/apk/*

# 2. Instalacja rozszerzeń PHP
RUN docker-php-ext-install -j$(nproc) \
    pdo_mysql \
    zip \
    intl \
    opcache

# 3. Instalacja Composera globalnie
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# 4. Ustawienie uprawnień i katalogu roboczego
WORKDIR /var/www/symfony

# KLUCZOWE: Kopiowanie entrypoint z tego samego katalogu (docker/php)
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Domyślny użytkownik PHP-FPM to 'www-data' (UID 82)
USER www-data

# Domyślne polecenie startowe zostanie nadpisane przez entrypoint.sh
CMD ["php-fpm"]