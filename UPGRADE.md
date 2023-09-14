# Upgrade

## `0.2.x` to `0.3.0`

The PHP development image now uses the [new installation method for node](https://github.com/nodesource/distributions). Long story short, `lts` and `current` keywords can't be used anymore in `NODE_VERSION` variable.

- Pull the updated PHP development image
- Carefully merge changes in `Dockerfile`, `docker-compose.yml`, `docker-compose.override.yml`

## `0.2.x` to `0.2.4`

- In your `docker-compose.dev.yml` ensure `caddy.volumes` contains `public_bundles:/srv/public/bundles`
- In your `docker-compose.dev.yml` ensure `php.volumes` contains `public_bundles:/var/www/html/public/bundles`

## `0.1.x` to `0.2.x`

Minor changes regarding default MariaDB version and Docker mounts:

- The default version of MariaDB is now 11
- A new Docker mount, `public/bundles`, has been added to the development configuration

### How to upgrade

Even if not strictly necessary (MariaDB version is controlled in `.env`), you can change the default value when `MARIADB_VERSION` is empty:

- In your `Dockerfile` change `ARG MARIADB_VERSION=10` to `ARG MARIADB_VERSION=11`
- In your `docker-compose.yml` change `db.build.args.MARIADB_VERSION` to `${MARIADB_VERSION:-11}`

To add the new Docker mount:

- In your `docker-compose.dev.yml` add `public_bundles:/var/www/html/public/bundles` to `php.volumes`
- In your `docker-compose.dev.yml` add `public_bundles:` to `volumes`

## `0.0.x` to `0.1.x`

Few changes regarding how environment variables are handled:

- `SERVER_DISABLE_WWW_REDIR` is now `SERVER_ENABLE_WWW_REDIRECT`
- `DATABASE_DISABLE_MIGRATIONS` is now `DATABASE_ENABLE_MIGRATIONS`

### How to upgrade

If your `.env.local` **explicitly define `SERVER_DISABLE_WWW_REDIR`**:

- If `SERVER_DISABLE_WWW_REDIR` is a non-empty string then set `SERVER_ENABLE_WWW_REDIRECT=false`
- Remove the old `SERVER_DISABLE_WWW_REDIR`

If your `.env.local` **explicitly define `DATABASE_DISABLE_MIGRATIONS`**:

- If `DATABASE_DISABLE_MIGRATIONS` is an empty string then set `DATABASE_ENABLE_MIGRATIONS=true`, otherwise set `DATABASE_ENABLE_MIGRATIONS=false`
- Remove the old `DATABASE_DISABLE_MIGRATIONS`

If your distribution **doesn't include the database**:

- In your `docker-compose.yml` change `php.environment.DATABASE_DISABLE_MIGRATIONS: true` to `php.environment.DATABASE_ENABLE_MIGRATIONS: false`

Finally, pull the updated images

```bash
docker pull symfonysail/php-prod
docker pull symfonysail/php-dev
docker pull symfonysail/caddy-base
```
