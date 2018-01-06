#!/bin/bash

if [[ -z "$SERVER_NAME" ]]; then export SERVER_NAME=steemitdev.com; fi

# generate nginx config on the fly and feed in any appropriate environment variables
sed -i "s/__SERVER_NAME__/$(echo $SERVER_NAME | sed 's|\.|\\.|g')/g" /etc/nginx/site*.conf

# enable devstage config if NO_ROBOTS is set
mkdir /etc/nginx/site-extra
if [[ "$NO_ROBOTS" ]]; then
    ln -sf /etc/nginx/devstage.conf /etc/nginx/site-extra/devstage.conf
fi

# bring up nginx
service nginx start
