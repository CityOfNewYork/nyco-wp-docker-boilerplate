# NYCO WordPress Docker Boilerplate

At NYC Opportunity, we are utilizing Docker to help us more easily and consistently manage our products, specifically, [ACCESS NYC](https://github.com/CityOfNewYork/ACCESS-NYC) and Growing Up NYC.

This repository contains a Docker image that will install the latest version of WordPress to be served by nginx. It is the Boilerplate for running and maintaining all of our WordPress products and contains scripts for deployment, syncing, configuration, and notifications with all product environments hosted on WP Engine.

## Docker Images

- nginx:alpine
- wordpress:php7.0-fpm
- mysql:5.7

## Use

Download a zip of this repository, or clone it.

If you clone the repository, you will need to delete Git to prevent potential conflicts. In your root directory run `rm -rf .git` to remove Git. When you run `git status` you should now get an error message.

The `wp` directory is where you place your project WordPress installation. The Docker image will pull the latest version of WordPress and mount any files you do not include. You can clone your project directly into the boilerplate root and swap out `wp` with your project or rename your project to `wp`, overwriting the `wp` directory provided for you (see note).

Note:
- In the `wp` directory provided for you you'll find the `composer.json` and `wp-config.php` files. Copy the `wp-config.php` file into your project root. Delete the `composer.json` file if one is provided in your project or you do not want error handling (see the Composer section below for more information).
- If you do not rename your project to `wp`, update `WP=./wp` in the `.env` file within your root directory to `WP=./<project-name>`.

If you have a database dump to work with, place your `.sql` file in the `./data` directory. There's no need to rename it as the mysql image will look for any `.sql` file and execute it when the image is built. You will need to 'Find and Replace' the site url value in the `.sql` file to match your expected localhost.

Generate your [Salts](https://api.wordpress.org/secret-key/1.1/salt/), copy, and place them in their corresponding fields within the `wp-config.php` file.

If you are working behind a proxy, uncomment associated lines in the main `Dockerfile` and enter your proxy in the appropriate areas.

If your site has Composer dependencies and they have not been installed or you are using the default Composer package that comes with this repository, cd into the `wp` directory (or your project directory) and run...

    composer install

If running `composer install` fails and you have a `composer.phar` file in your root directory, run `php composer.phar i`. If you do not have Composer installed, see the Composer section below.

From the root directory, run `docker-compose build` to build your images. Then run `docker-compose up` to start them. You can use `docker-compose up -d` to run in detached mode.

After a few moments, you will be able to open up `localhost:8080` to visit your site.

To create an interactive shell with the WordPress container, you can run...

    docker-compose exec wordpress sh

### Configuration

`.env` - This contains the configuration for `docker-compose.yml`.

`config/colors.cfg` - This contains the colors used for Slack and other message highlighting. They are currently set to match the NYC Opportunity brand.

`config/domain.cfg` - The production domain, CDN, and path for distributed `.js` files go here.

`config/github.cfg`

- `GITHUB_URL` - The url for the product repository.

`config/projects.cfg` - All of the product environment instance names should be added here.

`config/rollbar.cfg` - The access token for the product's Rollbar account and your local Rollbar username go here.

`config/slack.cfg` - Deployment and syncronisation scripts post to Slack to alert the team on various tasks. Settings for Slack are managed here.

`config/wp.cfg` - Local WordPress directory configuration.

- `WP` - The directory of the WordPress site.

- `THEME` - The path to the main working theme.

If you install WordPress in a directory other than `./wp` you will need to change the configuration in `.env` and `wp.cfg`.

### NYCO WP Config

`config/config.yml` - This file is used in conjunction with the [NYCO WP Config](https://github.com/cityofnewyork/nyco-wp-config) WordPress plugin for environment configuration. [See that repository](https://github.com/cityofnewyork/nyco-wp-config) for details on integrating with WordPress.

### WP-CLI

WP-CLI is a command line interface for WordPress. It is set up to work with your WordPress installation through this Boilerplate. [Read more about WP-CLI at it's website](https://wp-cli.org/).

To use WP-CLI, you need to run `docker-compose exec wordpress /bin/wp` before your command. Optionally, create an alias `alias docker-wp="docker-compose exec wordpress /bin/wp"` so you don't have to type out the entire command.

There are a lot of things you can do with the CLI such as, replacing strings in the WordPress database...

    docker-wp search-replace 'http://production.com' 'http://localhost:8080'

... or adding an administrative user.

    docker-wp user create username username@domain.com --role=administrator --send-email

[Refer to the documentation for more commands](https://developer.wordpress.org/cli/commands/).

### Composer

This boilerplate comes with a Composer package that you may use to get your site started and includes the [Whoops error handler framework](https://github.com/filp/whoops) for PHP to start. If your site already has Composer or you do not want the error handling framework, delete the wp/composer.json file and remove the `$whoops` set up in the `wp-config.php` file.

To use Composer, [install it on your machine](https://getcomposer.org/doc/00-intro.md) and run `composer update` or `php composer.phar i` (depending on your setup) to install the vendor package. You may also want to add `/vendor` to your WordPress `.gitignore` file, if it hasn't been already.

### Database

You can look at the database with tools like [Sequel Pro](https://www.sequelpro.com/). The connection host will be `127.0.0.1` and the db username/password/name will be `wp` or whatever you set in your configuration if you changed the config file.

## Scripts

### Git Push

You can use WP Engine's Git Push deployment to a remote installation by running...

    bin/git-push.sh -i <WP Engine install> -m <message (optional)>

Adding the `-f` flag will perform a force push. You can [read more about WP Engine's Git Push](https://wpengine.com/git/). This will also post a tracked deployment to Rollbar.

### Uploads

You can `rsync` remote `wp-content/uploads` from a WP Engine installation to your local and vise versa by running...

    bin/rsync-uploads.sh <WP Engine install> -d

The `-u` flag will sync local to remote (upload) and `-d` will sync remote to local (download).

### Config

You can `rsync` the local `config/config.yml` to a remote environment's `wp-content/mu-plugins/config` directory by running...

    bin/rsync-config.sh <WP Engine install>

### Versioning

You can version the repository with the latest release number. This will update the root `composer.json`, the theme's `style.css`, the theme's `package.json`, and regenerate the `package-lock.json` file. Then, it will run an NPM Script named "version" that should be defined in the theme's `package.json` file. This script can run any process that requires an update to the front-end styles or scripts dependent on the version of the `package.json`. Finally, it will commit the file changes and tag the repository.

    bin/version.sh <Release Number>

### Rollbar Sourcemaps

We use [Rollbar](https://rollbar.com) for error monitoring. After every new script is deployed we need to supply new sourcemaps to Rollbar. This script will read all of the files in the theme's `assets/js` folder and will attempt to upload sourcemaps for all files with the extension `.min.js`. The script files need to match the pattern `script.hash.min.js`, ex: `main.485af636c4bfedaf8ebe1b38e556b27d.min.js`. It will assume there is a sourcemap with the same name and extension `.map`, ex: `main.485af636c4bfedaf8ebe1b38e556b27d.min.js.map`. If the instance has a CDN, that will need to be set in the `domain.cfg`, ex: `CDN_INSTANCE` or `CDN_ACCESSNYC`. If there is no CDN, it will assume that the script is hosted on the default instance on WP Engine: `https://instance.wpengine.com` or `https://accessnycstage.wpengine.com`.

    bin/rollbar-sourcemaps.sh <WP Engine install>

## Troubleshooting

#### Nginx Error

>for project_nginx_1  Cannot create container for service nginx: create .: volume name is too short, names should be at least two alphanumeric characters

Check the version running in the `docker-compose.yml` file within your project directory. We've had issues with version 3.6, try using 3.5 and rebuild to see if this fixes it.

If that doesn't work, check your `.env` file in the root directory. The WP var should equal the path to your WP installation: `WP=./wp` or `WP=./<project-name>`.

#### Mu-plugins Error

>The configuration file or secret could not be found at /var/www/html/wp-content/mu-plugins/config/

Create an empty `config.yml` file inside `mu-plugins/config` and rerun `docker-compose up`. There might be specific config settings or a secret required for your project, so if this fails again check with your project lead.

#### Git Conflict Error

If you're getting a Git related error, make sure Git has been removed from your root directory (`rm -rf .git`). Git should only be present in your project (`wp`) directory.

#### Composer Error

If you're getting a Composer related error, make sure you have Composer installed (check Composer section above). You should have two `composer.json` files: one in your root directory and one in your project (`wp`) directory.

# About NYCO

NYC Opportunity is the [New York City Mayor's Office for Economic Opportunity](http://nyc.gov/opportunity). We are committed to sharing open source software that we use in our products. Feel free to ask questions and share feedback. Follow @nycopportunity on [Github](https://github.com/orgs/CityOfNewYork/teams/nycopportunity), [Twitter](https://twitter.com/nycopportunity), [Facebook](https://www.facebook.com/NYCOpportunity/), and [Instagram](https://www.instagram.com/nycopportunity/).
