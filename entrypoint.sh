#!/bin/bash

# server.properties 생성
cat > $KAFKA_HOME/config/kraft/server.properties <<EOF
process.roles=${KAFKA_PROCESS_ROLES}
node.id=${KAFKA_NODE_ID}
controller.quorum.voters=${KAFKA_CONTROLLER_QUORUM_VOTERS}
listeners=${KAFKA_LISTENERS}
advertised.listeners=${KAFKA_ADVERTISED_LISTENERS}
listener.security.protocol.map=${KAFKA_LISTENER_SECURITY_PROTOCOL_MAP}
controller.listener.names=${KAFKA_CONTROLLER_LISTENER_NAMES}
inter.broker.listener.name=${KAFKA_INTER_BROKER_LISTENER_NAME}
log.dirs=${KAFKA_LOG_DIRS}
group.initial.rebalance.delay.ms=0
num.partitions=1
default.replication.factor=3
min.insync.replicas=2
auto.create.topics.enable=true
EOF

# KAFKA_CLUSTER_ID가 설정되어 있지 않으면 에러 발생
if [ -z "$KAFKA_CLUSTER_ID" ]; then
    echo "ERROR: KAFKA_CLUSTER_ID is not set."
    exit 1
fi

# 로그 디렉토리가 비어있거나 meta.properties가 없으면 포맷팅 수행
if [ ! -f "$KAFKA_LOG_DIRS/meta.properties" ]; then
    echo "Formatting Kafka storage with Cluster ID: $KAFKA_CLUSTER_ID"
    kafka-storage.sh format -t $KAFKA_CLUSTER_ID -c $KAFKA_HOME/config/kraft/server.properties
else
    echo "Kafka storage already formatted."
fi

# Kafka 서버 시작
echo "Starting Kafka server..."
exec kafka-server-start.sh $KAFKA_HOME/config/kraft/server.properties
