FROM adamkdean/baseimage
MAINTAINER Adam K Dean

# Install Curl & Nginx
RUN apt-get update -qq && \
    apt-get -y install curl

# Install latest version of docker
RUN apt-get install -q -y apt-transport-https && \
    echo deb https://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9 && \
    apt-get update && \
    apt-get install -q -y lxc-docker

# Download consul-template and extract it
RUN mkdir /var/service
ENV CT_URL https://github.com/hashicorp/consul-template/releases/download/v0.9.0/consul-template_0.9.0_linux_amd64.tar.gz /var/service
RUN curl -L $CT_URL | tar -C /usr/local/bin --strip-components 1 -zxf -

# WORK IN PROGRESS
RUN mkdir /etc/consul-templates

ENV NGINX_TEMPLATE /etc/consul-templates/nginx-template.conf
ENV NGINX_CONFIG /var/nginx/conf.d/app.conf
ADD templates/nginx-template.conf $NGINX_TEMPLATE

ENV RELOAD_TEMPLATE /etc/consul-templates/reload-template.conf
ENV RELOAD_CONFIG /var/nginx/reload.sh
ADD templates/reload-template.conf $RELOAD_TEMPLATE

# Logging level
ENV CONSUL_TEMPLATE_LOG debug

# Run this shit
CMD consul-template \
        -consul=ambassador:8500 \
        -template "$RELOAD_TEMPLATE:$RELOAD_CONFIG:echo 'done updating reload config'" \
        -template "$NGINX_TEMPLATE:$NGINX_CONFIG:bash /var/nginx/reload.sh";
