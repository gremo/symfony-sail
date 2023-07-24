<p align="center">
  <a href="https://hub.docker.com/u/symfonysail"><img src="https://user-images.githubusercontent.com/1532616/240989308-35c48a35-75f2-4971-bf58-2dbe106c178a.png" alt="Logo" width="150"></a>
</p>

<h1 align="center">
  Symfony Sail
</h1>
<p align="center">
  <a href="https://github.com/gremo/symfony-sail/releases"><img alt="GitHub Release Date" src="https://img.shields.io/github/release-date/gremo/symfony-sail?&style=flat-square"></a>
  <a href="https://github.com/gremo/symfony-sail/commits"><img alt="GitHub last commit" src="https://img.shields.io/github/last-commit/gremo/symfony-sail?&style=flat-square"></a>
  <a href="https://github.com/gremo/symfony-sail/issues"><img alt="GitHub issues" src="https://img.shields.io/github/issues/gremo/symfony-sail?&style=flat-square"></a>
  <a href="https://github.com/gremo/symfony-sail/pulls"><img alt="GitHub pull requests" src="https://img.shields.io/github/issues-pr/gremo/symfony-sail?&style=flat-square"></a>
  <a href="https://github.com/gremo/symfony-sail/blob/main/LICENSE"><img alt="GitHub license" src="https://img.shields.io/github/license/gremo/symfony-sail?&style=flat-square"></a>
</p>

<p align="center">
  An easy to use Docker <b>development and production environment</b> for Symfony 4/5/6 projects, zero-config yet fully customizable.
</p>

<p align="center">
  <a href="#-key-features">Key features</a> •
  <a href="#-quick-start">Quick start</a> •
  <a href="#-documentation">Documentation</a> •
  <a href="#%EF%B8%8F-contributing">Contributing</a> •
  <a href="#-license">License</a>
</p>

This project is inspired by [dunglas/symfony-docker](https://github.com/dunglas/symfony-docker), but it aims to be more **customizable** (while remaining **zero-config**) and enhance the **developer experience**. It includes support for Visual Studio Code **Dev Containers**, **MariaDB** and **Webpack Encore/Vite**.

> **Warning**: this project is still under development, please use it for testing purposes and feel free to suggest changes and improvements.

## 💫 Key features

- ✅ Zero-config yet fully customizable
- ✅ Use the `.env.local` file you are already familiar with
- ✅ Visual Studio Code [dev container](https://code.visualstudio.com/docs/devcontainers/containers), opinionated settings and extensions
- ✅ [MariaDB](https://mariadb.com/products/community-server), automatic Doctrine `DATABASE_URL` parsing, migrations support
- ✅ [Caddy](https://caddyserver.com) web server, automatic HTTPS and www to non-www redirection, HTTP/2, [Vulcain](https://vulcain.rocks) support
- ✅ [Webpack Encore](https://github.com/symfony/webpack-encore) and [Vite](https://github.com/vitejs/vite) support
- ✅ PHP OPcache [preloading](https://www.php.net/manual/en/opcache.preloading.php) support
- ✅ Docker pre-built multi-platform images for faster startup

Versions without database, production configuration and Visual Studio Code settings and extensions are also available!

## ⚡ Quick start

The only requirements are [Docker Desktop](https://www.docker.com/products/docker-desktop) and [Visual Studio Code](https://code.visualstudio.com) with the [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) installed.

👇 Grab the latest release! 👇

> **Warning**: use release links and **DO NOT clone** this repository and use it directly as it is not intended to be used that way.

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
2. Create an empty `.env.local` file and [configure the environment](docs/configuration.md)
3. Open the project in the Dev Container
4. Execute `curl -O https://raw.githubusercontent.com/symfony/skeleton/6.3/composer.json`
5. Execute `composer install` and optionally `composer require webapp`
6. Proceed [configuring Visual Studio Code](docs/configuring-vscode.md)

If you want to dockerize your **existing project**:

> **Note**: make sure your existing `DATABASE_URL` in `.env.local` both "mysql://" and "db:3306".

1. Extract the archive into the project's root folder
2. **Double-check for any overwritten files**
3. Edit your existing `.env.local` file and [configure the environment](docs/configuration.md)
4. Open the project in the Dev Container
5. Proceed [configuring Visual Studio Code](docs/configuring-vscode.md)

Your website is already available at [http://localhost](http://localhost) 🎉

## 📖 Documentation

- [Configuration](docs/configuration.md)
- [FAQ](docs/faq.md)
- [Configuring Visual Studio Code](docs/configuring-vscode.md)
- [Going to production](docs/production.md)

## ❤️ Contributing

All types of contributions are encouraged and valued. See the [contributing](CONTRIBUTING.md) guidelines, the community looks forward to your contributions!

## 📘 License

Symfony Sail is released under the terms of the [ISC License](LICENSE).
