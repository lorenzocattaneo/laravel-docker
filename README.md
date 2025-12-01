# Laravel Docker Image

These images provide:

- most PHP extensions enabled by default
- puppeteer/browsershot dependencies installed by default
- a complete dev environment with `node`, `npm` and pre-configured `supervisord`
- support for PHP-FPM and Laravel Octane
- a sample Dockerfile for production images
- an install script to get started quickly

## Installation

Run the following command to install:

```bash
curl -fsSL https://raw.githubusercontent.com/lorenzocattaneo/laravel-docker/main/install.sh | bash
```

After running the install script, the following files are created:

- `.dockerignore`
- `compose.yaml`
- `Makefile`
- `Dockerfile`
- `.docker/dev/supervisor/laravel-dev.conf`
- `.docker/dev/php/custom-00.ini`

The `Makefile` contains a set of commands to manage the dev environment. You can get started by running `make d.run`

## Updating

To make sure you have the latest version of the images, run `make d.update`.
The updated images will be pulled and the container will be restarted.

## Customisation

By default the `compose.yaml` file runs a single service called `app` that, through supervisord, runs the following processes:

- `php-fpm`
- `nginx`
- `vite`
- `queue` (this runs because it's defined in `.docker/dev/supervisor/laravel-dev.conf`)
- `scheduler` (this runs because it's defined in `.docker/dev/supervisor/laravel-dev.conf`)

When starting the container the entrypoint automatically copies files from `.docker/dev/supervisor` and `.docker/dev/php` to the appropriate directories in the container. This ensures you can customize the configuration by adding your own configuration files.

### Choosing the server

By default PHP-FPM is selected.
You can change this setting by overriding the `SERVER_TYPE` environment variable.

In the `compose.yaml` file, uncomment the `environment` section in the `app` service to update this setting.

If any of the Octane supported servers are selected, the entrypoint script will attempt to install Octane automatically.

### Customising the PHP configuration

A sample configuration file is provided in `.docker/dev/php/custom-00.ini`. This file will be added to the PHP configuration at startup. Add your own configuration in this file, or create other configuration files in the same directory.

### Run queue, schedule and other processes with docker compose

Queues, scheduler or other optional services such as reverb, horizon etc. can be either added to the supervisor configuration (by editing `.docker/dev/supervisor/laravel-dev.conf`), or added as services in the `compose.yaml` file.

To add a service you can run a custom command as such:

```yaml
 # example configuration for a queue worker
 queue:
    image: lorenzocattaneo/laravel:8.5-dev
    command: php artisan queue:listen
    volumes:
      - .:/var/www/html
    depends_on:
      - app
      - db
```

Make sure to remove the corresponding configuration from `.docker/dev/supervisor/laravel-dev.conf` if you are using docker compose.

The `queue` and `scheduler` services are already defined in `compose.yaml`, simply uncomment them and restart the containers.
