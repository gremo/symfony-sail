<p align="center">
  <a href="https://hub.docker.com/u/symfonysail"><img src="https://user-images.githubusercontent.com/1532616/240989308-35c48a35-75f2-4971-bf58-2dbe106c178a.png" alt="Logo" width="200" /></a>
</p>

<h1 align="center">
  Symfony Sail
</h1>
<p align="center">
  <img alt="GitHub last commit" src="https://img.shields.io/github/last-commit/gremo/symfony-sail">
  <img alt="GitHub workflow status" src="https://img.shields.io/github/actions/workflow/status/gremo/symfony-sail/build-push.yaml">
  <img alt="GitHub issues" src="https://img.shields.io/github/issues/gremo/symfony-sail">
  <img alt="GitHub license" src="https://img.shields.io/github/license/gremo/symfony-sail">
  <a href="https://paypal.me/marcopolichetti" target="_blank">
    <img src="https://img.shields.io/badge/Donate-PayPal-ff3f59.svg"/>
  </a>
</p>

<p align="center">
  A comprehensive <b>development and production environment</b> for Symfony 4/5/6 projects, powered by Docker.
</p>

> **Warning**: *this project is still under development, please use it for testing purposes and feel free to suggest changes and improvements.*

This project draws inspiration from the work of [dunglas/symfony-docker](https://github.com/dunglas/symfony-docker). Its goal is to provide a configurable environment and enhanced developer experience. It includes support for **Webpack Encore** and **MariaDB** (although a version without MariaDB is also available!).

💫 Main **features**:

- ✅ Zero-config startup yet fully customizable
- ✅ Visual Studio Code [Dev Containers](https://code.visualstudio.com/docs/devcontainers/containers) support
- ✅ Production-ready, automatic HTTPS, HTTP/2 and [Vulcain](https://vulcain.rocks) support
- ✅ PHP OPcache [preloading](https://www.php.net/manual/en/opcache.preloading.php) support
- ✅ [Webpack Encore](https://github.com/symfony/webpack-encore) support
- ✅ [MariaDB](https://mariadb.com/products/community-server) DBMS
- ✅ Docker multi-platform images
- ✅ Services startup order using healthchecks

👨‍💻 **Developer experience** improvements:

- ✅ Configuration-less project startup with sensible defaults
- ✅ Utilize the existing `.env.local` file that you are already familiar with
- ✅ Doctrine `DATABASE_URL` parsing, promoting DRY principle
- ✅ A fully set of Visual Studio Code (opinionated) preconfigured extensions
- ✅ Pre-built base images for quick project startup
- ✅ Automatic www redirection to non-www version
- ✅ Timezone works for all services and it's synced with PHP timezone

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [🚀 Quick start](#-quick-start)
- [🔧 Configuration](#-configuration)
- [🧑‍🏫 Tools, directories and assumptions](#-tools-directories-and-assumptions)
- [👨‍💻 Configuring Visual Studio Code](#-configuring-visual-studio-code)
- [👍 Going to production](#-going-to-production)
- [❓ FAQ](#-faq)
- [✋ Common errors](#-common-errors)
- [🐋 Docker internals](#-docker-internals)
- [🛟 Contributing](#-contributing)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## 🚀 Quick start

The only requirements are [Docker Desktop](https://www.docker.com/products/docker-desktop) and [Visual Studio Code](https://code.visualstudio.com) with the [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) installed.

👇 Grab the latest release! 👇

| Release                                                                                                     | Database | Production configuration | VSCode configuration |
| :---------------------------------------------------------------------------------------------------------- | :------: | :----------------------: | :------------------: |
| [symfony-sail.zip](https://github.com/gremo/symfony-sail/releases/download/latest/symfony-sail.zip)         | ✅       | ✅                      | ✅                   |
| [symfony-sail-v.zip](https://github.com/gremo/symfony-sail/releases/download/latest/symfony-sail-v.zip)     | ✅       | ✅                      | ❌                   |
| [symfony-sail-p.zip](https://github.com/gremo/symfony-sail/releases/download/latest/symfony-sail-p.zip)     | ✅       | ❌                      | ✅                   |
| [symfony-sail-pv.zip](https://github.com/gremo/symfony-sail/releases/download/latest/symfony-sail-pv.zip)   | ✅       | ❌                      | ❌                   |
| [symfony-sail-d.zip](https://github.com/gremo/symfony-sail/releases/download/latest/symfony-sail-d.zip)     | ❌       | ✅                      | ✅                   |
| [symfony-sail-dv.zip](https://github.com/gremo/symfony-sail/releases/download/latest/symfony-sail-dv.zip)   | ❌       | ✅                      | ❌                   |
| [symfony-sail-dp.zip](https://github.com/gremo/symfony-sail/releases/download/latest/symfony-sail-dp.zip)   | ❌       | ❌                      | ✅                   |
| [symfony-sail-dpv.zip](https://github.com/gremo/symfony-sail/releases/download/latest/symfony-sail-dpv.zip) | ❌       | ❌                      | ❌                   |


Want to start developing a **brand-new Symfony project**?

> **Note**: During development, leaving an empty `DATABASE_URL` in `.env.local` means passwordless root access.

1. Extract the archive into a new folder
2. Create an empty `.env.local` file and [configure the environment](#variables)
3. Open the project in the Dev Container
4. Execute `curl -O https://raw.githubusercontent.com/symfony/skeleton/6.3/composer.json`
5. Execute `composer install` and optionally `composer require webapp`
6. If you have downloaded the VSCode customizations distribution, complete the [configuration of Visual Studio Code](#-configuring-visual-studio-code)

If you want to dockerize your **existing project**:

> **Note**: Make sure your existing `DATABASE_URL` in `.env.local` contains `db:3306`.

1. Extract the archive into the project's root folder
2. **Double-check for any overwritten files**
3. Edit the `.env.local` file and [configure the environment](#variables)
4. Reopen the project in the Container
5. If you have downloaded the VSCode customizations distribution, complete the [configuration of Visual Studio Code](#-configuring-visual-studio-code)

## 🔧 Configuration

The environment and configuration can be modified in two ways:

1. Defining **variables** in the `.env` file (optional) and `.env.local` file (mandatory)
2. Editing the **configuration files** in the [`config/docker/`](config/docker/) folder

Let's describe the variables first!

### Variables

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
      <td><code>SERVER_DISABLE_WWW_REDIR</code></td>
      <td align="center">❌</td>
      <td align="center">✅</td>
      <td></td>
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
      <td><a href="docker/php/Dockerfile#L2">See <code>Dockerfile</code></a></td>
    </tr>
    <tr>
      <td><code>PHP_DEV_EXTENSIONS</code></td>
      <td align="center">✅</td>
      <td align="center">❌</td>
      <td><a href="docker/php/Dockerfile#L3">See <code>Dockerfile</code></a></td>
    </tr>
    <tr>
      <td><code>PHP_PROD_EXTENSIONS</code></td>
      <td align="center">✅</td>
      <td align="center">❌</td>
      <td><a href="docker/php/Dockerfile#L4">See <code>Dockerfile</code></a></td>
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
      <td>lts</td>
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
      <td>10</td>
    </tr>
    <tr>
      <td><code>DATABASE_URL</code></td>
      <td align="center">❌</td>
      <td align="center">✅</td>
      <td></td>
    </tr>
    <tr>
      <td><code>DATABASE_DISABLE_MIGRATIONS</code></td>
      <td align="center">❌</td>
      <td align="center">✅</td>
      <td></td>
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

#### Server-related variables

| Variable                   | Allowed values        | Notes                                                                |
| :------------------------- | :-------------------- | :------------------------------------------------------------------- |
| `CADDY_VERSION`            | "latest", `x`, `x.y`  | Down to 2.6                                                          |
| `SERVER_NAME`              | `list`                | Server names(s)/address(es) (space or comma-separated)               |
| `SERVER_DISABLE_WWW_REDIR` | `string`              | Any non-empty value disables the www redirection                     |
| `CADDY_ADMIN_OPTION`       | `string`              | Caddy admin option, environment-based (admin disabled in production) |
| `CADDY_DEBUG_OPTION`       | `string`              | Caddy debug option, environment-based (debug disabled in production) |

Notes:

- In production, make sure to include your domain in the `SERVER_NAME` variable, for example: `SERVER_NAME="localhost:80, localhost, example.com"`
- `SERVER_DISABLE_WWW_REDIR` disable the automatic redirection for all addresses starting with `www.` (or `https?://www.`) to the non-www version
- When `SERVER_NAME` contains a `www.example.org` or `https?://www.example.org` address, ensure that `example.org` exists too

#### PHP-related variables

| Variable              | Allowed values                       | Notes                                                                                         |
| :-------------------- | :----------------------------------- | :-------------------------------------------------------------------------------------------- |
| `PHP_VERSION`         | "latest", `x`, `x.y`                 | Down to 7.4                                                                                   |
| `PHP_EXTENSIONS`      | `list`                               | Additional PHP extensions to be installed (space or comma-separated)                          |
| `PHP_DEV_EXTENSIONS`  | `list`                               | Additional PHP development-only extensions to be installed (space or comma-separated)         |
| `PHP_PROD_EXTENSIONS` | `list`                               | Additional PHP production-only extensions to be installed (space or comma-separated)          |
| `COMPOSER_VERSION`    | "latest", "lts", `x`, `x.y`, `x.y.z` |                                                                                               |
| `COMPOSER_AUTH`       | `string`                             | Composer authentication, see [faq](#-faq)                                                     |
| `KNOWN_HOSTS`         | `list`                               | Known hosts for SSH keys retrieval, see [faq](#-faq) (space or comma-separated)               |
| `WRITABLE_DIRS`       | `list`                               | Folders that need to be writable by the PHP process (space or comma-separated)                |

Notes:

- `WRITABLE_DIRS` does not support folder names that contain spaces or commas
- Default `WRITABLE_DIRS` ensure compatibility with [LiipImagineBundle](https://github.com/liip/LiipImagineBundle) and the uploads folder (used in many Symfony examples)

#### Node-related variables

| Variable       | Allowed values        | Notes |
| :------------- | :-------------------- | :---- |
| `NODE_VERSION` | "current", "lts", `x` |       |

#### Database-related variables

| Variable                        | Allowed values       | Notes                                                                       |
| :------------------------------ | :------------------- | :-------------------------------------------------------------------------- |
| `MARIADB_VERSION`               | "latest", `x`, `x.y` | Down to 10.6                                                                |
| `DATABASE_URL`                  | `string`             | Doctrine-style database URL/DNS with "db:3306" as host and port             |
| `DATABASE_DISABLE_MIGRATIONS`   | `string`             | Any non-empty value disables database migrations (disabled in development)  |
| `DATABASE_ROOT_PASSWORD`        | `string`             | Password for the root user                                                  |
| `DATABASE_ROOT_PASSWORD_HASH`   | `string`             | Hashed password for the root user (`SELECT PASSWORD('thepassword'`))        |
| `DATABASE_RANDOM_ROOT_PASSWORD` | `string`             | Any non-empty value for random root password                                |

Notes:

- `DATABASE_URL` must specify "mysql://" as protocol and "db:3306" as host/port, otherwise an error is thrown
- If `DATABASE_URL` specifies a root user with an empty password, password will be honored and `DATABASE_ROOT_*` ignored

In a **non-production environment**:

- If `DATABASE_URL` is empty, root password will be empty and database name will default to "db_name"
- If `DATABASE_URL` specifies a non-root user and none of the `DATABASE_ROOT_*` variables are applicable, root password will be empty

In a **production environment**:

- If `DATABASE_URL` is empty, an error is thrown
- If `DATABASE_URL` specifies a non-root user and none of the `DATABASE_ROOT_*` variables are applicable, an error is thrown

#### Other variables

| Variable              | Allowed values | Notes                                                  |
| :-------------------- | :------------- | :----------------------------------------------------- |
| `TZ`                  | `string`       | Timezone for all services (synced with PHP timezone)   |
| `IMAGE_PREFIX`        | `string`       | Service image prefix (see [faq](#-faq))                |
| `HEALTHCHECK_RETRIES` | `number`       | Healthcheck max consecutive failures allowed           |
| `HEALTHCHECK_WAIT`    | `duration`     | Healthcheck init time (failure ignored in this window) |

### Configuration files

- [`Caddyfile`](config/docker/Caddyfile): Caddy development/production configuration
- [`mariadb.cnf`](config/docker/mariadb.cnf): MariaDB development/production configuration
- `mariadb.prod.cnf`: (Optional) MariaDB production configuration
- [`php-fpm.conf`](config/docker/php-fpm.conf): PHP FPM development/production configuration
- [`php.ini`](config/docker/php.ini): PHP development/production configuration
- `php.prod.ini`: (Optional) PHP production configuration

<details>
  <summary><b>Default configuration files</b> (click to show)</summary>
  <p dir="auto"></p>

- [`docker/php/php-fpm.conf`](docker/php/php.prod.ini): PHP-FPM configuration
- [`docker/php/php.ini`](docker/php/php.ini): PHP configuration
- [`docker/php/php.prod.ini`](docker/php/php.prod.ini): PHP production configuration

</details>

## 🧑‍🏫 Tools, directories and assumptions

> **Note**: your project will build and run just fine even without any of the following.

- Public directory is `public/`
- PHP dependencies installed using Composer
- PHP preload file is `config/preload.php`
- Assets dependencies installed using npm or Yarn

Want to overcome these limitations? See the [Contributing](#-contributing) section!

## 👨‍💻 Configuring Visual Studio Code

If you have downloaded the distribution with VSCode customizations, you'll enjoy...

- Format file on save using [Prettier](https://prettier.io) and [PHP_CodeSniffer](https://github.com/squizlabs/PHP_CodeSniffer)
- JavaScript and CSS linting using [ESLint](https://eslint.org) and [Stylelint](https://stylelint.io)
- PHP static analysis using [PHPStan](https://phpstan.org)
- Tag auto-closing and auto-renamin also in Twig templates
- Version lens for package managers
- Composer and Yarn commands and bottom-left quick actions buttons
- JSON completion
- Twig syntax highlight and snippets
- Unit tests browser

To make VSCode fully functional, you need to install a few tools locally:

```bash
composer require --dev phpstan/phpstan squizlabs/php_codesniffer
```

```bash
yarn add --dev --exact eslint eslint-config-prettier prettier stylelint stylelint-config-recommended
```

Create a `.eslintrc.json` file:

```json
{
  "extends": ["eslint:recommended", "prettier"],
  "env": {
    "browser": true,
    "es6": true
  },
  "parserOptions": {
    "ecmaVersion": 6,
    "sourceType": "module"
  }
}
```

Create a `.stylelintrc.json` file:

```json
{
  "extends": "stylelint-config-recommended"
}
```

Create a `phpstan.neon` file:

```yaml
parameters:
    level: 6
    paths:
        - src
        - tests
```

If using Webpack Encore bundle, remeber to configure watchOptions in `webpack.config.js`:

```js
Encore
    // Configure Webpack watchOptions options to work with Docker containers
    .configureWatchOptions(options => {
      options.poll = 1000;
    })
```

## 👍 Going to production

Coming soon...

## ❓ FAQ

<details>
  <summary><b>How do I use Composer private repositories?</b></summary>
  <p dir="auto"></p>

  Sharing SSH keys is tricky, particularly in the production environment. During development, Visual Studio Code will do the hard work and your SSH keys will work just fine. In production, those SSH keys are not copied in the final image. To fetch private repositories, take advance of the [`COMPOSER_AUTH`](https://getcomposer.org/doc/articles/authentication-for-private-packages.md#authentication-using-the-composer-auth-environment-variable) in your `.env` file.

  An example using GitHub token (note the quotes):

  ```env
  COMPOSER_AUTH='{"github-oauth":{"github.com": "<your GitHub token>"}}'
  ```

  When building for production, the `ssh-keyscan` is used to collect the SSH public keys of `KNOWN_HOSTS`, thus avoiding interactive prompts.
</details>

<details>
  <summary><b>How can I push production service images to a container registry?</b></summary>
  <p dir="auto"></p>

  You can pre-build production images (i.e. using GitHub actions or other CI systems) so you don't have to build them locally when setting up an initial environment. To correctly push images to the Docker Hub registry or to a self-hosted one, you have to use the `IMAGE_PREFIX` variable.

  A few examples:

  | Registry                        | Value of `IMAGE_PREFIX`                           |
  | ------------------------------- | ------------------------------------------------- |
  | Docker Hub                      | `<your-username>/`                                |
  | GitHub Container Registry       | `ghcr.io/<your-username>/`                        |
  | DigitalOcean Container Registry | `registry.digitalocean.com/<your-registry-name>/` |

  The value of `IMAGE_PREFIX` will prefix the following image names:

  - `${COMPOSE_PROJECT_NAME}-caddy-prod`: for caddy service
  - `${COMPOSE_PROJECT_NAME}-php-prod`: for php service
  - `${COMPOSE_PROJECT_NAME}-mariadb-prod`: for mariadb service

  ... in order to make the final image tag. [`COMPOSE_PROJECT_NAME`](https://docs.docker.com/compose/environment-variables/envvars/#compose_project_name) is the project name or project directory basename (if omitted).

  GitHub workflow jobs examples (`${{ github.actor }}` is the username of the user that triggered the initial workflow run):

  <details>
    <summary>Push to Docker Hub</summary>
    <p dir="auto"></p>

  ```yml
  build:
    name: Build
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v3

      - name: Setup env
        run: |
          echo "IMAGE_PREFIX=${{ github.actor }}/" >> .env

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v2

      - name: Build images
        run: docker compose build

      - name: Login to Docker Hub
        uses: docker/login-action@v2
        with:
          username: ${{ github.actor }}
          password: ${{ secrets.DOCKERHUB_TOKEN }}

      - name: Debug images
        run: docker images

      - name: Push images
        run: docker compose push
  ```

  </details>

  <details>
    <summary>Push to GitHub Container Registry</summary>
    <p dir="auto"></p>

  ```yml
  build:
    name: Build
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v3

      - name: Setup env
        run: |
          echo "IMAGE_PREFIX=ghcr.io/${{ github.actor }}/" >> .env

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v2

      - name: Build images
        run: docker compose build

      - name: Login to GitHub Container Registry
        uses: docker/login-action@v2
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}

      - name: Push images
        run: docker compose push
  ```

  </details>

  <details>
    <summary>Push to DigitalOcean Container Registry</summary>
    <p dir="auto"></p>

  ```yml
  build:
    name: Build
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v3

      - name: Setup env
        run: |
          echo "IMAGE_PREFIX=registry.digitalocean.com/${{ github.actor }}/" >> .env

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v2

      - name: Build images
        run: docker compose build

      - name: Login to DigitalOcean Container Registry
        uses: docker/login-action@v2
        with:
          registry: registry.digitalocean.com
          username: ${{ secrets.DIGITALOCEAN_ACCESS_TOKEN }}
          password: ${{ secrets.DIGITALOCEAN_ACCESS_TOKEN }}

      - name: Push images
        run: docker compose push
  ```

  </details>
</details>

<details>
  <summary><b>How can Windows play nicely with the container?</b></summary>
  <p dir="auto"></p>

  Disable the line-ending conversion globally (see [working with Git](https://code.visualstudio.com/docs/devcontainers/containers#_working-with-git)):

  ```bash
  git config --global core.autocrlf false
  ```

  I suggest also taking a look at [share SSH keys](https://code.visualstudio.com/remote/advancedcontainers/sharing-git-credentials#_using-ssh-keys) with the container. Under Windows, if you get any errors running `ssh-add` then try to update OpenSSH to the [latest version](https://github.com/PowerShell/Win32-OpenSSH/releases).
</details>

<details>
  <summary><b>Why php logs show "GET /status 200" repeatedly in production?</b></summary>
  <p dir="auto"></p>

  Those messages are caused by the healtcheck calls. PHP 8.2 introduces a new `access.suppress_path[]` option in order to suppress messages by path (see [#80428](https://bugs.php.net/bug.php?id=80428)). If you are using PHP 8.2 or above, that option is already enabled for you, otherwise there is nothing to be done.
</details>

<details>
  <summary><b>Why OPcache timestamps are disabled in production?</b></summary>
  <p dir="auto"></p>

  The `opcache.validate_timestamps` directive is disabled by the [default configuration](docker/php/php.prod.ini) because there is no need to check for updated scripts with every request. As soon as you update any PHP file (actually, any file) and run `docker compose up -d --build`, the php-fpm service will restart, thus invalidating the OPcache.
</details>

## ✋ Common errors

<details>
  <summary><b>PHP PDO errors during production build</b></summary>
  <p dir="auto"></p>

  If you are getting *PDO::__construct(): php_network_getaddresses: getaddrinfo failed: Name or service not known* during the build process, it's because Doctrine will try to guess the database server version automatically when clearing the cache. Add the `server_version` option as explained [in the documentation](https://symfony.com/doc/current/reference/configuration/doctrine.html).
</details>

<details>
  <summary><b>PHP call to <code>file_get_contents()</code> hangs</b></summary>
  <p dir="auto"></p>

  See [this thread on Docker forum](https://forums.docker.com/t/132885) and [this issue on GitHub](https://github.com/docker/for-win/issues/13159). Under Windows, I managed to solve it by simply disabling the automatic proxy option.
</details>

<details>
  <summary><b>Symfony skeleton errors during production build</b></summary>
  <p dir="auto"></p>

  Building the project in production with a fresh copy of `composer.json` from [Symfony skeleton](https://github.com/symfony/skeleton) isn't supported. During the production build, `composer install` is executed with the `--no-script`, making Symfony flex unable to update `composer.json` itself. To solve the problem, do a `composer install` in the development environment first.
</details>

<details>
  <summary><b>Visual Studio Code development container doesn't start</b></summary>
  <p dir="auto"></p>

  When Visual Studio Code can't start the dev container (without outputting errors) most likely there is some kind of problem with Docker Compose configuration. You can debug the development configuration running:

  ```bash
  docker compose -f docker-compose.yml -f docker-compose.dev.yml config
  ```

</details>

## 🐋 Docker internals

Project [`Dockerfile`](Dockerfile) is a [multi-stage build](https://docs.docker.com/build/building/multi-stage/) where multiple `FROM` statements are used to build the final artifact(s).

The development flow involves two Docker compose files:

> **Note**: both files are loaded automatically by Visual Studio Code Dev Container extension.

- [`docker-compose.yml`](docker-compose.yml)
- [`docker-compose.dev.yml`](docker-compose.dev.yml)

The production flow involves two Docker compose files:

> **Note**: both files are loaded automatically by Docker Compose.

- [`docker-compose.yml`](docker-compose.yml)
- [`docker-compose.override.yml`](docker-compose.override.yml)

## 🛟 Contributing

New features, ideas and bug fixes are always welcome! In order to contribute to this project, follow a few easy steps:

<p align="center">
  <a href="https://paypal.me/marcopolichetti" target="_blank"><img src="https://img.shields.io/badge/Donate-PayPal-ff3f59.svg"/></a>
</p>

1. [Fork](https://help.github.com/en/github/getting-started-with-github/fork-a-repo) this repository and clone it on your machine
2. Create a branch `my-awesome-feature` and commit to it
3. Push `my-awesome-feature` branch to GitHub and open a [pull request](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/about-pull-requests)
