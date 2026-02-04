# MyStar 구현 TODO

## 최근 구현 완료 항목 (2024년 세션)

### 타이틀 화면 (Title Screen) ✅
- [x] R 버튼 (좌측 상단) - 타이틀로 돌아가기
- [x] 팀 선택 드롭다운
- [x] 로스터 자동 포커스 (0.5초마다 순환)
- [x] 모든 선수 스탯 500 고정 (Preview 모드)
- [x] 8각형 레이더 차트 (RadarChartPainter)
- `lib/presentation/screens/title/title_screen.dart`

### 맵 추첨 화면 (Season Map Draw Screen) ✅
- [x] "맵 추첨 결과" 박스 상단 중앙 배치
- [x] Preview 모드 지원 (gameState 없을 때)
- [x] Responsive.init(context) 추가 (LateInitializationError 수정)
- `lib/presentation/screens/season_map_draw/season_map_draw_screen.dart`

### 이적 화면 (Transfer Screen) ✅ 대폭 개선
- [x] "요구 금액" 표시 (선택된 선수)
- [x] "영입" 버튼 조건부 표시 (보유금액 >= 요구금액)
- [x] 하단 드롭다운 기본값 "무소속", 다른 팀 선택 가능
- [x] 영입 시 My Team에 즉시 추가
- [x] 드롭다운 텍스트 가시성 개선 (amber 색상)
- [x] **방출 기능 구현:**
  - [x] "우리팀" 옵션 드롭다운에 추가
  - [x] 방출 금액 표시 (몸값의 50%)
  - [x] "방출" 버튼 활성화
- [x] R 버튼 추가
- `lib/presentation/screens/transfer/transfer_screen.dart`

### 메인 화면 (Main Menu Screen) ✅ 전면 재설계
- [x] 참조화면과 동일한 레이아웃
- [x] 좌/우: 팀 로고
- [x] 중앙: 정규 시즌 일정 (총 14경기)
- [x] **2매치마다 이벤트 분리:**
  - [x] 컨디션 회복 (별도 줄, 시안색)
  - [x] 개인리그 (별도 줄, 앰버색, 클릭 가능)
- [x] **개인리그 구체적 명칭:**
  - PC방 예선전
  - 듀얼토너먼트 1R / 2R / 3R
  - 조지명식
  - 32강 1,2R / 16강 1,2R
  - 8강 / 4강 / 결승
- [x] 팀 클릭 → 팀 정보 화면 이동
- [x] 개인리그 클릭 → 대진표 화면 이동
- [x] R 버튼 추가
- [x] Preview 모드 지원
- `lib/presentation/screens/main_menu/main_menu_screen.dart`

### 라우트 업데이트 ✅
- [x] 개인리그 라우트 파라미터 추가:
  - `/individual-league/pcbang`
  - `/individual-league/dual/:round`
  - `/individual-league/group-draw`
  - `/individual-league/main/:stage`
- `lib/app/routes.dart`

### R 버튼 (Reset Button) ✅ 전체 화면 적용 완료
- [x] 공통 위젯 생성 (`lib/presentation/widgets/reset_button.dart`)
- [x] 위치: 좌측 하단 (bottom: 80.sp, left: 16.sp)
- [x] **모든 화면에 적용:**
  - main_menu_screen, team_ranking_screen, pcbang_qualifier_screen
  - transfer_screen, title_screen, player_ranking_screen
  - player_info_screen, save_load_screen, roster_select_screen
  - match_simulation_screen, dual_tournament_screen, group_draw_screen
  - main_tournament_screen, season_end_screen, winners_league_screen
  - practice_match_screen, season_schedule_screen, match_result_ranking_screen
  - director_name_screen, team_select_screen

### 오류 수정 ✅
- [x] `getTeam` → `saveData.getTeamById` 수정
- [x] `race.name` → `race.code` 수정
- [x] `teamPlayers` → `playerTeamPlayers` 수정
- [x] Preview 모드 추가 (gameState null 처리)

---

## 기존 구현 완료 항목

### Phase 1: 핵심 데이터 모델 ✅
- [x] `lib/domain/models/enums.dart` - 종족, 등급, 레벨, 아이템 타입 등 열거형
- [x] `lib/domain/models/player.dart` - Player, PlayerStats, PlayerRecord 모델
- [x] `lib/domain/models/team.dart` - Team, TeamRecord 모델
- [x] `lib/domain/models/item.dart` - ConsumableItem, Equipment, Inventory 모델
- [x] `lib/domain/models/game_map.dart` - GameMap, RaceMatchup 모델
- [x] `lib/domain/models/match.dart` - MatchResult, SetResult, RosterSelection 등
- [x] `lib/domain/models/season.dart` - Season, TeamStanding, SeasonHistory 모델
- [x] `lib/domain/models/save_data.dart` - SaveData, SaveSlotInfo 모델

### Phase 2: 상태 관리 및 저장 ✅
- [x] `lib/data/repositories/save_repository.dart` - Hive 저장/로드 로직
- [x] `lib/data/providers/game_provider.dart` - Riverpod 상태 관리

### Phase 3: 경기 시뮬레이션 ✅
- [x] `lib/domain/services/match_simulation_service.dart` - 경기 시뮬레이션 엔진

### 초기 데이터 ✅
- [x] `lib/core/constants/initial_data.dart` - 2010 프로리그 12팀 선수 데이터

### 개인리그 화면들 ✅
- [x] PC방 예선 토너먼트 (`pcbang_qualifier_screen.dart`)
- [x] 듀얼토너먼트 (`dual_tournament_screen.dart`) - round 파라미터 추가
- [x] 조지명식 (`group_draw_screen.dart`)
- [x] 본선 토너먼트 (`main_tournament_screen.dart`) - stage 파라미터 추가

### 기타 화면들 ✅
- [x] 연습경기 화면 (`practice_match_screen.dart`)
- [x] 선수 순위 화면 (`player_ranking_screen.dart`)
- [x] 구단 순위 화면 (`team_ranking_screen.dart`)
- [x] 시즌 종료 화면 (`season_end_screen.dart`)
- [x] 위너스리그 화면 (`winners_league_screen.dart`)
- [x] 선수 정보 화면 (`player_info_screen.dart`)
- [x] 경기 후 팀 순위 화면 (`match_result_ranking_screen.dart`)

---

## 남은 구현 항목

### 우선순위 높음 🔴

#### 1. R 버튼 전체 화면 추가 ✅ 완료
- [x] player_ranking_screen
- [x] player_info_screen
- [x] save_load_screen
- [x] roster_select_screen
- [x] match_simulation_screen
- [x] dual_tournament_screen
- [x] group_draw_screen
- [x] main_tournament_screen
- [x] season_end_screen
- [x] winners_league_screen
- [x] practice_match_screen
- [x] season_schedule_screen
- [x] match_result_ranking_screen
- [x] director_name_screen
- [x] team_select_screen
- [x] pcbang_qualifier_screen
- [x] team_ranking_screen
- [x] transfer_screen

#### 2. R 버튼 위치 통일 ✅ 완료
- [x] 좌측 하단 (bottom: 80.sp, left: 16.sp)
- [x] 공통 위젯 사용 (ResetButton.positioned())

#### 3. 게임 플로우 연결
- [ ] 새 게임 시작 → 감독명 입력 → 팀 선택 → 맵 추첨 → 초기 영입 → 메인 화면
- [ ] Next 버튼 클릭 시 다음 이벤트로 진행
- [ ] 프로리그 경기 진행 플로우
- [ ] 개인리그 경기 진행 플로우

#### 4. 시즌 데이터 생성
- [ ] 14경기 일정 자동 생성
- [ ] 개인리그 일정 연동
- [ ] 시즌 저장/불러오기 테스트

### 우선순위 중간 🟡

#### 5. AI 팀 운영
- [ ] AI 로스터 편성 로직
- [ ] AI 팀 관리 (휴식/특훈) 로직
- [ ] AI 아이템 사용 로직

#### 6. 행동 관리 화면
- [ ] 휴식/특훈/팬미팅 UI
- [ ] 행동력 소모 및 효과 적용
- [ ] 컨디션 변화 표시

#### 7. 아이템 상점 화면
- [ ] 아이템 목록 표시
- [ ] 구매/판매 기능
- [ ] 장비 장착/해제

### 우선순위 낮음 🟢

#### 8. 세부 기능
- [ ] 선수 사진 등록 기능
- [ ] 배속 조절 (x1/x2/x4/x8)
- [ ] 사운드 효과
- [ ] 키보드 단축키 (PgUp/PgDn 등)

#### 9. 테스트 및 밸런스
- [ ] 전체 시즌 플레이 테스트
- [ ] 밸런스 조정 (승률, 금액 등)
- [ ] 버그 수정

---

## 확정된 게임 시스템

### 시즌 구조
- 1라운드 = 1주
- 2매치마다: 팀 컨디션 +5, 행동력 +100
- 총 14경기 (7라운드 × 2매치)

### 개인리그 일정
| 단계 | 라운드 | 비고 |
|------|--------|------|
| PC방 예선 | 1R | 모든 선수 참가 |
| 듀얼토너먼트 1R | 2R | |
| 듀얼토너먼트 2R | 3R | |
| 조지명식/듀얼토너먼트 3R | 4R | |
| 32강 1,2R | 5-6R | |
| 16강 1,2R | 7-8R | |
| 8강/4강/결승 | 플레이오프 | |

### 자금/행동력
- 행동력: 2매치마다 +100
- 휴식: 50 소모, 컨디션 +4~5
- 특훈: 100 소모, 능력치 상승, 컨디션 -1
- 팬미팅: 200 소모, 치어풀+소지금, 컨디션 -2

### 컨디션
- 최대: 110 (표시: 100)
- 경기 승리: -4
- 경기 패배: -5
- 2매치 완료: +5 (팀 전체)

---

## 파일 구조

```
lib/
├── app/
│   ├── app.dart
│   ├── routes.dart ✅ 업데이트
│   └── theme.dart
├── core/
│   ├── constants/
│   │   └── initial_data.dart
│   └── utils/
│       └── responsive.dart
├── data/
│   ├── providers/
│   │   └── game_provider.dart
│   └── repositories/
│       └── save_repository.dart
├── domain/
│   ├── models/
│   │   └── *.dart
│   └── services/
│       ├── match_simulation_service.dart
│       └── individual_league_service.dart
├── presentation/
│   ├── widgets/
│   │   └── reset_button.dart ✅ NEW
│   └── screens/
│       ├── title/ ✅ 업데이트
│       ├── main_menu/ ✅ 전면 재설계
│       ├── transfer/ ✅ 대폭 개선
│       ├── season_map_draw/ ✅ 업데이트
│       ├── team_ranking/ ✅ R버튼 추가
│       ├── individual_league/ ✅ 업데이트
│       └── ... (기타 화면들)
└── main.dart
```
