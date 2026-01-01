FROM eclipse-temurin:11-jdk

ARG KAFKA_VERSION=3.5.2
ARG SCALA_VERSION=2.13

ENV KAFKA_HOME=/opt/kafka
ENV PATH=$PATH:$KAFKA_HOME/bin

RUN apt-get update && \
    apt-get install -y wget netcat-openbsd curl jq && \
    wget https://archive.apache.org/dist/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz && \
    tar -xzf kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz && \
    mv kafka_${SCALA_VERSION}-${KAFKA_VERSION} ${KAFKA_HOME} && \
    rm kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz

# Create plugin directory
RUN mkdir -p ${KAFKA_HOME}/plugins

# Install Debezium MySQL Connector
RUN wget https://repo1.maven.org/maven2/io/debezium/debezium-connector-mysql/2.4.0.Final/debezium-connector-mysql-2.4.0.Final-plugin.tar.gz && \
    tar -xzf debezium-connector-mysql-2.4.0.Final-plugin.tar.gz -C ${KAFKA_HOME}/plugins && \
    rm debezium-connector-mysql-2.4.0.Final-plugin.tar.gz

# Install Debezium Postgres Connector
RUN wget https://repo1.maven.org/maven2/io/debezium/debezium-connector-postgres/2.4.0.Final/debezium-connector-postgres-2.4.0.Final-plugin.tar.gz && \
    tar -xzf debezium-connector-postgres-2.4.0.Final-plugin.tar.gz -C ${KAFKA_HOME}/plugins && \
    rm debezium-connector-postgres-2.4.0.Final-plugin.tar.gz

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

WORKDIR ${KAFKA_HOME}

EXPOSE 8083

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
