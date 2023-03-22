ARG BASE_IMAGE=fpm
ARG EXTENSIONS="apcu gd intl opcache pdo_mysql xsl zip"
ARG EXTENSIONS_DEV="xdebug"
ARG EXTENSIONS_PROD=""

###############################################################################
# [STAGE] php-base
###############################################################################
FROM php:$BASE_IMAGE as php-base
SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]

ARG EXTENSIONS
ENV COMPOSER_ALLOW_SUPERUSER=1
ENV COMPOSER_MEMORY_LIMIT=-1

# Copy install-php-extensions binary
COPY --link --from=mlocati/php-extension-installer:latest /usr/bin/install-php-extensions /usr/local/bin/

# Copy configuration files
COPY --link php-fpm.conf /usr/local/etc/php-fpm.d/symfony-sail.conf
COPY --link php.ini /usr/local/etc/php/conf.d/symfony-sail.ini

# Copy the new entrypoint
COPY --link docker-entrypoint.sh /usr/local/bin/

RUN \
    # Install OS packages
    apt-get update; \
    apt-get install -y --no-install-recommends acl git libfcgi-bin openssh-client unzip; \
    # Configure OS
    chmod +x /usr/local/bin/docker-entrypoint.sh; \
    mkdir -p /var/run/php; \
    # Install the healthcheck script (https://github.com/renatomefi/php-fpm-healthcheck)
    curl -Lf -o /usr/local/bin/healthcheck.sh https://raw.githubusercontent.com/renatomefi/php-fpm-healthcheck/master/php-fpm-healthcheck; \
    chmod +x /usr/local/bin/healthcheck.sh; \
    # Install PHP extensions
    EXTENSIONS=$(echo "$EXTENSIONS" | sed 's/,/ /g; s/[[:space:]]\{2,\}/ /g; s/^[[:space:]]*//g; s/[[:space:]]*$//g;'); \
    if [ -n "$EXTENSIONS" ]; then \
        install-php-extensions $EXTENSIONS; \
    fi; \
    # PHP >= 8.2 specific configuration
    if [ "$(php -r 'echo version_compare(PHP_VERSION, "8.2", ">=") ? "true" : "";')" ]; then \
        # Supress access log for the status page called repeatedly by the healthcheck
        echo "access.suppress_path[] = /status" >> /usr/local/etc/php-fpm.d/symfony-sail.conf; \
    fi; \
    # Cleanup
    rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["php-fpm"]

###############################################################################
# [STAGE] php-prod
###############################################################################
FROM php-base AS php-prod
SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]

ARG EXTENSIONS_PROD

# Copy configuration files
COPY --link php.prod.ini /usr/local/etc/php/conf.d/symfony-sail.prod.ini

RUN \
    # Copy base configuration file
    cp "$PHP_INI_DIR"/php.ini-production "$PHP_INI_DIR"/php.ini; \
    # Install PHP extensions
    EXTENSIONS_PROD=$(echo "$EXTENSIONS_PROD" | sed 's/,/ /g; s/[[:space:]]\{2,\}/ /g; s/^[[:space:]]*//g; s/[[:space:]]*$//g;'); \
    if [ -n "$EXTENSIONS_PROD" ]; then \
        install-php-extensions $EXTENSIONS_PROD; \
    fi; \
    # Cleanup
    rm -rf /var/lib/apt/lists/*

###############################################################################
# [STAGE] php-dev
###############################################################################
FROM php-base AS php-dev
SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]

ARG EXTENSIONS_DEV

# Copy configuration files
COPY --link php.dev.ini /usr/local/etc/php/conf.d/symfony-sail.dev.ini

RUN \
    # Copy base configuration file
    cp "$PHP_INI_DIR"/php.ini-development "$PHP_INI_DIR"/php.ini; \
    # Install PHP extensions
    EXTENSIONS_DEV=$(echo "$EXTENSIONS_DEV" | sed 's/,/ /g; s/[[:space:]]\{2,\}/ /g; s/^[[:space:]]*//g; s/[[:space:]]*$//g;'); \
    if [ -n "$EXTENSIONS_DEV" ]; then \
        install-php-extensions $EXTENSIONS_DEV; \
    fi; \
    # Cleanup
    rm -rf /var/lib/apt/lists/*
