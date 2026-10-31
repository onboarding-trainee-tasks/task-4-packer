#!/bin/bash
set -e

sudo apt update
sudo apt install -y nginx docker.io docker-compose-v2 wget

wget -O /tmp/oauth2-proxy.tar.gz \
  https://github.com/oauth2-proxy/oauth2-proxy/releases/download/v7.15.3/oauth2-proxy-v7.15.3.linux-amd64.tar.gz

tar -xzf /tmp/oauth2-proxy.tar.gz -C /tmp

sudo cp /tmp/oauth2-proxy-v7.15.3.linux-amd64/oauth2-proxy /usr/local/bin/
sudo chmod +x /usr/local/bin/oauth2-proxy