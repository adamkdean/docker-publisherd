FROM nginx:1.7
MAINTAINER Adam K Dean

# Install Curl
RUN apt-get update -qq && apt-get -y install curl

# Download consul-template and extract it
RUN mkdir /var/service
ENV CT_URL https://github.com/hashicorp/consul-template/releases/download/v0.9.0/consul-template_0.9.0_linux_amd64.tar.gz /var/service
RUN curl -L $CT_URL | tar -C /usr/local/bin --strip-components 1 -zxf -

# Create required directories
RUN mkdir /etc/consul-templates /etc/ambassador

# Setup template files for ambassador environment vars
ENV AMBASSADOR_TEMPLATE /etc/consul-templates/ambassador-template.conf
ENV AMBASSADOR_CONFIG /etc/ambassador/ambassador.sh
ADD templates/ambassador-template.conf $AMBASSADOR_TEMPLATE

# Setup template files for nginx
ENV NGINX_TEMPLATE /etc/consul-templates/nginx-template.conf
ENV NGINX_CONFIG /etc/nginx/nginx.conf
ADD templates/nginx-template.conf $NGINX_TEMPLATE

# Logging level
ENV CONSUL_TEMPLATE_LOG debug

# Run this shit
CMD nginx -c $NGINX_CONFIG \
    & consul-template \
        -consul=ambassador:8500 \
        -template "$AMBASSADOR_TEMPLATE:$AMBASSADOR_CONFIG:. $AMBASSADOR_CONFIG" \
        -template "$HAPROXY_TEMPLATE:$HAPROXY_CONFIG:/usr/sbin/nginx -s reload";
