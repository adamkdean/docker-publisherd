FROM nginx:1.7
MAINTAINER Adam K Dean

# Logging level
# default is ENV CONSUL_TEMPLATE_LOG warn
ENV CONSUL_TEMPLATE_LOG debug

# Install curl
RUN apt-get update -qq && apt-get -y install curl

# Download consul-template and extract it
RUN mkdir /var/service
ENV CT_URL https://github.com/hashicorp/consul-template/releases/download/v0.9.0/consul-template_0.9.0_linux_amd64.tar.gz /var/service
RUN curl -L $CT_URL | tar -C /usr/local/bin --strip-components 1 -zxf -

# Setup consul-template files
ENV CT_FILE /etc/consul-templates/nginx.conf
ENV NX_FILE /etc/nginx/nginx.conf
RUN mkdir /etc/consul-templates
ADD nginx-template.conf $CT_FILE

ENV BACKEND_8500 consul-8500.service.consul

# # Run this shit
# CMD /usr/sbin/nginx -c /etc/nginx/nginx.conf \
#     & consul-template \
#         -consul=ambassador:8500 \
#         -template "$CT_FILE:$NX_FILE:/usr/sbin/nginx -s reload";

# Run this other shit
CMD consul-template \
        -consul=ambassador:8500 \
        -template "$CT_FILE:$NX_FILE:cat $NX_FILE";
