#!/bin/bash

if [[ -z "$SERVER_NAME" ]]; then export SERVER_NAME=steemitdev.com; fi

if [[ -z "$WSPA_SERVER" ]]; then export WSPA_SERVER=steemd.steemitdev.com; fi

# generate nginx config on the fly and feed in any appropriate environment variables
/bin/bash -c "envsubst '\$SERVER_NAME \$WSPA_SERVER' < /etc/nginx/site.conf.template > /etc/nginx/sites-enabled/default"
rm /etc/nginx/site.conf.template
mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.orig
cp /etc/nginx/nginx.conf.template /etc/nginx/nginx.conf
rm /etc/nginx/nginx.conf.template

#bring up nginx
service nginx start
