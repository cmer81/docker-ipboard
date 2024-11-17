# Docker Nginx Image for Invision Community Ipboard

![Ipboard](https://dne4i5cb88590.cloudfront.net/invisionpower-com/monthly_2019_09/og.jpg.5e6c57e8dfa140ce4ac18f1e757d3b45.jpg)

This container image includes PHP 8.2 and [Nginx](https://www.nginx.com/) for Invision Community.

## Description

PHP 8.2 is available as a container and serves as a base platform for building and running various PHP 8.2 applications and frameworks.

Ipboard Invision Community is not included in the container. For more information and to download files, visit the [Invision Community website](https://invisioncommunity.com/).

## Usage

### Basic Usage

Example with local storage:

```bash
docker run -d --name ipboard -v "{your-ipboard-installation-files}":/app -e WEB_ALIAS_DOMAIN=mydomain.com cmer81/ipboard:latest
```

### Database Configuration

By default, this container does not contain the database for Ipboard. You need to use either an existing database or a database container.

The Ipboard setup wizard (which should appear on first run) allows connecting to an existing MySQL/MariaDB. You can also link a database container, e.g., `--link my-mysql:mysql`, and then use `mysql` as the database host during setup.

### Persistent Data

Ipboard installation and data beyond the database (file uploads, etc.) are stored in the [unnamed docker volume](https://docs.docker.com/engine/tutorials/dockervolumes/#adding-a-data-volume) at `/app`. 

To make data persistent and enable backups, use a named docker volume or mount a host folder:

Ipboard volume:
```console
docker run -d \
    -p 443:443 -p 80:80 \
    -v ipboard_html:/app \
    cmer81/ipboard:latest
```

Database volume:
```console
docker run -d \
    -v db:/var/lib/mysql \
    mariadb
```

## Custom Build

Build your custom image:

```bash
docker build --pull -t "ipboard" .
```

### Accessing the Application

```bash
curl 127.0.0.1
```

## Configuration

### Environment Variables

#### PHP Modules

Deactivate unwanted PHP modules using the `PHP_DISMOD` environment variable:

```bash
PHP_DISMOD=ioncube,redis
```

#### PHP.ini Variables

Set PHP configuration dynamically using environment variables:

| Environment Variable | Description | Default |
|---------------------|-------------|---------|
| `php.{setting-key}` | Sets the `{setting-key}` as PHP setting | |
| `PHP_DATE_TIMEZONE` | `date.timezone` | `UTC` |
| `PHP_DISPLAY_ERRORS` | `display_errors` | `0` |
| `PHP_MEMORY_LIMIT` | `memory_limit` | `512M` |
| `PHP_MAX_EXECUTION_TIME` | `max_execution_time` | `300` |
| `PHP_POST_MAX_SIZE` | `post_max_size` | `50M` |
| `PHP_UPLOAD_MAX_FILESIZE` | `upload_max_filesize` | `50M` |
| `PHP_OPCACHE_MEMORY_CONSUMPTION` | `opcache.memory_consumption` | `256` |
| `PHP_OPCACHE_MAX_ACCELERATED_FILES` | `opcache.max_accelerated_files` | `7963` |
| `PHP_OPCACHE_VALIDATE_TIMESTAMPS` | `opcache.validate_timestamps` | `default` |
| `PHP_OPCACHE_REVALIDATE_FREQ` | `opcache.revalidate_freq` | `default` |
| `PHP_OPCACHE_INTERNED_STRINGS_BUFFER` | `opcache.interned_strings_buffer` | `16` |

#### PHP FPM Variables

Configure PHP-FPM settings dynamically:

| Environment Variable | Description | Default |
|---------------------|-------------|---------|
| `fpm.global.{setting-key}` | Sets global master process settings | |
| `fpm.pool.{setting-key}` | Sets pool settings | |
| `FPM_PROCESS_MAX` | `process.max` | distribution default |
| `FPM_PM_MAX_CHILDREN` | `pm.max_children` | distribution default |
| `FPM_PM_START_SERVERS` | `pm.start_servers` | distribution default |
| `FPM_PM_MIN_SPARE_SERVERS` | `pm.min_spare_servers` | distribution default |
| `FPM_PM_MAX_SPARE_SERVERS` | `pm.max_spare_servers` | distribution default |
| `FPM_PROCESS_IDLE_TIMEOUT` | `pm.process_idle_timeout` | distribution default |
| `FPM_MAX_REQUESTS` | `pm.max_requests` | distribution default |
| `FPM_REQUEST_TERMINATE_TIMEOUT` | `request_terminate_timeout` | distribution default |
| `FPM_RLIMIT_FILES` | `rlimit_files` | distribution default |
| `FPM_RLIMIT_CORE` | `rlimit_core` | distribution default |

#### Web Environment Variables

| Environment Variable | Description | Default |
|---------------------|-------------|---------|
| `WEB_DOCUMENT_ROOT` | Document root for webserver | `/app` |
| `WEB_DOCUMENT_INDEX` | Index document | `index.php` |
| `WEB_ALIAS_DOMAIN` | Domain aliases | `*.vm` |
| `WEB_PHP_SOCKET` | PHP-FPM socket address | `127.0.0.1:9000` |
| `SERVICE_PHPFPM_OPTS` | PHP-FPM command arguments | *empty* |
| `WEB_PHP_TIMEOUT` | Webserver PHP request | `600` |
| `SERVICE_NGINX_OPTS` | Nginx command arguments | *empty* |
| `SERVICE_NGINX_CLIENT_MAX_BODY_SIZE` | Nginx `client_max_body_size` | `50m` |

## Filesystem Layout

### Directories

| Directory | Description |
|----------|-------------|
| `/opt/docker/etc/nginx` | Nginx configuration |
| `/opt/docker/etc/nginx/ssl` | Nginx SSL configuration with example server.crt, server.csr, server.key |

### Configuration Files

| File | Description |
|------|-------------|
| `/opt/docker/etc/nginx/main.conf` | Main include file (will include `global.conf`, `php.conf` and `vhost.conf`) |
| `/opt/docker/etc/nginx/global.conf` | Global Nginx configuration options |
| `/opt/docker/etc/nginx/php.conf` | PHP configuration (connection to FPM) |
| `/opt/docker/etc/nginx/vhost.common.conf` | Vhost common stuff (placeholder) |
| `/opt/docker/etc/nginx/vhost.conf` | Default vhost |
| `/opt/docker/etc/nginx/vhost.ssl.conf` | Default SSL configuration for vhost |
| `/opt/docker/etc/php/fpm/php-fpm.conf` | PHP FPM daemon configuration |
| `/opt/docker/etc/php/fpm/pool.d/application.conf` | PHP FPM pool configuration |
