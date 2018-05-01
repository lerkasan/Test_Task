#!/usr/bin/env bash

docker build -t internship_lerkasan:latest .

# Please comment this line if you uncomment "nohup docker run ..." line
docker run --name internship_lerkasan --rm -p 80:80 internship_lerkasan:latest

# Uncomment this to see unencrypted additional tasks and browse webapp
# Info: Unencrypted additional tasks are also shown during docker build process as a result of step the last instruction "RUN scripts/calculate_password.sh"
#nohup docker run --name internship_lerkasan -p 80:80 internship:latest &
#sleep 5
#docker exec internship_lerkasan /app/scripts/calculate_password.sh

# Uncomment this to clean up if needed
#docker stop internship_lerkasan
#docker rm internship_lerkasan
docker rmi $(docker images | grep 'internship_lerkasan')