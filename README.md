# Docker Nginx image for Ipboard Invision Community 



![Ipboard](https://dne4i5cb88590.cloudfront.net/invisionpower-com/monthly_2019_09/og.jpg.5e6c57e8dfa140ce4ac18f1e757d3b45.jpg)

This container image includes PHP 8.2 and [Nginx](https://www.nginx.com/) for Invision Community

Description
-----------

PHP 8.2 available as container is a base platform for
building and running various PHP 8.2 applications and frameworks.

ipboard Invision Community is not included in the container, for more information go to the website for download files [Invision Community](https://invisioncommunity.com/).

## Usage
---------------------

Example with local storage:

```bash
$ docker run -d --name ipboard -v "{your-ipboard-installation-files}":/app -e WEB_ALIAS_DOMAIN=mydomain.com cmer81/ipboard:latest
```

## Using an external database
By default this container does not contain the database for Ipboard. You need to use either an existing database or a database container.

The IPboard setup wizard (should appear on first run) allows connecting to an existing MySQL/MariaDB. You can also link a database container, e. g. `--link my-mysql:mysql`, and then use `mysql` as the database host on setup. More info is in the docker-compose section.

## Persistent data
The Ipboard installation and all data beyond what lives in the database (file uploads, etc) are stored in the [unnamed docker volume](https://docs.docker.com/engine/tutorials/dockervolumes/#adding-a-data-volume) volume `/app`. The docker daemon will store that data within the docker directory `/var/lib/docker/volumes/...`. That means your data is saved even if the container crashes, is stopped or deleted.

To make your data persistent to upgrading and get access for backups is using named docker volume or mount a host folder. To achieve this you need one volume for your database container and IPboard.

IPboard:
- `/app` folder where all IPboard data lives
```console
$ docker run -d \
    -p 443:443 -p 80:80 \
    -v ipboard_html:/app \
    cmer81/ipboard:latest
```

Database:
- `/var/lib/mysql` MySQL / MariaDB Data
```console
$ docker run -d \
    -v db:/var/lib/mysql \
    mariadb
```

Build Your custom Usage
---------------------

```
docker build --pull -t "ipboard" .
```

**Accessing the application:**
```
$ curl 127.0.0.1
```



## Environment variables

### PHP modules


As we build our images containing almost every PHP module and having it activated by default, you might want to deactivate some.

You can specify a comma-separated list of unwanted modules as dynamic env variable ``PHP_DISMOD``, e.g. ``PHP_DISMOD=ioncube,redis``.

### PHP.ini variables


You can specify eg. ``php.memory_limit=256M`` as dynamic env variable which will set ``memory_limit = 256M`` as php setting.


| Environment variable | Description | Default |
|--|--|--|
|``php.{setting-key}`` |Sets the ``{setting-key}`` as php setting | |
|``PHP_DATE_TIMEZONE`` |``date.timezone`` |``UTC`` |
|``PHP_DISPLAY_ERRORS`` |``display_errors`` |``0`` |
|``PHP_MEMORY_LIMIT`` |``memory_limit`` |``512M`` |
|``PHP_MAX_EXECUTION_TIME`` |``max_execution_time`` |``300`` |
|``PHP_POST_MAX_SIZE`` |``post_max_size`` |``50M`` |
|``PHP_UPLOAD_MAX_FILESIZE`` |``upload_max_filesize`` |``50M`` |
|``PHP_OPCACHE_MEMORY_CONSUMPTION`` |``opcache.memory_consumption`` |``256`` |
|``PHP_OPCACHE_MAX_ACCELERATED_FILES`` |``opcache.max_accelerated_files`` |``7963`` |
|``PHP_OPCACHE_VALIDATE_TIMESTAMPS`` |``opcache.validate_timestamps`` |``default`` |
|``PHP_OPCACHE_REVALIDATE_FREQ`` |``opcache.revalidate_freq`` |``default`` |
|``PHP_OPCACHE_INTERNED_STRINGS_BUFFER`` |``opcache.interned_strings_buffer`` |``16`` |

### PHP FPM  variables


You can specify eg. ``fpm.pool.pm.max_requests=1000`` as dyanmic env variable which will sets ``pm.max_requests = 1000`` as fpm pool setting.
The prefix ``fpm.pool`` is for pool settings and ``fpm.global`` for global master process settings.

| Environment variable | Description | Default |
|--|--|--|
|``fpm.global.{setting-key}`` |Sets the ``{setting-key}`` as fpm global setting for the master process| |
|``fpm.pool.{setting-key}`` |Sets the ``{setting-key}`` as fpm pool setting| |
|``FPM_PROCESS_MAX`` |``process.max`` |``distribution default``
|``FPM_PM_MAX_CHILDREN`` |``pm.max_children`` |``distribution default``
|``FPM_PM_START_SERVERS`` |``pm.start_servers`` |``distribution default``
|``FPM_PM_MIN_SPARE_SERVERS`` |``pm.min_spare_servers`` |``distribution default``
|``FPM_PM_MAX_SPARE_SERVERS`` |``pm.max_spare_servers`` |``distribution default``
|``FPM_PROCESS_IDLE_TIMEOUT`` |``pm.process_idle_timeout`` |``distribution default``
|``FPM_MAX_REQUESTS`` |``pm.max_requests`` |``distribution default``
|``FPM_REQUEST_TERMINATE_TIMEOUT`` |``request_terminate_timeout`` |``distribution default``
|``FPM_RLIMIT_FILES`` |``rlimit_files`` |``distribution default``
|``FPM_RLIMIT_CORE`` |``rlimit_core`` |``distribution default``

### Web environment variables

| Environment variable | Description | Default |
|--|--|--|
|``WEB_DOCUMENT_ROOT``                  |Document root for webserver    |``/app``
|``WEB_DOCUMENT_INDEX``                 |Index document                 |``index.php``
|``WEB_ALIAS_DOMAIN``                   |Domain aliases                 |``*.vm``
|``WEB_PHP_SOCKET``                     |PHP-FPM socket address         |``127.0.0.1:9000``
|``SERVICE_PHPFPM_OPTS``                |PHP-FPM command arguments      |*empty*
|``WEB_PHP_TIMEOUT``                    |Webserver PHP request        |``600``
|``SERVICE_NGINX_OPTS``                 |Nginx command arguments        |*empty*
|``SERVICE_NGINX_CLIENT_MAX_BODY_SIZE`` |Nginx ``client_max_body_size`` |``50m``


## Filesystem layout

Directory                       | Description
------------------------------- | ------------------------------------------------------------------------------
`/opt/docker/etc/nginx`         | Nginx configuration
`/opt/docker/etc/nginx/ssl`     | Nginx ssl configuration with example server.crt, server.csr, server.key

File                                                | Description
--------------------------------------------------- | ------------------------------------------------------------------------------
`/opt/docker/etc/nginx/main.conf`                   | Main include file (will include `global.conf`, `php.conf` and `vhost.conf`) 
`/opt/docker/etc/nginx/global.conf`                 | Global nginx configuration options
`/opt/docker/etc/nginx/php.conf`                    | PHP configuration (connection to FPM)
`/opt/docker/etc/nginx/vhost.common.conf`           | Vhost common stuff (placeholder)
`/opt/docker/etc/nginx/vhost.conf`                  | Default vhost
`/opt/docker/etc/nginx/vhost.ssl.conf`              | Default ssl configuration for vhost
`/opt/docker/etc/php/fpm/php-fpm.conf`              | PHP FPM daemon configuration
`/opt/docker/etc/php/fpm/pool.d/application.conf`   | PHP FPM pool configuration
`/opt/docker/etc/php/fpm/php-fpm.conf`                 | FPM daemon configuration
`/opt/docker/etc/php/fpm/pool.d/application.conf`      | FPM pool configuration