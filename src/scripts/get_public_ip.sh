#!/usr/bin/env bash

PUBLIC_IP=`dig +short myip.opendns.com @resolver1.opendns.com`

echo "My public IP is ${PUBLIC_IP}"