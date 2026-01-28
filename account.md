# 📑 Project: 기록하는 부 (Asset Insight App)

본 문서는 자산 인사이트 앱의 기획, 보안, 설계 및 개발 규약을 정의한 통합 가이드라인입니다.

---

## 1. 프로젝트 개요
- **목표**: 거시적인 관점에서 전체 자산(현금, 주식, 부동산 등)의 추이 관찰 및 관리.
- **핵심 가치**: "나의 자산은 과거 대비 얼마나 성장했는가?"에 대한 시점별 인사이트(%) 제공.
- **개발 환경**: Android (Java 기반)
- **배포 전략**: 비상업용 개인 프로젝트 (APK 직접 설치 및 개인 활용)

---

## 2. 주요 기능 정의 (Functional Specs)
- **자산 스냅샷**: 날짜별 각 카테고리 잔액 기록 (UPSERT 전략: 동일 날짜 입력 시 덮어쓰기).
- **인사이트**: 현재 자산과 과거(1일 전, 1개월 전, 6개월 전, 1년 전) 자산의 증감액 및 증감률(%) 계산.
- **데이터 보간 로직**: 특정 시점 기록 부재 시, 해당 시점 이전의 **가장 가까운 과거 데이터**를 자동으로 참조하여 분석.
- **과거 데이터 소급**: 날짜 선택기를 통해 과거 특정 시점의 데이터를 자유롭게 입력 및 수정.

---

## 3. 데이터베이스 설계 (ERD)
### Entity: `AssetSnapshot`
- **Primary Keys**: `date` (yyyy-MM-dd), `categoryId` (Composite Key)
- **Fields**: `amount` (long), `memo` (String)

### 핵심 DAO Query (가장 가까운 과거 기록 조회)
SELECT amount FROM asset_snapshot 
WHERE categoryId = :catId AND date <= :targetDate 
ORDER BY date DESC LIMIT 1;
---

## 4. 보안 설계 (Security)
- **파일 암호화**: `SQLCipher`를 사용하여 SQLite DB 파일 자체를 AES-256 암호화하여 저장.
- **생체 인증**: 앱 진입 시 `BiometricPrompt` API를 통한 지문/얼굴 인식 필수 적용.
- **화면 보안**: 최근 앱 목록(Recents)에서 자산 정보 노출 차단 (`FLAG_SECURE` 적용).
- **난독화**: `R8/ProGuard` 적용으로 소스 코드 역공학(Reverse Engineering) 및 비즈니스 로직 유출 방지.
- **취약점 스캔**: 배포 전 `MobSF` 등의 도구를 활용하여 정적/동적 보안 취약점 점검.

---

## 5. 스타일 가이드 (Style & Layout)
- **Zero Hard-coding 원칙**: 모든 UI 요소에 하드코딩된 색상 값(#FFFFFF 등) 사용 절대 금지.
- **테마 관리**: `values/colors.xml`과 `values-night/colors.xml`을 1:1 매칭하여 다크/라이트 모드 완벽 대응.
- **참조 방식**: 레이아웃 XML에서는 직접적인 @color 대신 테마 속성(`?attr/colorSurface`) 사용 권장.
- **반응형 디자인**: `ConstraintLayout`을 기본으로 사용하며, `dp`(크기)와 `sp`(폰트) 단위를 사용하여 다양한 화면 크기(모바일/태블릿/폴더블)에 대응.

---

## 6. 소스 구조 템플릿 (Source Structure)
com.example.assetinsight
├── data
│   ├── local (Entity, DAO, Database 정의)
│   └── repository (데이터 소스 결정 및 비즈니스 로직 중재)
├── ui
│   ├── dashboard (메인 차트 및 시점별 증감률 인사이트 카드)
│   └── input (날짜 선택 및 자산 금액 수동 입력 폼)
├── util
│   ├── DateUtils (날짜 계산, 비교 및 포맷팅 유틸)
│   ├── SecurityHelper (생체 인증 및 암호화 관리 클래스)
│   └── ViewExtensions (UI 관련 편의 확장 함수)
└── AppContext.java (전역 애플리케이션 설정 및 Timber 로깅 초기화)

## 7. 개발 전 필수 설정 & 컨벤션 (Pre-dev Checklist)
1. **ViewBinding 활성화**: `findViewById` 배제 및 Null-safety, 타입 안정성 확보.
2. **local.properties 활용**: API 키 및 보안 암호 키를 소스 코드에서 분리하여 보안 강화.
3. **Timber 로깅**: 배포(Release) 버전에서는 로그가 자동으로 출력되지 않도록 초기화 설정.
4. **Vector Asset 사용**: 모든 아이콘은 SVG 기반 XML로 관리하여 저해상도부터 고해상도까지 대응.
5. **리소스 네이밍**: `구분_위치_역할` 규칙 준수 (예: `btn_input_save`, `tv_dash_total`).
6. **LeakCanary**: 개발 단계에서 메모리 누수 실시간 감지 및 성능 최적화.
7. **Monospace Font**: 자산 금액 표시 시 숫자의 정렬 유지를 위해 고정폭 폰트 적용.
8. **App Inspection**: Android Studio의 전용 툴을 활용한 실시간 DB 데이터 모니터링.
9. **Network Security Config**: HTTPS 통신을 강제하고 신뢰할 수 없는 도메인 차단 설정.
10. **Build Variants**: Debug/Release 빌드별로 난독화 여부 및 API 엔드포인트 분리 설정.

---

## 8. 인프라 및 CI/CD
- **Docker**: GitHub Actions 등 CI 서버 빌드 시 Android SDK 환경 표준화를 위해 Docker 컨테이너 활용.
- **Export/Import**: 자산 데이터를 마크다운(.md) 또는 CSV로 내보내 로컬에 저장하거나 백업하는 기능 구현.

---