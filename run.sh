#!/bin/bash
echo "start"
set -e

# MongoDb host
MD_HOST=${MD_HOST:-127.0.0.1}

#ElasticSearch cluster hosts
ES_CLUSTER_HOSTS=${ES_CLUSTER_HOSTS:-127.0.0.1:9300}

#ElasticSearch cluster name
ES_CLUSTER_NAME=${ES_CLUSTER_NAME:-elasticsearch}

sed -i -e "s/mongodb_host =.*$/mongodb_host = ${MD_HOST}/" /etc/graylog/server/server.conf
sed -i -e "s/elasticsearch_cluster_name =.*$/elasticsearch_cluster_name = ${ES_CLUSTER_NAME}/" /etc/graylog/server/server.conf
#sed -i -e "s/#elasticsearch_network_host =.*$/elasticsearch_network_host = ${ES_CLUSTER_HOSTS}/" /etc/graylog/server/server.conf
sed -i -e "s/elasticsearch_discovery_zen_ping_unicast_hosts =.*$/elasticsearch_discovery_zen_ping_unicast_hosts = ${ES_CLUSTER_HOSTS}/" /etc/graylog/server/server.conf
cd /opt/

# Start graylog2 server
./graylog2-server/bin/graylogctl start >> /var/log/graylog/graylog2-server-out.log
./graylog2-web-interface/bin/graylog-web-interface >> /var/log/graylog/graylog-web-interface.log
# Fallback console logging
tail -f /dev/null