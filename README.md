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

This project draws inspiration from the work of [dunglas/symfony-docker](https://github.com/dunglas/symfony-docker). Its goal is to provide a configurable environment and enhanced developer experience. It includes support for **Webpack Encore** and **MariaDB**. Versions without MariaDB and production container are also available!

💫 Main **features**:

- ✅ Fully customizable
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
- ✅ Open multiple Sail projects simultaneously with automatic port forwarding
- ✅ Pre-built base images for quick project startup
- ✅ Automatic www redirection to non-www version
- ✅ Timezone works for all services and it's synced with PHP timezone

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
<details>
<summary>👇 Table of <b>contents</b></summary>

- [🧑‍🏫 Tools, directories and assumptions](#-tools-directories-and-assumptions)
- [🚀 Quick start](#-quick-start)
- [🔧 Configuration](#-configuration)
- [👨‍💻 Configuring Visual Studio Code](#-configuring-visual-studio-code)
- [👍 Going to production](#-going-to-production)
- [❓ FAQ](#-faq)
- [🐋 Docker internals](#-docker-internals)
- [❤️ Contributing](#-contributing)
- [📘 License](#-license)

</details>
<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## 🧑‍🏫 Tools, directories and assumptions

> **Note**: your project will build and run just fine even without any of the following.

- Public directory is `public/` with `index.php` index file
- PHP dependencies installed using Composer
- PHP preload file is `config/preload.php`
- Assets dependencies installed using npm or Yarn

Want to overcome these limitations? See the [Contributing](#-contributing) section!

## 🚀 Quick start

The only requirements are [Docker Desktop](https://www.docker.com/products/docker-desktop) and [Visual Studio Code](https://code.visualstudio.com) with the [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) installed.

👇 Grab the latest release! 👇

| Release                                                                                                     | Database | Production configuration | VSCode configuration |
| :---------------------------------------------------------------------------------------------------------- | :------: | :----------------------: | :------------------: |
| [symfony-sail.zip](https://github.com/gremo/symfony-sail/releases/latest/download/symfony-sail.zip)         | ✅       | ✅                      | ✅                   |
| [symfony-sail-v.zip](https://github.com/gremo/symfony-sail/releases/latest/download/symfony-sail-v.zip)     | ✅       | ✅                      | ❌                   |
| [symfony-sail-p.zip](https://github.com/gremo/symfony-sail/releases/latest/download/symfony-sail-p.zip)     | ✅       | ❌                      | ✅                   |
| [symfony-sail-pv.zip](https://github.com/gremo/symfony-sail/releases/latest/download/symfony-sail-pv.zip)   | ✅       | ❌                      | ❌                   |
| [symfony-sail-d.zip](https://github.com/gremo/symfony-sail/releases/latest/download/symfony-sail-d.zip)     | ❌       | ✅                      | ✅                   |
| [symfony-sail-dv.zip](https://github.com/gremo/symfony-sail/releases/latest/download/symfony-sail-dv.zip)   | ❌       | ✅                      | ❌                   |
| [symfony-sail-dp.zip](https://github.com/gremo/symfony-sail/releases/latest/download/symfony-sail-dp.zip)   | ❌       | ❌                      | ✅                   |
| [symfony-sail-dpv.zip](https://github.com/gremo/symfony-sail/releases/latest/download/symfony-sail-dpv.zip) | ❌       | ❌                      | ❌                   |

Want to start developing a **brand-new Symfony project**?

> **Note**: during development, leaving an empty `DATABASE_URL` in `.env.local` means passwordless root access.

1. Extract the archive into a new folder
2. Create an empty `.env.local` file and [configure the environment](#variables)
3. Open the project in the Dev Container
4. Execute `curl -O https://raw.githubusercontent.com/symfony/skeleton/6.3/composer.json`
5. Execute `composer install` and optionally `composer require webapp`
6. If you have downloaded the VSCode customizations distribution, complete the [configuration of Visual Studio Code](#-configuring-visual-studio-code)

If you want to dockerize your **existing project**:

> **Note**: make sure your existing `DATABASE_URL` in `.env.local` contains `db:3306`.

1. Extract the archive into the project's root folder
2. **Double-check for any overwritten files**
3. Edit your existing `.env.local` file and [configure the environment](#variables)
4. Reopen the project in the Container
5. If you have downloaded the VSCode customizations distribution, complete the [configuration of Visual Studio Code](#-configuring-visual-studio-code)

In both cases, your website will be available at [http://localhost](http://localhost).

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

Default configuration files are stored in the Docker images:

- [`docker/php/php-fpm.conf`](docker/php/php.prod.ini): PHP-FPM configuration
- [`docker/php/php.dev.ini`](docker/php/php.dev.ini): PHP development configuration
- [`docker/php/php.ini`](docker/php/php.ini): PHP configuration
- [`docker/php/php.prod.ini`](docker/php/php.prod.ini): PHP production configuration

## 👨‍💻 Configuring Visual Studio Code

Read [Configuring Visual Studio Code](docs/configuring-vscode.md) if you have downloaded the distribution with VSCode configuration.

## 👍 Going to production

Read [Going to production](docs/production.md) if you have downloaded the distribution with the production containers.

## ❓ FAQ
Read [FAQ](docs/faq.md) for a list of frequently asked questions.

## 🐋 Docker internals

Read [Docker internals](docs/docker-internals.md) if you are curious about how the orchestration works.

## ❤️ Contributing

New features, ideas and bug fixes are always welcome! Everyone interacting in the Symfony Sail project's code bases or issue trackers, is expected to follow the [Code of Conduct](CODE_OF_CONDUCT.md).

In order to contribute to this project, follow a few easy steps:

1. [Fork](https://help.github.com/en/github/getting-started-with-github/fork-a-repo) this repository and clone it on your machine
2. Create a branch `my-awesome-feature` and commit to it
3. Push `my-awesome-feature` branch to GitHub and open a [pull request](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/about-pull-requests)

<p align="center">
  <a href="https://paypal.me/marcopolichetti" target="_blank"><img src="https://img.shields.io/badge/Donate-PayPal-ff3f59.svg"/></a>
</p>

## 📘 License

Symfony Sail is released under the under terms of the [ISC License](LICENSE).
