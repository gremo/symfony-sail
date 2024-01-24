ARG CADDY_VERSION=2
ARG PHP_VERSION=8
ARG PHP_EXTENSIONS=
ARG PHP_DEV_EXTENSIONS=
#ejs <% if (production) { _%>
ARG PHP_PROD_EXTENSIONS=
#ejs <% } _%>
ARG COMPOSER_VERSION=lts
#ejs <% if (production) { _%>
ARG KNOWN_HOSTS="bitbucket.org github.com gitlab.com"
#ejs <% } _%>
ARG NODE_VERSION=18
#ejs <% if (mariadb) { _%>
ARG MARIADB_VERSION=11
#ejs <% } _%>

###############################################################################
### [STAGE] composer
###############################################################################
FROM composer:$COMPOSER_VERSION as composer
#ejs <% if (production) { %>
###############################################################################
# [STAGE] assets-builder
###############################################################################
FROM node:$NODE_VERSION-alpine as assets-builder
SHELL ["/bin/ash", "-euxo", "pipefail", "-c"]
WORKDIR /app

# Copy metadata and configuration files for npm, Yarn, Webpack Encore and Babel
# in order to install dependencies.
COPY --link package.jso[n] package-lock.jso[n] yarn.loc[k] .npmr[c] .yarnr[c] webpack.config.* babel.config.* .babelr[c] .babelrc.* ./

RUN \
    # Install dependencies using Yarn or npm
    if [ -f package.json ]; then \
        if [ -f yarn.lock ]; then \
            yarn install --no-progress --frozen-lockfile; \
        elif [ -f package-lock.json ]; then \
            npm ci; \
        else \
            npm install --no-progress; \
        fi; \
    fi;

# Copy the entire source tree. We need this because some tools, like Tailwind
# CSS, scan source files (like templates) and extract class names in order to
# purge unsed CSS.
COPY --link . .

RUN \
    # Build assets using Webpack Encore
    if [ -f node_modules/.bin/encore ]; then \
        node_modules/.bin/encore production; \
    # Build assets using Vite
    elif [ -f node_modules/.bin/vite ]; then \
        node_modules/.bin/vite build; \
    fi;

###############################################################################
# [STAGE] php-prod
###############################################################################
FROM symfonysail/php-prod:$PHP_VERSION AS php-prod
SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]
WORKDIR /var/www/html

ARG PHP_EXTENSIONS
ARG PHP_PROD_EXTENSIONS
ARG KNOWN_HOSTS

# Copy project configuration file(s)
COPY --link config/docker/php-fpm.conf /usr/local/etc/php-fpm.d/zzz-app.conf
COPY --link config/docker/php.ini $PHP_INI_DIR/conf.d/zz-app.ini
COPY --link config/docker/php.prod.in[i] $PHP_INI_DIR/conf.d/zzz-app.prod.ini

# Copy composer binary
COPY --link --from=composer /usr/bin/composer /usr/local/bin/

# Copy metadata and configuration files in order to install dependencies
COPY --link composer.* symfony.* ./

# The .env.local is used to pass variables to the container during runtime.
# However, we also require (some) of these variables during the build-time,
# so we copy and source the file.
COPY --link .env.loca[l] /tmp/

RUN \
    # Set environment variables from .env.local file
    if [ -f /tmp/.env.local ]; then \
        set -a && . /tmp/.env.local && set +a && rm -rf /tmp/.env.local; \
    fi; \
    # Install PHP extensions
    EXTENSIONS=$(echo "$PHP_EXTENSIONS $PHP_PROD_EXTENSIONS" | sed 's/,/ /g; s/[[:space:]]\{2,\}/ /g; s/^[[:space:]]*//g; s/[[:space:]]*$//g;'); \
    if [ -n "$EXTENSIONS" ]; then \
        install-php-extensions $EXTENSIONS; \
    fi; \
    # Get known hosts SSH keys
    KNOWN_HOSTS=$(echo "$KNOWN_HOSTS" | sed 's/,/ /g; s/[[:space:]]\{2,\}/ /g; s/^[[:space:]]*//g; s/[[:space:]]*$//g'); \
    if [ -n "$KNOWN_HOSTS" ]; then \
        mkdir -p ~/.ssh; \
        chmod 0700 ~/.ssh; \
        echo "$KNOWN_HOSTS" | xargs ssh-keyscan > ~/.ssh/known_hosts; \
    fi; \
    # Install Composer dependencies
    if [ -f composer.json ]; then \
        composer install --prefer-dist --no-dev --no-autoloader --no-scripts --no-progress; \
    fi

# Copy the entire source tree
COPY --link . .

RUN \
    # Composer autoload, env dump and post-install-cmd
    if [ -f composer.json ]; then \
        composer dump-autoload --no-dev --classmap-authoritative; \
        if composer list --raw | grep -q dump-env; then \
            composer dump-env prod; \
        fi; \
        if composer run-script --list | grep -q post-install-cmd; then \
            composer run-script --no-dev post-install-cmd; \
        fi; \
    fi; \
    # Create PHP preload configuration
    if [ -f config/preload.php ]; then \
        echo "opcache.preload_user = root" >> "$PHP_INI_DIR"/conf.d/preload.ini; \
        echo "opcache.preload = /var/www/html/config/preload.php" >> "$PHP_INI_DIR"/conf.d/preload.ini; \
    fi; \
    # Cleanup
    composer clear-cache; \
    rm -rf config/docker/; \
    rm -f /usr/bin/install-php-extensions

# Copy build output from the builder stage. We need this because some Webpack
# Encore metadata files (i.e. manifest.json) are outputted too. Symfony needs
# them at runtime.
COPY --link --from=assets-builder /app/public/buil[d]/ public/build/
#ejs <% } %>
###############################################################################
# [STAGE] php-dev
###############################################################################
FROM symfonysail/php-dev:$PHP_VERSION AS php-dev
SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]

ARG PHP_EXTENSIONS
ARG PHP_DEV_EXTENSIONS
ARG NODE_VERSION

# Copy composer binary
COPY --link --from=composer /usr/bin/composer /usr/local/bin/

RUN \
    # Install PHP extensions
    EXTENSIONS=$(echo "$PHP_EXTENSIONS $PHP_DEV_EXTENSIONS" | sed 's/,/ /g; s/[[:space:]]\{2,\}/ /g; s/^[[:space:]]*//g; s/[[:space:]]*$//g;'); \
    if [ -n "$EXTENSIONS" ]; then \
        install-php-extensions $EXTENSIONS; \
    fi; \
    # Install Node.js, update npm and install Yarm
    if [ "$NODE_VERSION" -le 16 ]; then \
        mkdir -p /etc/apt/keyrings; \
        echo "Package: nodejs" >> /etc/apt/preferences.d/nodejs; \
        echo "Pin: origin deb.nodesource.com" >> /etc/apt/preferences.d/nodejs; \
        echo "Pin-Priority: 1001" >> /etc/apt/preferences.d/nodejs; \
        curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg; \
        echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_VERSION.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list; \
        apt-get update; \
    else \
        curl -fsSL "https://deb.nodesource.com/setup_$NODE_VERSION.x" | bash -; \
    fi; \
    apt-get install -y --no-install-recommends nodejs; \
    npm install -g yarn; \
    # Cleanup
    rm -rf /root/.npm; \
    rm -rf /var/lib/apt/lists/*
#ejs <% if (production) { %>
###############################################################################
# [STAGE] caddy-prod
###############################################################################
FROM symfonysail/caddy-base:$CADDY_VERSION as caddy-prod
SHELL ["/bin/ash", "-euxo", "pipefail", "-c"]
WORKDIR /srv

# Copy Caddy configuration
COPY --link config/docker/Caddyfile /etc/caddy/

# Copy all public resources from the php-prod stage. This is needed in order to
# serve additional resources like public/bundles, created during build.
COPY --link --from=php-prod /var/www/html/publi[c]/ public/
#ejs <% } %>
###############################################################################
# [STAGE] caddy-dev
###############################################################################
FROM symfonysail/caddy-base:$CADDY_VERSION as caddy-dev
SHELL ["/bin/ash", "-euxo", "pipefail", "-c"]
#ejs <% if (mariadb) { %>
###############################################################################
# [STAGE] mariadb-dev
###############################################################################
FROM symfonysail/mariadb-base:$MARIADB_VERSION as mariadb-dev
SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]
#ejs <% if (production) { %>
###############################################################################
# [STAGE] mariadb-prod
###############################################################################
FROM symfonysail/mariadb-base:$MARIADB_VERSION as mariadb-prod
SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]

# Copy MariaDB configuration file(s)
COPY --link config/docker/mariadb.cnf /etc/mysql/mariadb.conf.d/80-app.cnf
COPY --link config/docker/mariadb.prod.cn[f] /etc/mysql/mariadb.conf.d/90-app.prod.cnf
#ejs <% } _%>
#ejs <% } _%>
