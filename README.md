# CI/CD 및 Docker 학습 정리


## Continuous Integration (CI)
- 지속적 통합
- 빌드 → 테스트 → 머지 과정을 자동화하여 코드 변경 사항을 빠르게 통합

## Continuous Delivery (CD)
- 자동으로 릴리즈(Release)를 **저장소(Repository)**에 배포

## Continuous Deployment
- 자동으로 **프로덕션 환경**에 배포

---

## 🛠️ 선행 작업
- GitHub 계정 생성
- DockerHub 계정 생성
- MobaXterm 다운로드

---

## 🌐 IP 대역 설정
- Master1 → 고정 IP (클러스터 환경이므로 IP가 고정됨)
- Subnet: `172.xxx.xxx.xxx`
- 시작 IP: `172.xxx.xxx.xxx`
- 종료 IP: `172.xxx.xxx.xxx`
- Gateway: `172.xxx.xxx.xxx`
- 예시 IP: `172.xxx.xxx.xxx`

<br>

🧾 Git 사용법

- Commit ID는 CI/CD 트리거로 동작할 수 있음
- 특정 commit으로 돌아가기


```
git log [commit id 확인 가능]
git checkout <commit_id>
```

<br>

이전 commit  상태로 돌아가기
```
git checkout -
```

<br>

현재 경로 모든 파일 등록

```
git add .
```

---

<br>

# 📌 Docker 기본 명령어

```
# 컨테이너 생성 (-p: 포트 매핑, --name: 이름 지정)
- docker container create -p 80:80 --name webserver nginx

# run = create + start
- docker run -d -p 8080:80 --name test_port nginx

# 컨테이너 내부 접근
- docker container run -it --name test_bash centos /bin/bash


-it: 인터랙티브 모드

/bin/bash: 컨테이너 쉘 진입

# 실행 중 컨테이너 확인(cpu, 메모리 사용률 확인)
docker container stats [name]


# 실행 중 컨테이너 접속
docker exec -it <container_name> /bin/bash

# 컨테이너 → 이미지 저장
docker container commit <container_name> <new_image_name>
```

## 🐳 Dockerfile 멀티스테이지(Multi-Stage Build)

### 📌 개념
- 하나의 Dockerfile 안에서 **여러 개의 빌드 단계(Stage)**를 정의하는 방법
- `FROM` 키워드를 여러 번 사용하여 각 단계별로 환경을 분리
- 최종적으로 필요한 산출물만 마지막 이미지에 포함

예시:
```dockerfile
# 1단계: 빌드 단계
FROM golang:1.20 AS builder
WORKDIR /app
COPY . .
RUN go build -o myapp

# 2단계: 실행 단계 (최종 이미지)
FROM alpine:3.18
WORKDIR /app
COPY --from=builder /app/myapp .
CMD ["./myapp"]
