FROM adamkdean/baseimage
MAINTAINER Adam K Dean

RUN apt-get update -qq && \
    apt-get -y install nginx

RUN echo "daemon off;" >> /etc/nginx/nginx.conf
RUN rm -f /etc/nginx/sites-available/default
# ADD default /etc/nginx/sites-available/default
# ADD src/ /var/www

EXPOSE 80

CMD "nginx"
