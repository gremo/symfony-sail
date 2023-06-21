# ❓ FAQ (Frequently Asked Questions)

## How do I use Composer private repositories?

Sharing SSH keys is tricky, particularly in the production environment. During development, Visual Studio Code will do the hard work and your SSH keys will work just fine. In production, those SSH keys are not copied in the final image. To fetch private repositories, take advantage of the [`COMPOSER_AUTH`](https://getcomposer.org/doc/articles/authentication-for-private-packages.md#authentication-using-the-composer-auth-environment-variable) in your `.env` file.

Here's an example using a GitHub token as `COMPOSER_AUTH` (note the quotes):

```env
COMPOSER_AUTH='{"github-oauth":{"github.com": "<your GitHub token>"}}'
```

When building for production, the `ssh-keyscan` is used to collect the SSH public keys of `KNOWN_HOSTS`, thus avoiding interactive prompts.

## How can I push production service images to a container registry?

You can prebuilt production images (i.e. using GitHub actions or other CI systems) so you don't have to build them locally when setting up an initial environment. To correctly push images to the Docker Hub registry or to a self-hosted one, you have to use the `IMAGE_PREFIX` variable.

A few examples:

| Registry                        | Value of the `IMAGE_PREFIX`                       |
| ------------------------------- | ------------------------------------------------- |
| Docker Hub                      | `<your-username>/`                                |
| GitHub Container Registry       | `ghcr.io/<your-username>/`                        |
| DigitalOcean Container Registry | `registry.digitalocean.com/<your-registry-name>/` |

The value of `IMAGE_PREFIX` will prefix the following image names:

- `${COMPOSE_PROJECT_NAME}-caddy-prod`: for caddy service
- `${COMPOSE_PROJECT_NAME}-php-prod`: for php service
- `${COMPOSE_PROJECT_NAME}-mariadb-prod`: for mariadb service

... in order to create the final image tag. [`COMPOSE_PROJECT_NAME`](https://docs.docker.com/compose/environment-variables/envvars/#compose_project_name) is the project name or project directory basename (if omitted).

Examples of GitHub workflow jobs (`${{ github.actor }}` is the username of the user that triggered the initial workflow run):

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

## How can Windows play nicely with the container?

Disable the line-ending conversion globally (see [working with Git](https://code.visualstudio.com/docs/devcontainers/containers#_working-with-git)):

```bash
git config --global core.autocrlf false
```

I suggest also taking a look at [share SSH keys](https://code.visualstudio.com/remote/advancedcontainers/sharing-git-credentials#_using-ssh-keys) with the container. Under Windows, if you encounter any errors while running `ssh-add`, try updating OpenSSH to the [latest version](https://github.com/PowerShell/Win32-OpenSSH/releases).

## Why php logs show "GET /status 200" repeatedly in production?

Those messages are caused by the healthcheck calls. PHP 8.2 introduces a new `access.suppress_path[]` option in order to suppress messages by path (see [#80428](https://bugs.php.net/bug.php?id=80428)). If you are using PHP 8.2 or above, that option is already enabled for you, otherwise there is nothing to be done.

## Why OPcache timestamps are disabled in production?

The `opcache.validate_timestamps` directive is disabled by the [default configuration](../docker/php/php.prod.ini) because there is no need to check for updated scripts with every request. As soon as you update any PHP file (actually, any file) and run `docker compose up -d --build`, the php-fpm service will restart, thus invalidating the OPcache.
