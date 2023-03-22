# Build args
ARG CADDY_VERSION=2
ARG PHP_VERSION=8.2
ARG NODE_VERSION=lts
ARG COMPOSER_VERSION=latest

ARG TIMEZONE=UTC

###############################################################################
### [STAGE] caddy_builder
###############################################################################
FROM caddy:${CADDY_VERSION}-builder-alpine AS caddy_builder

RUN xcaddy build \
    --with github.com/dunglas/vulcain \
    --with github.com/dunglas/vulcain/caddy

###############################################################################
# [STAGE] node_builder
###############################################################################
FROM node:${NODE_VERSION}-alpine as node_builder
WORKDIR /app

COPY package.json[n] package-lock.jso[n] yarn.loc[k] webpack.config.j[s] .npmr[c] .yarnr[c] ./

    # OS configuration
RUN mkdir -p public/build; \
    # Node dependencies installation
    if [ -f package.json ]; then \
        if [ -f yarn.lock ]; then \
            yarn install --no-progress; \
        else \
            npm install --no-progress; \
        fi; \
    fi;

COPY assets/ assets/
    # Node.js dependencies building
RUN if [ -f node_modules/.bin/encore ]; then \
        mkdir -p public/build; \
        node_modules/.bin/encore production; \
    fi;

###############################################################################
### [STAGE] composer_builder
###############################################################################
FROM composer:${COMPOSER_VERSION} as composer_builder

###############################################################################
# [STAGE] php_builder
###############################################################################
FROM php:${PHP_VERSION}-fpm-bullseye as php_builder

ARG TIMEZONE

ENV COMPOSER_ALLOW_SUPERUSER=1
ENV COMPOSER_MEMORY_LIMIT=-1

    # OS packages installation
RUN apt-get -yqq update && apt-get -yqq install unzip; \
    # OS configuration
    mkdir -p /run/php; \
    # PHP configuration
    echo "date.timezone = ${TIMEZONE}" >> ${PHP_INI_DIR}/conf.d/timezone.ini; \
    # Cleanup
    rm -rf /var/lib/apt/lists/*

COPY --from=mlocati/php-extension-installer:latest /usr/bin/install-php-extensions /usr/local/bin
RUN install-php-extensions apcu gd intl opcache pdo_mysql xsl zip

COPY --from=composer_builder /usr/bin/composer /usr/local/bin

###############################################################################
# [STAGE] php_prod
###############################################################################
FROM php_builder AS php_prod

    # PHP configuration
RUN cp ${PHP_INI_DIR}/php.ini-production ${PHP_INI_DIR}/php.ini; \
    if [ -f config/preload.php ]; then \
        echo "opcache.preload_user = root" >> ${PHP_INI_DIR}/conf.d/preload.ini; \
        echo "opcache.preload = /var/www/html/config/preload.php" >> ${PHP_INI_DIR}/conf.d/preload.ini; \
    fi

COPY .docker/php/conf.d/app.ini ${PHP_INI_DIR}/conf.d/zz-app.ini
COPY .docker/php/conf.d/app.prod.ini ${PHP_INI_DIR}/conf.d/zz-app.prod.ini
COPY .docker/php/php-fpm.d/zz-docker.conf /usr/local/etc/php-fpm.d/zz-docker.conf

COPY composer.* symfony.* ./

    # Composer dependecies installation and autoload optimizations
RUN if [ -f composer.json ]; then \
        composer install --prefer-dist --no-dev --no-autoloader --no-scripts --no-progress; \
        composer dump-autoload --classmap-authoritative --no-dev; \
    fi

COPY . .

    # Composer dump-env and post-install-cmd
RUN if [ -f composer.json ]; then \
        composer dump-env prod; \
        composer run-script --no-dev post-install-cmd; \
    fi; \
    # Cleanup
    rm -rf .docker/; \
    rm -f /usr/bin/install-php-extensions; \
    composer clear-cache

###############################################################################
# [STAGE] php_dev
###############################################################################
FROM php_builder AS php_dev

    # OS packages installation
RUN apt-get update && apt-get install -y git openssh-client; \
    # PHP configuration
    cp ${PHP_INI_DIR}/php.ini-development ${PHP_INI_DIR}/php.ini; \
    # PHP extension installation
    install-php-extensions xdebug; \
    # Node.js installation
    curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash -; \
    apt-get install -y nodejs; \
    npm update -g npm; \
    npm install -g yarn; \
    # Cleanup
    rm -rf /root/.npm; \
    rm -f .env.local.php

###############################################################################
# [STAGE] caddy_base
###############################################################################
FROM caddy:${CADDY_VERSION}-alpine as caddy_base

    # OS packages installation
RUN apk add --no-cache tzdata;

COPY --from=caddy_builder /usr/bin/caddy /usr/bin/caddy
COPY .docker/caddy/Caddyfile /etc/caddy/Caddyfile

###############################################################################
# [STAGE] caddy_dev
###############################################################################
FROM caddy_base as caddy_dev

###############################################################################
# [STAGE] caddy_prod
###############################################################################
FROM caddy_base as caddy_prod

COPY public/ public/
COPY --from=node_builder /app/public/build public/
