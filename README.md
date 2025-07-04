# Laravel Docker Image

These images provide:

- most PHP extensions enabled by default
- a complete dev environment with node, npm and pre-configured supervisord
- a `compose.yaml`, `Makefile` and `supervisor config` you can copy-paste in your project to get started quickly
- support for PHP-FPM and Laravel Octane
- a sample Dockerfile for production images

## Setting up the dev environment

All files needed to set up the dev environment can be copied from the `/user-project-files` directory.
Do the following to get started:
- copy [.dockerignore](./user-project-files/.dockerignore) in your project root
- copy [compose.yaml](./user-project-files/compose.yaml)` in your project root
- copy [Makefile](./user-project-files/Makefile) in your project root

Then run `make d.run` to get started. The project will start and will automatically connect to the docker shell.

By default the app will run with PHP-FPM and the queue and scheduler are commented and will not run. The `app` service will run `supervisor` in the entrypoint and will start the webserver and npm (with vite).
The behaviour can be customized as explained in the sections below.

## Setting up the production environment

All files needed to set up the prod environment can be copied from the `/user-project-files` directory.
Do the following to get started:
- copy [.dockerignore](./user-project-files/.dockerignore) in your project root
- copy [compose-prod.yaml](./user-project-files/compose-prod.yaml)` in your project root
- copy [Makefile](./user-project-files/Makefile) in your project root
- copy [Dockerfile](./user-project-files/Dockerfile) in your project root
- make sure you have a `.env.prod` in your project root configured for your production environment

Now run `make p.run` to build the image and start the service.

Just like the dev environment, the default server is PHP-FPM and the queue and scheduler services are commented.
The provided `compose-prod.yaml` builds the image for the `app` service, but if you plan to re-use it for queues and scheduler you should consider building and tagging your own image.
The behaviour can be customized as explained in the sections below.

## Customisation

### Choosing the server

In `user-project-files` a sample `compose.yaml` and `compose-prod.yaml` are provided. Uncomment the `environment` section in the `app` service to update this setting.
By default PHP-FPM is selected.
You can change this setting by overriding the `SERVER_TYPE` environment variable. The variable can be omitted to use PHP-FPM (default).

Otherwise, it can be one of `octane-rr`, `octane-swoole`, `octane-frankenphp` or `fpm`.
The image already contains the `swoole` pecl extension, and on startup will try to install and set-up octane automatically if it isn't already. See [common/dev/entrypoint.sh](./common/dev/entrypoiny.sh) for details, or [common/entrypoint.sh](./common/entrypoiny.sh) for production.
If any of the Octane supported servers are selected, the entrypoint script will attempt to install Octane automatically.

### Enabling queue and scheduler

The queue and scheduler can run in one of 2 ways:
- with supervisor, in the main `app` service
- with a custom service in the `compose` file, by starting the service with the appropriate command

To use the `compose` file option, simply uncomment the scheduler and queue services that are provided in the `compose.yaml` file.

To enable the supervisor services you need to add a supervisor configuration. By default, during initialization, all files from `.docker/dev/supervisor` in you project directory will be used as additional supervisor configurations in the docker service, and will be run at startup.
For production you may use `.docker/prod/supervisor`

#### Customising the supervisor configuration

All the default Supervisor configuration files for dev are found in `common/dev/supervisor`

As seen in `common/dev/entrypoint.sh`, you may create a `.docker/dev/supervisor` folder in the root of your project and put any custom supervisor `.conf` files there.
These files will be copied to the supervisor `conf.d` folder at startup and used. An example is provided at [user-project-files/custom-supervisor-example.conf](./user-project-files/custom-supervisor-example.conf). You can copy it in `.docker/dev/supervisor` to start the queue. This file can be customized to run any additional services you may need.

#### Running tasks with compose services

queues, scheduler or possible other services such as reverb, horizon etc. can be either added to the supervisor configuration as described in the previous paragraph (to run them in a single container), or added as services in the `compose.yaml` file.

To add a service you can run a custom command as such:

```yaml
 # example configuration for a queue worker
 queue:
    image: lorenzocattaneo/laravel:8.3-dev
    command: php artisan queue:listen
    volumes:
      - .:/var/www/html
    depends_on:
      - app
      - db
```

### Running scripts on service start

The entrypoint allows to execute `.sh` scripts copied from `.docker/dev/pre-init-scripts` for dev, or  `.docker/prod/pre-init-scripts` for production. These scripts will run at the beginning of the entrypoint file.

To run scripts at the end of the entrypoint execution, scripts will be copied from `.docker/dev/post-init-scripts` for dev, or  `.docker/prod/post-init-scripts` for production.



