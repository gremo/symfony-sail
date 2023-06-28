# Upgrade

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
