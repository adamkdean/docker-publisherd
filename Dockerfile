FROM adamkdean/baseimage
MAINTAINER Adam K Dean

# Install Curl
RUN apt-get update -qq && apt-get -y install curl

# Install Haproxy
RUN \
  sed -i 's/^# \(.*-backports\s\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get install -y haproxy=1.5.3-1~ubuntu14.04.1 && \
  sed -i 's/^ENABLED=.*/ENABLED=1/' /etc/default/haproxy && \
  rm -rf /var/lib/apt/lists/*

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

# Setup template files for haproxy
ENV HAPROXY_TEMPLATE /etc/consul-templates/haproxy-template.conf
ENV HAPROXY_CONFIG /etc/haproxy/haproxy.cfg
ADD templates/haproxy-template.conf $HAPROXY_TEMPLATE
ADD haproxy.sh /haproxy-start

# Logging level
ENV CONSUL_TEMPLATE_LOG debug

# Port exposure
EXPOSE 5000

# Run this shit
CMD bash /haproxy-start
    && consul-template \
        -consul=ambassador:8500 \
        -template "$AMBASSADOR_TEMPLATE:$AMBASSADOR_CONFIG:. $AMBASSADOR_CONFIG" \
        -template "$HAPROXY_TEMPLATE:$HAPROXY_CONFIG:service haproxy reload";
