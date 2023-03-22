ARG BASE_IMAGE=10

###############################################################################
# [STAGE] mariadb-base
###############################################################################
FROM mariadb:$BASE_IMAGE as mariadb-base
SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]

# Copy the new entrypoint
COPY --link docker-entrypoint.sh /usr/local/bin/docker-entrypoint-new.sh

RUN \
    # Configure OS
    mv /usr/local/bin/docker-entrypoint.sh /usr/local/bin/docker-mariadb-entrypoint.sh; \
    mv /usr/local/bin/docker-entrypoint-new.sh /usr/local/bin/docker-entrypoint.sh; \
    chmod +x /usr/local/bin/docker-entrypoint.sh
