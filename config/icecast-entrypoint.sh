#!/bin/sh

# Replace placeholders in icecast.xml with environment variables
sed -i "s/ADMIN_PASSWORD_PLACEHOLDER/${ICECAST_ADMIN_PASSWORD}/g" /etc/icecast.xml
sed -i "s/SOURCE_PASSWORD_PLACEHOLDER/${ICECAST_SOURCE_PASSWORD}/g" /etc/icecast.xml
sed -i "s/RELAY_PASSWORD_PLACEHOLDER/${ICECAST_RELAY_PASSWORD}/g" /etc/icecast.xml
sed -i "s/ICECAST_HOSTNAME_PLACEHOLDER/${ICECAST_HOSTNAME}/g" /etc/icecast.xml

# Start Icecast
exec icecast -c /etc/icecast.xml
