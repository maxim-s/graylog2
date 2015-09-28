#!/bin/bash
echo "start"
set -e
sed -i -e "s/mongodb_host =.*$/mongodb_host = ${MD_HOST}/" /etc/graylog/server/server.conf
sed -i -e "s/elasticsearch_network_host =.*$/elasticsearch_network_host = ${ES_HOST}:9300/" /etc/graylog/server/server.conf
sed -i -e "s/elasticsearch_discovery_zen_ping_unicast_hosts =.*$/elasticsearch_discovery_zen_ping_unicast_hosts = ${ES_HOST}:9300/" /etc/graylog/server/server.conf
# Services starter for graylog2
cd /opt/
# Start graylog2 server
./graylog2-server/bin/graylogctl start >> /var/log/graylog/graylog2-server-out.log
./graylog2-web-interface/bin/graylog-web-interface >> /var/log/graylog/graylog-web-interface.log
# Fallback console logging
tail -f /dev/null