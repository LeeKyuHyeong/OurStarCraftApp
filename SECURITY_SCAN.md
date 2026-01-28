# 보안 취약점 스캔 가이드

배포 전 MobSF(Mobile Security Framework)를 사용하여 정적/동적 보안 취약점을 점검합니다.

## MobSF 설치 및 실행

### 방법 1: Docker 사용 (권장)

```bash
# MobSF 이미지 다운로드 및 실행
docker run -it --rm -p 8000:8000 opensecurity/mobile-security-framework-mobsf:latest
```

브라우저에서 `http://localhost:8000` 접속

### 방법 2: 직접 설치

```bash
git clone https://github.com/MobSF/Mobile-Security-Framework-MobSF.git
cd Mobile-Security-Framework-MobSF
./setup.sh  # Linux/Mac
setup.bat   # Windows
./run.sh    # Linux/Mac
run.bat     # Windows
```

## APK 스캔 방법

1. Release APK 빌드:
   ```bash
   ./gradlew assembleRelease
   ```

2. APK 파일 위치: `app/build/outputs/apk/release/app-release.apk`

3. MobSF 웹 인터페이스에서 APK 업로드

4. 스캔 결과 확인

## 점검 항목 체크리스트

### 필수 점검
- [ ] 하드코딩된 비밀번호/API 키 없음
- [ ] 디버그 모드 비활성화 (Release)
- [ ] 로그에 민감 정보 출력 없음
- [ ] SSL Pinning 적용 (네트워크 사용 시)
- [ ] Root/Jailbreak 탐지 (필요 시)

### SQLCipher 관련
- [ ] DB 암호화 키가 코드에 하드코딩되지 않음
- [ ] local.properties에서 키 로드 확인

### 권한 관련
- [ ] 불필요한 권한 요청 없음
- [ ] 권한 사용 목적 명확

### 데이터 저장
- [ ] SharedPreferences에 민감 정보 저장 안 함
- [ ] 외부 저장소에 민감 정보 저장 안 함

## 스캔 결과 등급

| 등급 | 설명 | 조치 |
|------|------|------|
| High | 심각한 보안 취약점 | 배포 전 반드시 수정 |
| Medium | 중간 수준 취약점 | 가능하면 수정 권장 |
| Low | 경미한 취약점 | 검토 후 판단 |
| Info | 정보성 알림 | 참고만 |

## 참고 자료

- [MobSF 공식 문서](https://mobsf.github.io/docs/)
- [OWASP Mobile Security](https://owasp.org/www-project-mobile-security/)
- [Android Security Best Practices](https://developer.android.com/topic/security/best-practices)
