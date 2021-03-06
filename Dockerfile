FROM macpaw/internship

EXPOSE 80

# Update everything.
# This step may be commented to save time by minimizing latency of "docker build" proccess
RUN apt-get update -y && \
#   apt-get upgrade -y && \
    pip install --upgrade pip

# Install packages necessary for additional tasks
RUN apt-get install -y logrotate \
                       fcgiwrap \
                       dnsutils && \
    pip install dnspython \
                flask

# Create folder for uwsgi logs
RUN mkdir /var/log/uwsgi && \
    chown www-data /var/log/uwsgi

# Change uWSGI and Nginx config to fix "502 - Internal server error" and add misc configuration - permissions, logging
COPY config/nginx/internship.macpaw.io.conf /etc/nginx/conf.d/nginx.conf
COPY config/uwsgi/uwsgi.ini .

# Change uWSGI config and use emperor to launch two serapate uwsgi proccesses
# with different socket files to serve different webapp to different hostnames:
# pure wsgi main_no_flask.py on localhost and flask main_flask.py on custom hostname
COPY config/uwsgi/emperor.ini /etc/uwsgi/
COPY config/uwsgi/main*.ini /etc/uwsgi/vassals/
RUN chown www-data /etc/uwsgi/vassals

# Create log folder for fcgiwrap service and copy its default config
RUN mkdir /var/log/fcgiwrap && \
    chown www-data /var/log/fcgiwrap && \
    cp /usr/share/doc/fcgiwrap/examples/nginx.conf /etc/nginx/fcgiwrap.conf && \
    sed -i 's/www-data/nginx/g' /etc/init.d/fcgiwrap

# Add fcgiwrap service to startup via supervisor
COPY config/supervisor/supervisord.conf /etc/supervisor/conf.d/

# Add Logrotate config
COPY config/logrotate/* /etc/logrotate.d/
RUN chmod 644 /etc/logrotate.d/dpkg /etc/logrotate.d/supervisor

# Copy src for changing default page to additional information about me
COPY src/webapp .
COPY src/scripts/* scripts/
RUN chmod +x scripts/*

# Optional. Just to show decryption of additional tasks during docker build process.
RUN scripts/calculate_password.sh
