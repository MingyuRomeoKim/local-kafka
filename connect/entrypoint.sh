#!/bin/bash

# Define Kafka Connect properties file
CONNECT_PROPERTIES="$KAFKA_HOME/config/connect-distributed.properties"

# Update bootstrap servers
if [ ! -z "$BOOTSTRAP_SERVERS" ]; then
    sed -i "s|bootstrap.servers=localhost:9092|bootstrap.servers=$BOOTSTRAP_SERVERS|g" $CONNECT_PROPERTIES
fi

# Set plugin path
echo "plugin.path=$KAFKA_HOME/plugins" >> $CONNECT_PROPERTIES

# Set key and value converters to JSON
sed -i "s|key.converter=org.apache.kafka.connect.json.JsonConverter|key.converter=org.apache.kafka.connect.json.JsonConverter|g" $CONNECT_PROPERTIES
sed -i "s|value.converter=org.apache.kafka.connect.json.JsonConverter|value.converter=org.apache.kafka.connect.json.JsonConverter|g" $CONNECT_PROPERTIES

# Adjust other settings if needed (e.g., schemas.enable)
echo "key.converter.schemas.enable=false" >> $CONNECT_PROPERTIES
echo "value.converter.schemas.enable=false" >> $CONNECT_PROPERTIES

# Offset, Config, and Status storage topics
echo "offset.storage.topic=connect-offsets" >> $CONNECT_PROPERTIES
echo "offset.storage.replication.factor=1" >> $CONNECT_PROPERTIES
echo "config.storage.topic=connect-configs" >> $CONNECT_PROPERTIES
echo "config.storage.replication.factor=1" >> $CONNECT_PROPERTIES
echo "status.storage.topic=connect-status" >> $CONNECT_PROPERTIES
echo "status.storage.replication.factor=1" >> $CONNECT_PROPERTIES

# Start Kafka Connect
exec $KAFKA_HOME/bin/connect-distributed.sh $CONNECT_PROPERTIES
