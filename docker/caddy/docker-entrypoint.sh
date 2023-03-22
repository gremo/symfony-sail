#!/bin/sh
set -e

: ${SERVER_NAME:="localhost:80, localhost"}
: ${SERVER_DISABLE_WWW_REDIR:=}
: ${CADDY_DEBUG_OPTION:=$([ "$APP_ENV" = "prod" ] || echo "debug")}
: ${CADDY_ADMIN_OPTION:=$([ "$APP_ENV" = "prod" ] && echo "admin off")}

names_normalized=$(echo "$SERVER_NAME" | tr ',' ' ' | awk '{$1=$1}1')
names_processed="$names_normalized"
block_www_redir=

if [ -z "$SERVER_DISABLE_WWW_REDIR" ]; then
    names_processed=

    www_domains=
    for address in $names_normalized; do
        if echo "$address" | grep -Eq "^(https?://)?(www\.)"; then
            domain=$(echo "$address" | sed -E 's/^https?:\/\///')
            ! echo "$www_domains" | grep -qw "$domain" || continue

            www_domains="$www_domains$address "
        else
            names_processed="$names_processed$address "
        fi
    done

    names_processed=$(echo "$names_processed" | awk '{$1=$1}1' | sed 's/ /, /g')
    www_domains=$(echo "$www_domains" | awk '{$1=$1}1' | sed 's/ /, /g')

    if [ -n "$www_domains" ]; then
        block_www_redir=$(printf "%s {\n	redir http://{labels.1}.{labels.0}{uri} permanent\n}\n" "$www_domains")
    fi
fi

export SERVER_NAME="$names_processed"
export SERVER_WWW_REDIRECT_BLOCK="$block_www_redir"
export CADDY_DEBUG_OPTION="$CADDY_DEBUG_OPTION"
export CADDY_ADMIN_OPTION="$CADDY_ADMIN_OPTION"

exec "$@"
