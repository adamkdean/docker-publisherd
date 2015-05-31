FROM adamkdean/baseimage
MAINTAINER Adam K Dean

# Download consul-template and extract it
RUN mkdir /var/service
ENV CT_URL https://github.com/hashicorp/consul-template/releases/download/v0.9.0/consul-template_0.9.0_linux_amd64.tar.gz /var/service
RUN curl -L $CT_URL | tar -C /usr/local/bin --strip-components 1 -zxf -

# Setup consul-template files
RUN mkdir /etc/consul-templates
ADD test.conf /etc/consul-templates/test.conf
ENV CT_FILE /etc/consul-templates/test.conf
ENV NX_FILE /etc/consul-templates/test-dest.conf

# Run this shit
CMD CONSUL_TEMPLATE_LOG=debug consul-template \
        -consul=ambassador:8500 \
        -template "$CT_FILE:$NX_FILE:cat $NX_FILE";
