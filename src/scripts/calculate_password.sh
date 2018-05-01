#!/usr/bin/env bash

LOG_FILE_PATH="/var/log/nginx/old.log"
ETAG_HINT_URL="http://hint.macpaw.io"
REMOTE_ADDRESS="8.8.8.8"
IGNORE_HTTP_STATUS="200"
ENCRYPTED_ADDITIONAL_TASKS_FILE_PATH="/tmp/additional.zip"

# Line by line explanation:
# 1. Obtain list of every status code occurrences except ignored.
# 2. Use associative array to count each status code occurrences and print pairs < occurrences, status code >.
# 3. Sort status code descending by occurrence count and pick pair with maximum occurrences.
# 4. Pick pure status code from pair.
FREQUENT_NON200_RESPONSE=`grep -v "status=${IGNORE_HTTP_STATUS}" ${LOG_FILE_PATH} | awk '{print $8}' | \
                          awk '{arr[$1]+=1} END {for (i in arr) {print arr[i], i}}' | \
                          sort -r | head -n 1 | \
                          awk '{print $2}' | sed "s/status=//"`

REQUESTS_NUMBER_FROM_8888=`grep "remote_addr=${REMOTE_ADDRESS}" ${LOG_FILE_PATH} | wc -l`

ETAG_HEADER_TWO_FIRST_CHARS=`curl -s --head ${ETAG_HINT_URL} | grep ETag | awk '{print $2}' | sed "s/\"//g" | head -c2`

((PASSWORD = ${FREQUENT_NON200_RESPONSE} + ${REQUESTS_NUMBER_FROM_8888} + ${ETAG_HEADER_TWO_FIRST_CHARS}))

echo "Password for encrypted archive with additional tasks is ${PASSWORD}"

unzip -cP ${PASSWORD} ${ENCRYPTED_ADDITIONAL_TASKS_FILE_PATH}
