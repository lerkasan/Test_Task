FROM macpaw/internship

EXPOSE 80

# Update everything.
# This step may be commented to save time by minimizing latency of "docker build" proccess
RUN apt-get update -y && \
    apt-get upgrade -y

RUN apt-get install -y logrotate