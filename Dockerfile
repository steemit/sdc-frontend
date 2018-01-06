FROM phusion/baseimage:0.9.22

RUN \
    apt-get update && \
    apt-get install -y \
        nginx-full \
        gettext \
    && \
    apt-get clean

ADD startservices.sh /usr/bin/startservices.sh
RUN chmod +x /usr/bin/startservices.sh

ADD site.conf /etc/nginx/site.conf
ADD devstage.conf /etc/nginx/devstage.conf
ADD nginx.conf /etc/nginx/nginx.conf
ADD proxy.conf /etc/nginx/proxy.conf

EXPOSE 8081

CMD /usr/bin/startservices.sh
