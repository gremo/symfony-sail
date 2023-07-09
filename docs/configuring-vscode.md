# 👨‍💻 Configuring Visual Studio Code

If you have downloaded the distribution with Visual Studio Code customizations, you'll enjoy:

- Format file on save using [Prettier](https://prettier.io) and [PHP_CodeSniffer](https://github.com/squizlabs/PHP_CodeSniffer)
- JavaScript and CSS linting using [ESLint](https://eslint.org) and [Stylelint](https://stylelint.io)
- PHP static analysis using [PHPStan](https://phpstan.org)
- Tag auto-closing and auto-renamin also in Twig templates
- Version lens for package managers
- Composer and Yarn commands and bottom-left quick actions buttons
- JSON completion
- Twig syntax highlight and snippets
- Unit tests browser

To make the IDE fully functional, you need to install a few tools locally:

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

If using Webpack Encore bundle, remember to configure `watchOptions` in `webpack.config.js`:

```js
Encore
    // Configure Webpack watchOptions options to work with Docker containers
    .configureWatchOptions(options => {
      options.poll = 1000;
    })
```
