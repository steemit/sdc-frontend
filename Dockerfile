FROM nginx:1.26.0-alpine

# Install required packages for GeoIP2
RUN apk add --no-cache \
    libmaxminddb \
    libmaxminddb-dev \
    gettext \
    bash \
    git \
    build-base \
    pcre-dev \
    zlib-dev \
    openssl-dev \
    linux-headers \
    wget

# Configure git and wget to use proxy if set
RUN if [ -n "$HTTP_PROXY" ]; then \
        git config --global http.proxy "$HTTP_PROXY" && \
        git config --global https.proxy "$HTTPS_PROXY"; \
    fi

# Download and compile ngx_http_geoip2_module
WORKDIR /tmp
RUN git clone --depth 1 https://github.com/leev/ngx_http_geoip2_module.git

# Get nginx version and compile geoip2 module
RUN NGINX_VERSION=$(nginx -v 2>&1 | sed -n 's/.*nginx version: nginx\/\([0-9.]*\).*/\1/p') && \
    NGINX_BUILD_ARGS=$(nginx -V 2>&1 | sed -n 's/.*arguments: \(.*\)/\1/p') && \
    wget --no-check-certificate -q http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz && \
    tar -xzf nginx-${NGINX_VERSION}.tar.gz && \
    cd nginx-${NGINX_VERSION} && \
    eval ./configure ${NGINX_BUILD_ARGS} --add-dynamic-module=../ngx_http_geoip2_module && \
    make modules && \
    cp objs/ngx_http_geoip2_module.so /usr/lib/nginx/modules/ && \
    cd / && \
    rm -rf /tmp/nginx-${NGINX_VERSION}* /tmp/ngx_http_geoip2_module && \
    apk del git build-base pcre-dev zlib-dev openssl-dev linux-headers libmaxminddb-dev wget

# Copy GeoIP2 database from project directory
# Run ./download-geoip.sh before building Docker image
# Check if GeoIP2 database exists, fail build if missing
RUN mkdir -p /usr/share/GeoIP2
COPY geoip/ /tmp/geoip2-check/
RUN test -f /tmp/geoip2-check/Country.mmdb || (echo "ERROR: geoip/Country.mmdb not found! Please run ./download-geoip.sh before building." && exit 1)
RUN cp /tmp/geoip2-check/Country.mmdb /usr/share/GeoIP2/Country.mmdb && rm -rf /tmp/geoip2-check

# Create necessary directories for nginx
RUN mkdir -p /etc/nginx/sites-enabled /etc/nginx/conf.d /var/cache/nginx /var/run/nginx

# Copy configuration files
COPY startservices.sh /usr/bin/startservices.sh
RUN chmod +x /usr/bin/startservices.sh

COPY site* /etc/nginx/
COPY nginx.conf.template /etc/nginx/nginx.conf.template

EXPOSE 8081

CMD ["/usr/bin/startservices.sh"]
