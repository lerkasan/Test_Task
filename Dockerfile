FROM macpaw/internship

EXPOSE 80

# Update everything.
# This step may be commented to save time by minimizing latency of "docker build" proccess
RUN apt-get update -y && \
    apt-get upgrade -y

RUN apt-get install -y logrotate

# Create folder for uwsgi logs
RUN mkdir /var/log/uwsgi

# Change uWSGI and Nginx config to fix "502 - Internal server error" and add misc configuration - permissions, logging
COPY config/uwsgi/uwsgi.ini .
COPY config/nginx/nginx.conf /etc/nginx/conf.d/nginx.conf
