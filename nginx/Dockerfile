FROM adamkdean/baseimage
MAINTAINER Adam K Dean

RUN apt-get update -qq && \
    apt-get -y install nginx

# RUN rm -rf /etc/nginx/sites-enabled/default

CMD nginx -c /etc/nginx/nginx.conf
