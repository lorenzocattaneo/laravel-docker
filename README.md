# Laravel Docker Image

These images provide:
- most PHP extensions enabled by default
- a complete dev environment with node, npm and pre-configured supervisord
- a compose.yaml and Makefile you can copy-paste in your project to get started quickly
- support for PHP-FPM and Laravel Octane
- a sample Dockerfile for production images

## Customisation

### Choosing the server
By default PHP-FPM is selected. 
You can change this setting by overriding the `SERVER_TYPE` environment variable.

In `user-project-files` a sample `compose.yaml` is provided. Uncomment the `environment` section in the `app` service to update this setting.

If any of the Octane supported servers are selected, the entrypoint script will attempt to install octane automatically.

### Running multiple queues

In `user-project-files` a sample `compose.yaml` is provided. Uncomment the `environment` section in the `app` service to update this setting.

You can list the names of the queues just like you would when running the queue manually. For example you can set:

`LARAVEL_QUEUES=low,default,high`.

If you only plan to run the `default` queue this env variable can be omitted.

### Customising the supervisor configuration

All the default Supervisor configuration files for dev are found in `common/dev/supervisor`

You can override any of these files in your `compose.yaml` file by
adding a line in the `volumes` section.

Example: ` - ./.dev/supervisor/my_custom_queue.conf:/etc/supervisor/conf.d/queue.conf`

You may also override the entire folder with your custom configuration, in case you need to remove any service.

Example: ` - ./.dev/my_supervisor_conf_files:/etc/supervisor/conf.d`



