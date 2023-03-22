ARG BASE_IMAGE=alpine
ARG BASE_BUILDER_IMAGE=builder-alpine

###############################################################################
# [STAGE] caddy-builder
###############################################################################
FROM caddy:$BASE_BUILDER_IMAGE AS caddy-builder
SHELL ["/bin/ash", "-euxo", "pipefail", "-c"]

RUN \
    # Build caddy binary with vulcain support
    xcaddy build --with github.com/dunglas/vulcain --with github.com/dunglas/vulcain/caddy

###############################################################################
# [STAGE] caddy-base
###############################################################################
FROM caddy:$BASE_IMAGE as caddy-base
SHELL ["/bin/ash", "-euxo", "pipefail", "-c"]

# Copy caddy binary
COPY --link --from=caddy-builder /usr/bin/caddy /usr/bin/

# Copy the new entrypoint
COPY --link docker-entrypoint.sh /usr/local/bin/

RUN \
    # Install OS packages
    apk add --no-cache tzdata; \
    # Configure OS
    chmod +x /usr/local/bin/docker-entrypoint.sh

# Configure the entrypoint and command
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
