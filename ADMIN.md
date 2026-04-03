# Admin Site & Backend 구상 (ADMIN.md)

> 현재 앱 단독 구조에서 시나리오 관리용 관리자 사이트 + 풀 백엔드 추가 검토

## 현재 구조 (앱 단독)

```
Flutter App (Android)
├── 시나리오 데이터 → Dart 코드에 하드코딩 (scenario_scripts.dart)
├── 저장 → Hive (로컬)
└── 수정 → 코드 수정 → 빌드 → 배포
```

## 목표 구조 (풀 백엔드)

```
[Admin Web]  ←→  [Backend API]  ←→  [DB]
  시나리오 편집       CRUD + 검증        시나리오/빌드 저장
  해설 텍스트 입력     인증/권한          사용자 데이터
  보정 테스트         버전 관리          게임 세이브 (선택)
                        ↕
                   [Flutter App]
                     시나리오 sync
                     게임 플레이
```

## 구성요소

| 레이어 | 역할 | 기술 스택 후보 |
|--------|------|---------------|
| **Backend API** | 시나리오 CRUD, 검증, 인증/권한, 버전 관리 | NestJS (TS), Spring Boot (Java), Django (Python) |
| **DB** | 시나리오/빌드/사용자 데이터 영구 저장 | PostgreSQL (관계형, 시나리오 구조에 적합) |
| **Admin Web** | 시나리오 편집 UI, 해설 텍스트 입력/분석, 보정 테스트 | Flutter Web (코드 공유) 또는 React/Next.js |
| **인증** | 관리자 계정 | JWT |
| **배포** | 서버 호스팅 | AWS, GCP, 또는 VPS |

## 핵심 기능

### Admin Web
- 시나리오 CRUD (생성/조회/수정/삭제)
- 해설 텍스트 붙여넣기 → 분석 → 시나리오 반영 워크플로우
- 보정 테스트 실행 및 결과 확인 (calibration_criteria 검증)
- 시나리오 미리보기

### Backend API
- 시나리오/빌드 데이터 CRUD
- calibration_criteria 검증 로직 (현재 Node.js 스크립트 → API화)
- 앱 호환성 버전 관리 (시나리오 스키마 버전)
- 관리자 인증

### Flutter App 변경점
- 현재 Dart const 객체 (`ScenarioScript`) → JSON 직렬화/역직렬화 레이어 추가
- 앱 실행 시 서버에서 시나리오 fetch
- 오프라인 대비 로컬 캐시 전략 (마지막 sync 데이터 Hive 저장)
- 앱 재배포 없이 시나리오 업데이트 가능 (핫 리로드)

## 얻는 것

- 코드 수정/빌드/배포 없이 시나리오 추가/보정 가능
- 해설 영상 텍스트 기반 시나리오 작성 워크플로우
- 보정 결과 즉시 확인
- 여러 영상 텍스트 누적 분석 → 분기 확률/이벤트 풍부화

## 고려할 점

- `ScenarioScript`가 현재 Dart const 객체 → DB 저장하려면 JSON 스키마 설계 필요
- JSON ↔ ScenarioScript 양방향 변환 레이어
- 오프라인 플레이 시 로컬 캐시 데이터로 동작해야 함
- 관리자 1인 사용이면 인증은 단순하게 가능

## 규모 참고

| 축 | 현재 | 비고 |
|---|------|------|
| **데이터량** | 시나리오 ~75개, 빌드 ~60개, 이벤트 수천 개 | 코드만 수천 줄 규모 |
| **사용자 수** | 로컬 앱 (1인) | 배포 시 증가 |
| **기능 복잡도** | 앱 1개 | → 앱 + 어드민 + API + DB + 인증 |
| **트래픽** | 없음 (로컬) | 서버 추가 시 발생 |

## 미결정 사항

- [ ] 기술 스택 최종 선택 (Backend: NestJS vs Spring Boot vs Django)
- [ ] Admin Web: Flutter Web vs React/Next.js
- [ ] DB 스키마 설계 (ScenarioScript JSON 구조)
- [ ] 배포 환경 선택 (AWS vs GCP vs VPS)
- [ ] 게임 세이브 데이터도 서버 저장할지 (클라우드 세이브)
- [ ] 시나리오 버전 관리 전략 (앱 버전별 호환)
