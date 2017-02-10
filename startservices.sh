#!/bin/bash

# generate nginx config on the fly and feed in any appropriate environment variables
/bin/bash -c "envsubst '\$SERVER_NAME \$WSPA_SERVER' < /etc/nginx/site.conf.template > /etc/nginx/sites-enabled/default"
rm /etc/nginx/site.conf.template
mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.orig
cp /etc/nginx/nginx.conf.template /etc/nginx/nginx.conf
rm /etc/nginx/nginx.conf.template
#/bin/bash -c "envsubst '\$GOOGLE_CLIENT_ID \$GOOGLE_CLIENT_SECRET \$COOKIE_SECRET' < /etc/oauth2_proxy/oauth2.config.template > /etc/oauth2_proxy/oauth2.config"
#rm /etc/oauth2_proxy/oauth2.config.template

#bring up nginx
service nginx start
