#!/bin/sh

mkdir -p $NGINX_SSL_PATH 

envsubst '$SSL_CERT_PATH $SSL_KEY_PATH $ROOT_PATH' < /etc/nginx/nginx.template > /etc/nginx/nginx.conf

echo $SSL_CERT_PATH
echo $SSL_KEY_PATH

echo "$SSL_CERT" | base64 -d > $SSL_CERT_PATH
echo "$SSL_KEY" | base64 -d > $SSL_KEY_PATH 

nginx -g "daemon off;"
