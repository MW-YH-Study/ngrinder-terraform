# Stress Test Infrastructure

# 아래 내용 수정 필요!, 상위 README 로 이동 필요

## 1. 네트워크 구성 (`modules/network`)

### VPC

- CIDR: 10.0.0.0/16
- DNS hostnames 활성화
- DNS support 활성화

### Subnets

- Public Subnets (2개)
    * 10.0.1.0/24 (ngrinder subnet)
    * 10.0.2.0/24 (External ALB subnet)
- Private Subnet (1개)
    * 10.0.10.0/24 (applications subnet)

### Gateway

- Internet Gateway
- NAT Gateway (private subnet용)

### Route Tables

- Public Route Table
- Private Route Table

## 2. 스토리지 구성 (`modules/storage`)

### EFS

- Prometheus Data
    * 메트릭 데이터 저장
    * prevent_destroy 설정
- Grafana Data
    * 대시보드 설정 저장
    * prevent_destroy 설정
- ngrinder Data
    * 테스트 스크립트 저장
    * prevent_destroy 설정

### RDS

- PostgreSQL
- DB Instance: test-stress-postgres
- prevent_destroy 설정
- Public access 허용

## 3. 보안 구성 (`modules/security`)

### IAM Roles

- ECS Task Execution Role
- ECS Task Role

### Security Groups

- External ALB SG
- Internal ALB SG
- Chat Server SG
- Push Server SG
- Prometheus SG
- Grafana SG
- ngrinder Controller SG
- ngrinder Agent SG
- RDS SG
- EFS SG

## 4. ECS 클러스터 (`modules/ecs-cluster`)

- Cluster Name: test-stress-cluster
- Capacity Providers: FARGATE, FARGATE_SPOT

## 5. 로드밸런서 구성 (`modules/alb`)

### External ALB (ChatServer용)

- Public subnet에 위치
- HTTP 리스너
- Target group: 9090 포트

### Internal ALB (PushServer용)

- Private subnet에 위치
- HTTP 리스너
- Target group: 8090 포트

### Monitoring ALB (Grafana용)

- Private subnet에 위치
- HTTP 리스너
- Target group: 3000 포트

## 6. 애플리케이션 서버 (`modules/ecs-app`)

### ChatServer

- 이미지: yeonhyukkim/fake-chat-server:latest
- 포트: 9090
- Auto Scaling: 비활성화
- 환경변수:
    * SPRING_DATASOURCE_JDBC_URL
    * PUSH_SERVER_URL

### PushServer

- 이미지: yeonhyukkim/fake-push-server:latest
- 포트: 8090
- Auto Scaling: 활성화 (1-4개)
- 기본 실행 개수: 1

## 7. 모니터링 구성 (`modules/monitoring`)

### Prometheus

- Task Definition: 512 CPU, 1024 Memory
- EFS 마운트
- 포트: 9090

### Grafana

- Task Definition: 512 CPU, 1024 Memory
- EFS 마운트
- 포트: 3000
- ALB를 통한 접근

## 8. ngrinder 구성 (`modules/ngrinder`)

### Controller

- Task Definition: 1024 CPU, 2048 Memory
- EFS 마운트
- 포트: 80, 16001, 12000
- Public subnet에 위치

### Agent

- Task Definition: 1024 CPU, 2048 Memory
- 스케일링 가능
- Public subnet에 위치
- Service Discovery를 통한 Controller 연결

## 9. 변수 설정

### Required Variables

- aws_region
- project_name
- rds_password

### Optional Variables

- ngrinder_agent_count (default: 2)
- push_server_count (default: 1)

## 10. Outputs

- Chat Server URL
- ngrinder Controller Endpoint
- Grafana URL
- RDS Endpoint

## 11. 파일 구조

```
.
├── versions.tf
├── variables.tf
├── provider.tf
├── main.tf
├── outputs.tf
├── terraform.tfvars
└── modules/
    ├── network/
    ├── storage/
    ├── security/
    ├── ecs-cluster/
    ├── alb/
    ├── ecs-app/
    ├── monitoring/
    └── ngrinder/
```