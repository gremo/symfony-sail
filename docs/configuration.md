# 🔧 Configuration

The environment and configuration can be modified in two ways:

1. Defining **variables** in the `.env` file (optional) and `.env.local` file (mandatory)
2. Editing the **configuration files** in the [`config/docker/`](../config/docker/) folder

Let's describe the variables first!

## Variables

Summary of variables, where they should be defined, and their default values:

> **Note**: don't be intimidated by the table below, sensible defaults are provided. In fact, you can start a new project with just an empty `.env.local` file!

<table>
  <thead>
    <tr>
      <th align="left">Variable</td>
      <th><code>.env</code></th>
      <th><code>.env.local</code></th>
      <th align="left">Default</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td colspan="4" align="center">
        <a href="#server-related-variables">Server-related variables</a>
      </td>
    </tr>
    <tr>
      <td><code>CADDY_VERSION</code></td>
      <td align="center">✅</td>
      <td align="center">❌</td>
      <td>2</td>
    </tr>
    <tr>
      <td><code>SERVER_NAME</code></td>
      <td align="center">❌</td>
      <td align="center">✅</td>
      <td>localhost:80, localhost</td>
    </tr>
    <tr>
      <td><code>SERVER_ENABLE_WWW_REDIRECT</code></td>
      <td align="center">❌</td>
      <td align="center">✅</td>
      <td>true</td>
    </tr>
    <tr>
      <td><code>CADDY_ADMIN_OPTION</code></td>
      <td align="center">❌</td>
      <td align="center">✅</td>
      <td><i>Environment-based</i></td>
    </tr>
    <tr>
      <td><code>CADDY_DEBUG_OPTION</code></td>
      <td align="center">❌</td>
      <td align="center">✅</td>
      <td><i>Environment-based</i></td>
    </tr>
    <tr>
      <td colspan="4" align="center">
        <a href="#php-related-variables">PHP-related variables</a>
      </td>
    </tr>
    <tr>
      <td><code>PHP_VERSION</code></td>
      <td align="center">✅</td>
      <td align="center">❌</td>
      <td>8</td>
    </tr>
    <tr>
      <td><code>PHP_EXTENSIONS</code></td>
      <td align="center">✅</td>
      <td align="center">❌</td>
      <td><a href="../docker/php/Dockerfile#L2">See <code>Dockerfile</code></a></td>
    </tr>
    <tr>
      <td><code>PHP_DEV_EXTENSIONS</code></td>
      <td align="center">✅</td>
      <td align="center">❌</td>
      <td><a href="../docker/php/Dockerfile#L3">See <code>Dockerfile</code></a></td>
    </tr>
    <tr>
      <td><code>PHP_PROD_EXTENSIONS</code></td>
      <td align="center">✅</td>
      <td align="center">❌</td>
      <td><a href="../docker/php/Dockerfile#L4">See <code>Dockerfile</code></a></td>
    </tr>
    <tr>
      <td><code>COMPOSER_VERSION</code></td>
      <td align="center">✅</td>
      <td align="center">❌</td>
      <td>lts</td>
    </tr>
    <tr>
      <td><code>COMPOSER_AUTH</code></td>
      <td align="center">❌</td>
      <td align="center">✅</td>
      <td></td>
    </tr>
    <tr>
      <td><code>KNOWN_HOSTS</code></td>
      <td align="center">❌</td>
      <td align="center">✅</td>
      <td>bitbucket.org github.com gitlab.com</td>
    </tr>
    <tr>
      <td><code>WRITABLE_DIRS</code></td>
      <td align="center">❌</td>
      <td align="center">✅</td>
      <td>public/media/ public/uploads/ var/</td>
    </tr>
    <tr>
      <td colspan="4" align="center">
        <a href="#node-related-variables">Node-related variables</a>
      </td>
    </tr>
    <tr>
      <td><code>NODE_VERSION</code></td>
      <td align="center">✅</td>
      <td align="center">❌</td>
      <td>18</td>
    </tr>
    <tr>
      <td colspan="4" align="center">
        <a href="#database-related-variables">Database-related variables</a>
      </td>
    </tr>
    <tr>
      <td><code>MARIADB_VERSION</code></td>
      <td align="center">✅</td>
      <td align="center">❌</td>
      <td>11</td>
    </tr>
    <tr>
      <td><code>DATABASE_URL</code></td>
      <td align="center">❌</td>
      <td align="center">✅</td>
      <td></td>
    </tr>
    <tr>
      <td><code>DATABASE_ENABLE_MIGRATIONS</code></td>
      <td align="center">❌</td>
      <td align="center">✅</td>
      <td><i>Environment-based</i></td>
    </tr>
    <tr>
      <td><code>DATABASE_ROOT_PASSWORD</code></td>
      <td align="center">❌</td>
      <td align="center">✅</td>
      <td></td>
    </tr>
    <tr>
      <td><code>DATABASE_ROOT_PASSWORD_HASH</code></td>
      <td align="center">❌</td>
      <td align="center">✅</td>
      <td></td>
    </tr>
    <tr>
      <td><code>DATABASE_RANDOM_ROOT_PASSWORD</code></td>
      <td align="center">❌</td>
      <td align="center">✅</td>
      <td></td>
    </tr>
    <tr>
      <td colspan="4" align="center">
        <a href="#other-variables">Other variables</a>
      </td>
    </tr>
    <tr>
      <td><code>TZ</code></td>
      <td align="center">❌</td>
      <td align="center">✅</td>
      <td></td>
    </tr>
    <tr>
      <td><code>IMAGE_PREFIX</code></td>
      <td align="center">✅</td>
      <td align="center">❌</td>
      <td></td>
    </tr>
    <tr>
      <td><code>HEALTHCHECK_RETRIES</code></td>
      <td align="center">✅</td>
      <td align="center">❌</td>
      <td>5</td>
    </tr>
    <tr>
      <td><code>HEALTHCHECK_WAIT</code></td>
      <td align="center">✅</td>
      <td align="center">❌</td>
      <td>5s</td>
    </tr>
  </tbody>
</table>

### Server-related variables

| Variable                     | Allowed values        | Notes                                                                |
| :--------------------------- | :-------------------- | :------------------------------------------------------------------- |
| `CADDY_VERSION`              | "latest", `x`, `x.y`  | Down to 2.6                                                          |
| `SERVER_NAME`                | `list`                | Server names(s)/address(es) (space or comma-separated)               |
| `SERVER_ENABLE_WWW_REDIRECT` | "true" or "false"     | Whether to perform the www redirection to the non-www version        |
| `CADDY_ADMIN_OPTION`         | `string`              | Caddy admin option, environment-based (admin disabled in production) |
| `CADDY_DEBUG_OPTION`         | `string`              | Caddy debug option, environment-based (debug disabled in production) |

Further considerations:

- In production, make sure to include your domain in the `SERVER_NAME` variable, for example: `SERVER_NAME="localhost:80, localhost, example.com"`
- The automatic redirection is enabled for only addresses starting with `www.` (or `https?://www.`)
- When `SERVER_NAME` contains a `www.example.org` or `https?://www.example.org` address, ensure that `example.org` exists too

### PHP-related variables

| Variable              | Allowed values                       | Notes                                                                                         |
| :-------------------- | :----------------------------------- | :-------------------------------------------------------------------------------------------- |
| `PHP_VERSION`         | "latest", `x`, `x.y`                 | Down to 7.1                                                                                   |
| `PHP_EXTENSIONS`      | `list`                               | Additional PHP extensions to be installed (space or comma-separated)                          |
| `PHP_DEV_EXTENSIONS`  | `list`                               | Additional PHP development-only extensions to be installed (space or comma-separated)         |
| `PHP_PROD_EXTENSIONS` | `list`                               | Additional PHP production-only extensions to be installed (space or comma-separated)          |
| `COMPOSER_VERSION`    | "latest", "lts", `x`, `x.y`, `x.y.z` |                                                                                               |
| `COMPOSER_AUTH`       | `string`                             | Composer authentication, see [FAQ](faq.md)                                                     |
| `KNOWN_HOSTS`         | `list`                               | Known hosts for SSH keys retrieval, see [FAQ](faq.md) (space or comma-separated)               |
| `WRITABLE_DIRS`       | `list`                               | Folders that need to be writable by the PHP process (space or comma-separated)                |

Further considerations:

- `WRITABLE_DIRS` does not support folder names that contain spaces or commas
- Default `WRITABLE_DIRS` ensure compatibility with [LiipImagineBundle](https://github.com/liip/LiipImagineBundle) and the uploads folder (used in many Symfony examples)

### Node-related variables

| Variable       | Allowed values | Notes |
| :------------- | :------------- | :---- |
| `NODE_VERSION` | `x`            |       |

### Database-related variables

| Variable                        | Allowed values       | Notes                                                                              |
| :------------------------------ | :------------------- | :--------------------------------------------------------------------------------- |
| `MARIADB_VERSION`               | "latest", `x`, `x.y` | Down to 10.6                                                                       |
| `DATABASE_URL`                  | `string`             | Doctrine-style database URL/DNS with "mysql://" and "db:3306"                      |
| `DATABASE_ENABLE_MIGRATIONS`    | "true" or "false"    | Whether to perform migrations at startup, environment-based ("true" in production) |
| `DATABASE_ROOT_PASSWORD`        | `string`             | Password for the root user                                                         |
| `DATABASE_ROOT_PASSWORD_HASH`   | `string`             | Hashed password for the root user (`SELECT PASSWORD('thepassword'`))               |
| `DATABASE_RANDOM_ROOT_PASSWORD` | `string`             | Any non-empty value for random root password                                       |

Further considerations:

- If `DATABASE_URL` specifies a root user with an empty password, password will be honored and `DATABASE_ROOT_*` ignored

In a **non-production environment**:

- If `DATABASE_URL` is empty, root password will be empty and database name will default to "app"
- If `DATABASE_URL` specifies a non-root user and none of the `DATABASE_ROOT_*` variables are applicable, root password will be empty

In a **production environment**:

- If `DATABASE_URL` is empty, an error is thrown
- If `DATABASE_URL` specifies a non-root user and none of the `DATABASE_ROOT_*` variables are applicable, an error is thrown

### Other variables

| Variable              | Allowed values | Notes                                                  |
| :-------------------- | :------------- | :----------------------------------------------------- |
| `TZ`                  | `string`       | Timezone for all services (synced with PHP timezone)   |
| `IMAGE_PREFIX`        | `string`       | Service image prefix (see [FAQ](faq.md))                |
| `HEALTHCHECK_RETRIES` | `number`       | Healthcheck max consecutive failures allowed           |
| `HEALTHCHECK_WAIT`    | `duration`     | Healthcheck init time (failure ignored in this window) |

## Configuration files

- [`Caddyfile`](../config/docker/Caddyfile): Caddy development/production configuration
- [`mariadb.cnf`](../config/docker/mariadb.cnf): MariaDB development/production configuration
- `mariadb.prod.cnf`: (Optional) MariaDB production configuration
- [`php-fpm.conf`](../config/docker/php-fpm.conf): PHP FPM development/production configuration
- [`php.ini`](../config/docker/php.ini): PHP development/production configuration
- `php.prod.ini`: (Optional) PHP production configuration

Default configuration files are stored in the Docker images:

- [`docker/php/php-fpm.conf`](../docker/php/php.prod.ini): PHP-FPM configuration
- [`docker/php/php.dev.ini`](../docker/php/php.dev.ini): PHP development configuration
- [`docker/php/php.ini`](../docker/php/php.ini): PHP configuration
- [`docker/php/php.prod.ini`](../docker/php/php.prod.ini): PHP production configuration
