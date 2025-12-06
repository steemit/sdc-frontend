# sdc-frontend

This is the nginx frontend for the steemit.com app. It runs in its own docker container alongside the condenser app.

## Building Docker Image

Before building the Docker image, you need to download the GeoIP2 database manually:

```bash
./download-geoip.sh
```

This will download the GeoIP2 database to the `geoip/` directory. The database is used to block access from China IPs.

**Important Notes:**
- This project uses **GeoIP2 format** (`.mmdb`) with `ngx_http_geoip2_module`
- The database file `GeoLite2-Country.mmdb` will be downloaded to the `geoip/` directory
- Run this script periodically to keep the GeoIP2 database up to date
- The database file is not tracked in git (see `.gitignore`)
- If download fails, delete the `geoip/` directory and try again

## Required environment variables:

```
$SERVER_NAME     # ex. steemit.com
$WSPA_SERVER     # ex. steemd.steemit.com
```
