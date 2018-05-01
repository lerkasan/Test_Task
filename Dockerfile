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
COPY config/nginx/internship.macpaw.io.conf /etc/nginx/conf.d/nginx.conf

# Add Logrotate config
COPY config/logrotate/* /etc/logrotate.d/
RUN chmod 644 /etc/logrotate.d/dpkg /etc/logrotate.d/supervisor

# Copy src for changing default page to additional information about me
COPY src/webapp .
COPY src/scripts/* scripts/

RUN chmod +x scripts/*

# Optional. Just to show decryption of additional tasks during docker build process.
RUN scripts/calculate_password.sh
