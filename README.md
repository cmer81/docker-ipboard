# Docker Nginx image for Ipboard Invision Community

![alt text](https://dne4i5cb88590.cloudfront.net/invisionpower-com/monthly_2019_09/og.jpg.5e6c57e8dfa140ce4ac18f1e757d3b45.jpg)

================

This container image includes PHP 7.3 and [Nginx](https://www.nginx.com/) for Invision Community

Description
-----------

PHP 7.3 available as container is a base platform for
building and running various PHP 7.3 applications and frameworks.

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

Variable              | Description
--------------------- |  ------------------------------------------------------------------------------
`CLI_SCRIPT`          | Predefined CLI script for service
`APPLICATION_UID`     | PHP-FPM UID (Effective user ID)
`APPLICATION_GID`     | PHP-FPM GID (Effective group ID)
`WEB_DOCUMENT_ROOT`   | Document root for Nginx
`WEB_DOCUMENT_INDEX`  | Document index (eg. `index.php`) for Nginx
`WEB_ALIAS_DOMAIN`    | Alias domains (eg. `*.vm`) for Nginx
`CLI_SCRIPT`        | Predefined CLI script for service
`APPLICATION_UID`   | PHP-FPM UID (Effective user ID)
`APPLICATION_GID`   | PHP-FPM GID (Effective group ID)

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