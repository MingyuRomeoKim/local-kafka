# https://hub.docker.com/r/apache/kafka/tags?name=3.&ordering=-last_updated
# 위 도커 hub 사이트에서는 작성일 기준, 3.7.0 버전이 마지막 버전으로 JDK 1.8을 지원하는 3.5.x버전을 다운받을 수 없음.
# https://downloads.apache.org/kafka/  < 여기에서도 마지막 버전이 3.7.2로 3.5.x 버전 다운로드 불가. 
# https://archive.apache.org/dist/kafka/ < 여기서 3.5.x 버전 다운로드 가능.

FROM eclipse-temurin:8-jdk 
# eclipse-temurin:8-jdk 이미지는 ubuntu 기반으로 빌드된 이미지. 떄문에 apt install시 ubuntu에서 동작하는지 확인해야함.

ARG KAFKA_VERSION=3.5.2
ARG SCALA_VERSION=2.13

ENV KAFKA_HOME=/opt/kafka
ENV PATH=$PATH:$KAFKA_HOME/bin

RUN apt-get update && \
    apt-get install -y wget netcat-openbsd && \
    wget https://archive.apache.org/dist/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz && \
    tar -xzf kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz && \
    mv kafka_${SCALA_VERSION}-${KAFKA_VERSION} ${KAFKA_HOME} && \
    rm kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

WORKDIR ${KAFKA_HOME}

EXPOSE 9092 9093

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]