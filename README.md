# Laravel Docker Image

These images provide:

- most PHP extensions enabled by default
- a complete dev environment with node, npm and pre-configured supervisord
- a `compose.yaml`, `Makefile` and `supervisor config` you can copy-paste in your project to get started quickly
- support for PHP-FPM and Laravel Octane
- a sample Dockerfile for production images

## Customisation

### Choosing the server

By default PHP-FPM is selected.
You can change this setting by overriding the `SERVER_TYPE` environment variable.

In `user-project-files` a sample `compose.yaml` is provided. Uncomment the `environment` section in the `app` service to update this setting.

If any of the Octane supported servers are selected, the entrypoint script will attempt to install Octane automatically.

### Customising the supervisor configuration

All the default Supervisor configuration files for dev are found in `common/dev/supervisor`

As seen in `common/dev/entrypoint.sh`, you may create a `.docker/dev/supervisor` folder in the root of your project and put any custom supervisor `.conf` files there.
These files will be copied to the supervisor `conf.d` folder at startup and used.

### Running tasks with compose services

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
