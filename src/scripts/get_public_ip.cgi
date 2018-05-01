#!/usr/bin/env bash

PUBLIC_IP=`dig +short myip.opendns.com @resolver1.opendns.com`

SOURCE="bash script"
METHOD="FastCGI"

echo "HTTP/1.0 200 OK"
echo "Content-type: text/html"
echo ""

sed "s/{{public_ip}}/${PUBLIC_IP}/" ../templates/public_ip.html |
    sed "s/{{source}}/${SOURCE}/" |
    sed "s/{{method}}/${METHOD}/"

exit 0
