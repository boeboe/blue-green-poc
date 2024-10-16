#!/bin/sh

# Replace the placeholder with the backend URL and write to a temp file
envsubst '\$BACKEND_URL' < /etc/nginx/nginx.conf > /etc/nginx/nginx.conf.tmp

# Overwrite the original nginx.conf with the updated one
mv /etc/nginx/nginx.conf.tmp /etc/nginx/nginx.conf

# Start Nginx
nginx -g 'daemon off;'