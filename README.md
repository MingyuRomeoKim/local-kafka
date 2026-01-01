# Kafka 3.5.2 KRaft 클러스터 구축 가이드
Docker Compose를 사용하여 Zookeeper 없이 KRaft 모드로 동작하는 3개 노드의 Kafka 클러스터를 구축합니다.

## 주요 사항
1. Entrypoint 스크립트 (entrypoint.sh):
- 환경 변수를 기반으로 server.properties 설정 파일을 동적으로 생성합니다.
- 일관된 Cluster ID를 사용하여 Kafka 스토리지를 자동으로 포맷팅합니다.

2. Dockerfile:
- Kafka 버전을 3.5.2로 업그레이드했습니다.
- 커스텀 > entrypoint.sh 스크립트를 이미지에 포함시켰습니다.
- 9092 및 9093 포트를 개방(Expose)했습니다.

3. Docker Compose:
- 3개의 브로커(kafka-1, kafka-2, kafka-3)를 정의했습니다.
- KRaft 쿼럼을 구성했습니다 (1@kafka-1:9093,...).
- 각 브로커를 호스트의 9092, 9094, 9096 포트로 노출했습니다.
- Kafka UI를 http://localhost:8080에 통합하여 웹 인터페이스를 제공합니다.

4. 리스너 분리 (Listener Configuration):
- INTERNAL: Kafka UI 및 브로커 간 통신용 (포트 29092, 도커 네트워크 내부).
- EXTERNAL: 호스트 머신에서의 접근용 (포트 9092/9094/9096, localhost).
- 이 설정을 통해 Kafka UI가 브로커에 접속하지 못하는 500 에러를 해결했습니다.

## 검증 결과
1. 클러스터 쿼럼 (Cluster Quorum)
클러스터가 3개의 투표자(Voter)로 정상적인 쿼럼을 형성했습니다.
```
CurrentVoters:          [1,2,3]
LeaderId:               2
```

2. Kafka UI
Kafka UI가 정상적으로 실행 중이며 클러스터에 연결되었습니다.
```
주소: http://localhost:8080
상태: 온라인 (local-cluster 모니터링 중)
```

## 3. 실행 방법 (Kafka Connect 포함)

기존 `docker-compose.yml`에 Kafka Connect 서비스가 추가되었습니다.

1. **Docker Compose 실행**
   ```bash
   docker-compose up -d --build
   ```
   * `--build` 옵션을 추가하여 `connect/Dockerfile`을 빌드해야 합니다.

2. **상태 확인**
   ```bash
   docker-compose ps
   ```
   * `kafka-1`, `kafka-2`, `kafka-3` (Brokers)
   * `kafka-ui` (Management UI)
   * `kafka-connect` (Connect Service)

## 4. Web UI 접속

* **Kafka UI**: [http://localhost:8080](http://localhost:8080)
    * Kafka Cluster 정보 확인 (Brokers, Topics, Consumers)
    * **Kafka Connect** 메뉴에서 `kafka-connect` 클러스터가 연결된 것을 확인할 수 있습니다.
    * `Create Connector` 버튼을 눌러 Debezium 플러그인 (MySQL, Postgres)이 설치되어 있는지 확인하세요.

## 5. Kafka Connect 플러그인 확인

Kafka Connect 컨테이너 로그를 통해 플러그인이 정상적으로 로드되었는지 확인할 수 있습니다.

```bash
docker logs kafka-connect | grep "Added plugin"
```
또는 Kafka UI의 Kafka Connect 메뉴에서 확인할 수 있습니다.