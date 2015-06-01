FROM adamkdean/baseimage
MAINTAINER Adam K Dean

RUN apt-get update -qq && \
    apt-get -y install nginx

RUN rm -rf /etc/nginx/sites-enabled/default
RUN cat /etc/nginx/nginx.conf

CMD echo 'running...' && nginx -c /etc/nginx/nginx.conf
