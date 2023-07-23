#!/bin/sh
set -e

log() {
    type="$1"
    shift
    printf '%s [%s] [Entrypoint]: %s\n' "$(date --rfc-3339=seconds)" "$type" "$*"
}

log_note() {
    log Note "$@"
}

log_warn() {
    log Warn "$@" >&2
}

log_error() {
    log ERROR "$@" >&2
    exit 1
}

clean_env() {
    for prefix in $1; do
        for var in $(env | grep "^${prefix}_" | cut -d= -f1); do
            unset "$var"
        done
    done
}

parse_database_url () {
    url="$1"

    proto=$(echo "$url" | grep "://" | sed -e's,^\(.*://\).*,\1,g')
    url=${url#"$proto"}
    export "$2_PROTO=$proto"

    userpass=$(echo "$url" | grep "@" | cut -d"@" -f1)
    url=${url#"$userpass@"}
    username=$(echo "$userpass" | grep ":" | cut -d":" -f1)
    password=$(echo "$userpass" | grep ":" | cut -d":" -f2)
    export "$2_USER=$username"
    export "$2_PASSWORD=$password"

    hostport="$(echo "$url" | grep '/' | cut -d"/" -f1)"
    url=${url#"$hostport"}
    port=$(echo "$hostport" | grep ":" | cut -d":" -f2)
    host="$hostport"
    if [ -n "$port" ]; then
        host=$(echo "$host" | grep ":" | cut -d":" -f1)
    fi
    export "$2_HOST=$host"
    export "$2_PORT=$port"

    server_version=$(echo "$1" | grep "?serverVersion=" | cut -d= -f2)
    url=$(echo "$url" | sed -e's,^\(.*\)?serverVersion=.*,\1,g')
    export "$2_SERVER_VERSION=$server_version"

    name="$(echo "$url" | grep "/" | cut -d"/" -f2)"
    export "$2_NAME=$name"
}

clean_env "MARIADB MYSQL"

if [ "$DATABASE_URL" != "${DATABASE_URL#mysql://}" ]; then
    parse_database_url "$DATABASE_URL" DB

    if [ "$DB_HOST" = "db" ] && [ "$DB_PORT" = "3306" ]; then
       : "${DB_NAME:=app}"

        export MARIADB_DATABASE="$DB_NAME"
        if [ "$DB_USER" = "root" ]; then
            if [ -n "$DB_PASSWORD" ]; then
                export MARIADB_ROOT_PASSWORD="$DB_PASSWORD"
            else
                export MARIADB_ALLOW_EMPTY_ROOT_PASSWORD=true
            fi
        else
            export MARIADB_USER="$DB_USER"
            export MARIADB_PASSWORD="$DB_PASSWORD"

            if [ -n "$DATABASE_ROOT_PASSWORD" ]; then
                export MARIADB_ROOT_PASSWORD="$DATABASE_ROOT_PASSWORD"
            elif [ -n "$DATABASE_ROOT_PASSWORD_HASH" ]; then
                export MARIADB_ROOT_PASSWORD_HASH="$DATABASE_ROOT_PASSWORD_HASH"
            elif [ -n "$DATABASE_RANDOM_ROOT_PASSWORD" ]; then
                export MARIADB_RANDOM_ROOT_PASSWORD="$DATABASE_RANDOM_ROOT_PASSWORD"
            else
                if [ "$APP_ENV" = "prod" ]; then
                    log_error "DATABASE_ROOT_* variable is mandatory when APP_ENV is 'prod'."
                fi

                export MARIADB_ALLOW_EMPTY_ROOT_PASSWORD=true
            fi
        fi
    else
        clean_env DB
        log_error "DATABASE_URL specifies another host/port, unable to parse."
    fi
elif [ -z "$DATABASE_URL" ]; then
    if [ "$APP_ENV" = "prod" ]; then
        log_error "DATABASE_URL is mandatory when APP_ENV is 'prod'."
    fi

    export MARIADB_ALLOW_EMPTY_ROOT_PASSWORD=true
    export MARIADB_DATABASE=app
else
    log_error "DATABASE_URL specifies an unsupported, unable to parse."
fi

clean_env DB
export MARIADB_MYSQL_LOCALHOST_USER=true
export MARIADB_MYSQL_LOCALHOST_GRANTS=USAGE

exec docker-mariadb-entrypoint.sh "$@"
