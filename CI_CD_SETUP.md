# CI/CD 설정 가이드

## GitHub Actions Secrets 설정

GitHub 저장소 > Settings > Secrets and variables > Actions에서 다음 시크릿을 설정합니다:

### 필수 시크릿

| 시크릿 이름 | 설명 |
|------------|------|
| `DB_ENCRYPTION_KEY` | 데이터베이스 암호화 키 |

### Release 빌드용 시크릿 (선택)

| 시크릿 이름 | 설명 |
|------------|------|
| `KEYSTORE_BASE64` | Release 서명 키스토어 (Base64 인코딩) |
| `KEYSTORE_PASSWORD` | 키스토어 비밀번호 |
| `KEY_ALIAS` | 키 별칭 |
| `KEY_PASSWORD` | 키 비밀번호 |

### 키스토어 Base64 변환 방법

```bash
# Linux/Mac
base64 -i release-keystore.jks -o keystore-base64.txt

# Windows (PowerShell)
[Convert]::ToBase64String([IO.File]::ReadAllBytes("release-keystore.jks")) > keystore-base64.txt
```

## 로컬 Docker 빌드

### 사전 요구사항
- Docker Desktop 설치

### 빌드 명령어

```bash
# Debug APK 빌드
docker-compose run android-build

# Release APK 빌드
docker-compose run android-release

# 테스트 실행
docker-compose run android-test

# Lint 검사
docker-compose run android-lint
```

### 환경 변수 설정 (.env 파일)

프로젝트 루트에 `.env` 파일 생성:

```env
DB_ENCRYPTION_KEY=your_secure_key_here
KEYSTORE_PASSWORD=your_keystore_password
KEY_ALIAS=your_key_alias
KEY_PASSWORD=your_key_password
```

## GitHub Actions 워크플로우

### 트리거 조건

| 이벤트 | 브랜치 | 실행 작업 |
|--------|--------|----------|
| Push | main, develop | Build, Test, Lint |
| Pull Request | main | Build, Test, Lint |
| Release 생성 | - | Build, Test, Lint, Release APK |

### 아티팩트

| 이름 | 설명 | 보관 기간 |
|------|------|----------|
| debug-apk | Debug APK | 7일 |
| release-apk | Release APK | 30일 |
| test-results | 테스트 결과 | 7일 |
| lint-results | Lint 검사 결과 | 7일 |

## Release 빌드 방법

1. GitHub에서 새 Release 생성
2. 태그 버전 지정 (예: v1.0.0)
3. GitHub Actions가 자동으로 Release APK 빌드
4. Release 페이지에 APK 자동 첨부

## 문제 해결

### Gradle 빌드 실패
- Gradle 캐시 삭제: `docker-compose down -v`
- 재빌드: `docker-compose build --no-cache`

### SDK 라이선스 오류
- Dockerfile에서 라이선스 동의 확인
- `sdkmanager --licenses` 재실행
