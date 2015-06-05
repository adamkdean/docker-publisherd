FROM adamkdean/baseimage
MAINTAINER Adam K Dean

RUN apt-get update -qq && \
    apt-get -y install nginx

ADD nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

CMD "nginx"
