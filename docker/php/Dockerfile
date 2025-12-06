# LOKALIZACJA: todo-symfony/docker/php/Dockerfile

ARG PHP_VERSION=8.4

# Używamy standardowego obrazu php-fpm
FROM php:${PHP_VERSION}-fpm-alpine

# Instalacja zależności systemowych i rozszerzeń PHP
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

# Instalacja rozszerzeń PHP
RUN docker-php-ext-install -j$(nproc) \
    pdo_mysql \
    zip \
    intl \
    opcache

# Dodanie własnej konfiguracji PHP-FPM
COPY zz-custom.conf /usr/local/etc/php-fpm.d/

# Instalacja Composera globalnie
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# Konfiguracja npm: ustawiamy katalog domowy i cache na /tmp/.npm
ENV HOME=/var/www/symfony
ENV NPM_CONFIG_CACHE=/tmp/.npm
RUN apk add --no-cache nodejs npm

# Ustawienie uprawnień i katalogu roboczego
WORKDIR /var/www/symfony

# KLUCZOWE: Kopiowanie entrypoint z tego samego katalogu (docker/php)
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Domyślne polecenie startowe zostanie nadpisane przez entrypoint.sh
CMD ["php-fpm"]