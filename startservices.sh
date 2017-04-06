#!/bin/bash

if [[ -z "$SERVER_NAME" ]]; then export SERVER_NAME=steemitdev.com; fi

if [[ -z "$WSPA_SERVER" ]]; then export WSPA_SERVER=steemd.steemitdev.com; fi

# generate nginx config on the fly and feed in any appropriate environment variables
if [[ ${NODE_ENV} == "dev" ]] || [[ ${NODE_ENV} == "staging" ]]; then
  /bin/bash -c "envsubst '\$SERVER_NAME \$WSPA_SERVER' < /etc/nginx/site.devstage.conf.template > /etc/nginx/sites-enabled/default"
else
  /bin/bash -c "envsubst '\$SERVER_NAME \$WSPA_SERVER' < /etc/nginx/site.conf.template > /etc/nginx/sites-enabled/default"
fi
rm /etc/nginx/site.conf.template
rm /etc/nginx/site.devstage.conf.template
mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.orig
cp /etc/nginx/nginx.conf.template /etc/nginx/nginx.conf
rm /etc/nginx/nginx.conf.template

#bring up nginx
service nginx start
