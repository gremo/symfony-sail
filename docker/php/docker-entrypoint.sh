#!/bin/sh
set -e

: ${CONSOLE:="bin/console"}
: ${WRITABLE_DIRS:="public/media/ public/uploads/ var/"}
: ${KNOWN_HOSTS:="bitbucket.org github.com gitlab.com"}
: ${DATABASE_ENABLE_MIGRATIONS:=$([ "$APP_ENV" = "prod" ] && echo "true" || echo "false" )}

if [ "${1#-}" != "$1" ]; then
    set -- php-fpm "$@"
fi

if [ -n "$TZ" ]; then
    echo "date.timezone = $TZ" > "$PHP_INI_DIR"/conf.d/timezone.ini
else
    rm -rf "$PHP_INI_DIR"/conf.d/timezone.ini
fi

if [ "$1" = "php-fpm" ] || [ "$1" = "bin/console" ] || { [ "$1" = "php" ] && [ "$2" = "bin/console" ]; }; then
    for dir in $(echo "$WRITABLE_DIRS" | tr ',' ' '); do
        [ -d "$dir" ] || continue

        setfacl -dR -m u:www-data:rwX -m u:"$(whoami)":rwX "$dir"
        setfacl -R -m u:www-data:rwX -m u:"$(whoami)":rwX "$dir"
    done
fi

if [ "$1" = 'php-fpm' ]; then
    mkdir -p -m 0700 ~/.ssh
    touch ~/.ssh/known_hosts
    for host in $(echo "$KNOWN_HOSTS" | tr ',' ' '); do
        if ! ssh-keygen -F "$host" > /dev/null; then
            ssh-keyscan "$host" 2> /dev/null >> ~/.ssh/known_hosts;
        fi
    done

    if [ -f "$CONSOLE" ]; then
        if [ "$DATABASE_ENABLE_MIGRATIONS" = "true" ] && php "$CONSOLE" --raw | grep -q ^doctrine:migrations:migrate; then
            php "$CONSOLE" doctrine:database:create --if-not-exists --no-interaction --quiet
            php "$CONSOLE" doctrine:migrations:migrate --allow-no-migration --no-interaction
        fi
    fi
fi

exec docker-php-entrypoint "$@"
