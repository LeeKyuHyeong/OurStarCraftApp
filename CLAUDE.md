# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

MyStar - 스타크래프트 프로게이머/팀 육성 시뮬레이션 게임 (Flutter Android App)

## Build Commands

```bash
# 앱 실행 (디버그)
flutter run

# 릴리스 APK 빌드
flutter build apk --release

# Hive 모델 변경 시 코드 생성 (*.g.dart 파일 재생성)
dart run build_runner build --delete-conflicting-outputs

# 린트 검사
flutter analyze

# 테스트 실행
flutter test

# 단일 테스트 파일 실행
flutter test test/pvp/scenarios_100games_test.dart

# 이름으로 특정 테스트만 실행
flutter test -n "PvP S1:" test/pvp/scenarios_100games_test.dart

# 1경기 테스트 (빌드 ID 변경하여 사용)
flutter test --name "ZvZ" test/single_test.dart

# 보정 루프용 JSON 내보내기
flutter test --name "ZvZ" test/calibration_test.dart

# 전 종족전 3경기+1000경기 통계
flutter test --name "TvT" test/all_scenarios_test.dart

# 특정 시나리오 3경기+1000경기 통계 (종족전 전체 대신 해당 시나리오만 실행)
flutter test --name "TvT.*bbs_vs_1bar_double" test/all_scenarios_test.dart
```

## Flutter 실행 환경 (Bash에서 실행 시 필수)

Git Bash 환경에서 flutter 명령어 실행 시 반드시 아래 PATH를 먼저 설정해야 한다.
flutter.bat이 내부적으로 `WHERE`(Windows CMD 전용)와 `PowerShell.exe`를 PATH에서 찾기 때문.

```bash
export PATH="$PATH:/c/flutter/bin:/c/Program Files/Git/bin:/c/Windows/System32:/c/Windows/System32/WindowsPowerShell/v1.0"
```

이 설정 없이 `flutter` 명령어를 실행하면 `WHERE not found` 또는 `PowerShell not found` 오류가 발생한다.
**모든 flutter 명령어(test, analyze, run 등) 실행 전에 위 export를 반드시 앞에 붙일 것.**

## Architecture

**Stack**: Flutter + Riverpod (상태관리) + Hive (로컬 저장) + GoRouter (라우팅)

```
lib/
├── app/              # 앱 설정 (theme.dart, routes.dart, app.dart)
├── core/
│   ├── constants/    # 초기 데이터 + 시나리오 스크립트 (아래 별도 설명)
│   └── utils/        # Responsive 유틸리티
├── data/
│   ├── providers/    # Riverpod providers (game_provider, match_provider)
│   └── repositories/ # Hive 저장소 (save_repository, player_image_repository)
├── domain/
│   ├── models/       # 데이터 모델 (Player, Team, Match, Season, Item 등)
│   └── services/     # 비즈니스 로직 (match_simulation_service, individual_league_service, playoff_service)
└── presentation/
    ├── screens/      # 화면별 UI (20+ 폴더, 화면당 1폴더)
    └── widgets/      # 공통 위젯 (player_radar_chart, player_thumbnail, reset_button)
```

### 데이터 파일 구조 (`core/constants/`)

```
scenario_scripts.dart     # 프레임워크 클래스 정의 + part 선언 + 스크립트 선택 로직
scenarios/{matchup}/      # 종족전별 시나리오 (tvt/tvz/pvt/pvp/zvp/zvz, 1:1 빌드 매칭)
scenarios/docs/           # SCENARIO_RULES / build_timings / calibration_status / unit_costs
build_orders.dart         # 빌드오더 + 빌드 선택 시스템 (아래 별도 설명)
initial_data.dart         # 초기 데이터 (선수/팀 생성)
map_data.dart             # 게임 맵 정의 (맵 태그, 종족별 승률)
team_data.dart            # 팀 초기 데이터
```

> 종족전별 시나리오 개수 및 Y/O/X 보정 상태는 `scenarios/docs/calibration_status.md` 전체 요약 테이블 참조 (숫자 rot 방지를 위해 여기에는 중복 기재하지 않음).

### build_orders.dart 구조

빌드 정의 + 빌드 선택 시스템 (~3,400줄)

**클래스 5개:**
- `BuildStep`: 빌드 단계 이벤트 (line, text, stat, army/resource 변동)
- `BuildOrder`: 빌드오더 정의 (id, race, vsRace, style, steps)
- `RaceOpening`: 오프닝 빌드 (line 1~16, aggressionTier 0~3)
- `RaceTransition`: 트랜지션 빌드 (line 20~, keyStats)
- `BuildOrderData`: 빌드 저장소 + 빌드 선택 유틸리티 (static 메서드)

> 이벤트 풀 (`ClashEvent`, `getMidLateEvent`, `getClashEvents` 등)은 시나리오 100% 커버로 불필요해져 제거됨.

### tools/ 디렉토리

| 파일 | 용도 |
|------|------|
| `tools/calibration_criteria.js` | 시뮬레이션 로그(JSON) 검증. A/B/C/D 계층 규칙 적용 → PASS/FAIL 리포트 생성. `node tools/calibration_criteria.js <log.json>` |
| `tools/coverage_analysis.js` | 종족전별 빌드 ID 커버리지 분석 (누락/중복 체크) |
| `tools/export_log_helper.dart` | Dart 테스트에서 JSON 로그 내보내기 헬퍼 (`test/calibration_test.dart`가 import) |

## Key Components

### State Management (`game_provider.dart`)
- `gameStateProvider`: 전체 게임 상태 관리 (StateNotifierProvider)
- `GameState`: SaveData를 감싸는 상태 객체 (playerTeam, currentSeason, inventory 등)
- `GameStateNotifier`: 게임 로직 메서드 (startNewGame, loadGame, save, updatePlayer 등)
- 파생 Provider: `playerTeamPlayersProvider`, `allTeamsProvider`, `currentSeasonProvider`, `inventoryProvider` 등이 `gameStateProvider`에 의존

### Match Simulation (`match_simulation_service.dart`)
- **Stream 기반**: `simulateMatchWithLog()`가 `Stream<SimulationState>`를 반환 → UI가 실시간 소비
- `SimulationState`: 병력/자원/확장수/로그 상태 (`homeExpansions`/`awayExpansions` 포함)
- `BattleLogEntry`: 로그 텍스트 + 소유자(home/away/system)
- `getIntervalMs()` 콜백으로 시뮬레이션 중 속도 변경 가능
- 테스트 시 `forcedHomeBuildId`, `forcedAwayBuildId` 파라미터로 특정 빌드 조합 강제 지정
- **확장 보너스**: `homeExpansion: true` 이벤트 → 해당 측 recovery +100/확장
- **자원 감쇠**: 자원 1000 이상 시 recovery 감쇠 (1600+ 25% 하한) → ASL 장기전 4000~6000 스톡파일 허용

### Models (`domain/models/`)
- `Player`: 선수 (능력치 8개: sense, control, attack, harass, strategy, macro, defense, scout)
- `PlayerStats`: 능력치 클래스 (컨디션 적용, 성장/하락 로직 포함)
- `Team`: 팀 (players, money, actionPoints)
- `Match`: 경기 정보 (7전 4선승제)
- `Season`: 시즌 (프로리그 + 개인리그)
- Hive 어노테이션 사용 (`@HiveType`, `@HiveField`) - 모델 변경 시 `build_runner` 실행 필요

> 레벨/커리어 분리 시스템, 경험치 테이블, 커리어 단계 등 **세부 시스템 변경 이력**은 사용자 `MEMORY.md` 참조 (세션 자동 로드).

### Hive TypeId 할당 (전체 맵)

| TypeId | 클래스 | 파일 |
|--------|--------|------|
| 0 | PlayerStats | player.dart |
| 1 | PlayerRecord | player.dart |
| 2 | Player | player.dart |
| 3 | TeamRecord | team.dart |
| 4 | Team | team.dart |
| 5 | ConsumableItem | item.dart |
| 6 | Equipment | item.dart |
| 7 | EquipmentInstance | item.dart |
| 8 | Inventory | item.dart |
| 9 | RaceMatchup | game_map.dart |
| 10 | GameMap | game_map.dart |
| 11 | SetResult | match.dart |
| 12 | MatchResult | match.dart |
| 13 | ScheduleItem | match.dart |
| 14 | IndividualMatchResult | match.dart |
| 15 | IndividualLeagueBracket | match.dart |
| 16 | RosterSelection | match.dart |
| 17 | Season | season.dart |
| 18 | TeamStanding | season.dart |
| 19 | SeasonHistory | season.dart |
| 20 | SaveData | save_data.dart |
| 21 | SaveSlotInfo | save_data.dart |
| 22 | PlayoffBracket | season.dart |

> 새 TypeId 추가 시 **23번부터** 할당할 것.

### Navigation (`app/routes.dart`)
- GoRouter 사용, 명명된 라우트로 이동: `context.pushNamed('teamSelect')`
- 쿼리 파라미터 지원: `/individual-league/pcbang?viewOnly=true`
- 경로 파라미터 지원: `/individual-league/dual/:round`

### Responsive System (`core/utils/responsive.dart`)
- `Responsive.sp(size)`: 전체 비율 적용 (폰트, 아이콘)
- `Responsive.w(width)`: 너비 비율 적용
- `Responsive.h(height)`: 높이 비율 적용
- Extension: `14.sp`, `100.w`, `50.h`

## 네이밍 규칙

- **빌드 ID**: `{matchup}_{build_name}` (예: `'tvz_bunker'`, `'pvp_2gate_dragoon'`)
- **시나리오 ID**: `{matchup}_{description}` (예: `'pvp_dragoon_nexus_mirror'`)
- **맵 태그**: `'rushShort'`, `'rushLong'`, `'airHigh'`, `'terrainHigh'`

> 선수 위치(`home`/`away`) 규칙은 별도 `## Home/Away 규칙` 섹션 참조.

## UI/Layout Rules

- **가로 스크롤 금지**: 모든 화면 360~412dp 내 표시
- **Overflow 방지**: `Expanded`, `Flexible`, `TextOverflow.ellipsis` 사용
- **반응형 크기**: `Responsive.sp()` 사용 (고정 픽셀 금지)
- **기준 해상도**: 360 x 800 (세로 모드 고정)

## Code Style

- `*.g.dart`, `*.freezed.dart` 파일은 자동 생성 - 직접 수정 금지
- `prefer_const_constructors` 활성화 - 가능한 곳에 `const` 사용
- `avoid_print: false` - 디버그용 print 허용

## 테스트

통합 테스트 (test/ 루트):
- `test/all_scenarios_test.dart` - 전 종족전 3경기 로그 + 1000경기 통계 + 분기 분포 (`--name "ZvZ"` 필터링)
  - **특정 시나리오만** 최신화 요청 시: `--name "{종족전}.*{시나리오_label}"` 패턴 사용 (예: `--name "TvT.*bbs_vs_1bar_double"`)
  - 종족전 전체가 아닌 해당 시나리오 하나만 실행하므로 훨씬 빠름
- `test/calibration_test.dart` - 전 종족전 보정 루프용 JSON 로그 내보내기 (`--name "ZvZ"` 필터링)
- `test/single_test.dart` - 전 종족전 1경기 로그 확인 (`--name "ZvZ"` 필터링, 빌드 ID 변경하여 사용)
- `test/scenario_detail_test.dart` - 시나리오 상세 검증 (매 이벤트마다 병력/자원 추이 추적, `--name "Detail TvT"` 필터링)
- `test/build_selection_test.dart` - 전 종족전 빌드 선택 비율 통계 (맵 조건 6가지 × 선수 조합 4가지 × 1000경기, `--name "ZvZ"` 필터링)
- 홈/어웨이 편향 검증은 `calibration_test.dart` + `calibration_criteria.js C14`가 단일 책임 (±5%p 자동 FAIL)

테스트 공용 헬퍼:
- `test/helpers/test_helpers.dart` - 선수/맵/시나리오 생성 + 빌드 ID 상수 + 출력 유틸리티 (전 테스트 파일 공유)

테스트 공통:
- 테스트 출력: `test/output/{matchup}/` 디렉토리에 마크다운/JSON 리포트 생성
- 테스트 패턴: 동일 능력치(~700) + 100% 컨디션 선수로 균형 시나리오 검증, `forcedHomeBuildId`/`forcedAwayBuildId`로 빌드 고정

### 보정 기준
- 승률: 동일 능력치 기준 30~70% (미러는 45~55%)
- 홈/어웨이: 반전 시 승률 차이 ±5%p 이내
- 다양성: 500경기 중 최소 50+ 고유 로그

## 스타크래프트 경기 다움 (핵심 원칙)

경기 시뮬레이션의 최우선 목표는 **실제 스타크래프트 중계를 보는 듯한 몰입감**이다.
모든 경기는 시나리오 스크립트(`ScenarioScript`)로 진행되며, 빌드 조합마다 고유한 내러티브가 펼쳐진다.

> **시나리오 작성/보정 시 참조 파일** (작성 전 반드시 확인):
> - `lib/core/constants/scenarios/docs/SCENARIO_RULES.md` — 양쪽 동시 비용 반영, 비용 체계, Recovery, 텍스트 규칙
> - `lib/core/constants/scenarios/docs/build_timings.md` — 빌드별 표준 타이밍 (건물 착공/완성, 첫 유닛, line 매핑). **종족전 공용** — 등재된 빌드는 재조사 금지, 새 빌드 조사 시 즉시 등재
> - `lib/core/constants/scenarios/docs/calibration_status.md` — 전 종족전 보정 통합 현황 (빌드/시나리오 목록 + Y/X 상태)
> - `lib/core/constants/scenarios/docs/unit_costs.md` — 전 종족 유닛/건물/업그레이드 비용 기준표 (army/resource 값 단일 진실 공급원)

### Recovery 빠른 참조 (상세: SCENARIO_RULES.md §3)

- base **50/line** (전 시나리오 공통, 개별 설정 금지 — D1 규칙)
- 확장당 **+100** (`homeExpansion`/`awayExpansion` 플래그)
- 자원 **1000 이상** 감쇠 시작, **1600+ 25% 하한** (ASL 장기전 4000~6000 스톡파일 허용)
- 중/후반 전투 이벤트는 **−500 이상 과감하게** 써야 실제 자원 감소

### 시나리오 스크립트 구조

```
ScenarioScript
├── phases: [ScriptPhase, ...]     # 경기 흐름 단계 (오프닝 → 중반 → 결전)
│   ├── linearEvents: [ScriptEvent]  # 순차 이벤트 (오프닝, 전개)
│   └── branches: [ScriptBranch]     # 분기 이벤트 (교전, 결전 - 능력치/확률 기반 선택)
├── homeBuildIds / awayBuildIds      # 매칭 대상 빌드 (겹침 금지)
└── mapRequirement                   # 맵 조건 필터 (선택)
```

- **Phase**: 이전 페이즈 종료 후 순차 활성화, linearEvents(순차) 또는 branches(분기) 중 하나. `startLine`은 Phase 0만 필수(시나리오 진입 게이트)
- **Branch**: 분기 선택 2단계 — ①빌드 ID 필터링(`conditionHomeBuildIds`/`conditionAwayBuildIds`) → ②능력치 필터링(`conditionStat` + `baseProbability`)
- **Event**: 텍스트 + 병력/자원 변동 + `decisive`(즉시 승패)

### 1:1 빌드 시나리오 구조 (전 종족전)

모든 종족전이 **빌드 vs 빌드 1:1 시나리오**로 완전 분리되어 있다 (총 284개).
각 시나리오 파일이 하나의 빌드 조합을 전담하며, `homeBuildIds`/`awayBuildIds`에 단일 빌드만 지정한다.
트랜지션 분기 구조는 더 이상 사용하지 않는다.
**모든 빌드 조합이 100% 시나리오 커버** → build_orders.dart 이벤트 풀은 제거됨.
Phase 1+의 startLine도 제거 — 이전 페이즈 종료 후 즉시 다음 페이즈 시작.

### 내러티브 품질 규칙

1. **빌드 자연 노출**: 빌드명을 직접 언급하지 않고, 건물/유닛 생산 묘사를 통해 자연스럽게 드러남
2. **방송 어미 톤**: 시나리오 텍스트 원본 그대로 출력 (수동 보정된 어미 유지)
3. **텍스트 다양성**: `altText`(50% 대체), `skipChance`(확률 스킵)으로 매번 다른 경기 연출
4. **해설 코멘터리**: `LogOwner.system` 이벤트로 상황 해설 삽입
5. **건물명 규칙**: 실제 방송 해설 톤에 맞춘 건물 명칭 사용 (아래 표 참조)

> 금지어/마인 규칙/톤(느낌표·콤마)/체크리스트 등 **시나리오 텍스트 작성 세부 규칙**은 `lib/core/constants/scenarios/docs/SCENARIO_RULES.md` 참조 — 본 문서에 중복 기재하지 않는다.

### 건물명 표기 기준

시나리오/빌드오더 텍스트에서 건물 이름은 아래 표를 따른다. **정식 명칭이 아닌 해설 톤의 약칭**을 사용.

#### 테란
| 건물 | 표기 | 비고 |
|------|------|------|
| Command Center | `커맨드센터` | 붙여쓰기 |
| Barracks | `배럭` | |
| Factory | `팩토리` | |
| Starport | `스타포트` | |
| Engineering Bay | `엔지니어링 베이` | |
| Academy | `아카데미` | |
| Armory | `아머리` | |
| Bunker | `벙커` | |
| Missile Turret | `터렛` | |
| Machine Shop | `머신샵` | |
| Control Tower | `컨트롤타워` | 붙여쓰기 |
| Science Facility | `사이언스 퍼실리티` | |
| Nuclear Silo | `뉴클리어` | |
| Comsat Station | `컴샛` | ~~코맷 스테이션~~ 사용 금지 |

#### 프로토스
| 건물 | 표기 | 비고 |
|------|------|------|
| Nexus | `넥서스` | |
| Gateway | `게이트웨이` | |
| Pylon | `파일런` | |
| Forge | `포지` | |
| Photon Cannon | `캐논` | ~~포토캐논~~ 사용 금지 |
| Cybernetics Core | `사이버네틱스 코어` | |
| Robotics Facility | `로보틱스` | ~~로보틱스 퍼실리티~~ 사용 금지 |
| Citadel of Adun | `아둔` | ~~시타델~~ 사용 금지 |
| Templar Archives | `템플러 아카이브` | |
| Stargate | `스타게이트` | |
| Fleet Beacon | `플릿 비콘` | ~~플릿~~ 단독 사용 금지 |
| Arbiter Tribunal | `아비터 트리뷰널` | 유닛 `아비터`와 구분 |
| Shield Battery | `쉴드 배터리` | |

#### 저그
| 건물 | 표기 | 비고 |
|------|------|------|
| Hatchery | `해처리` | |
| Spawning Pool | `스포닝풀` | |
| Hydralisk Den | `히드라덴` | |
| Lair | `레어` | |
| Spire | `스파이어` | |
| Hive | `하이브` | |
| Queens Nest | `퀸즈네스트` | |
| Sunken Colony | `성큰` | |

### 금지어 (tools/calibration_criteria.js와 동기화)

> 이 목록은 `tools/calibration_criteria.js`의 `FORBIDDEN_WORDS` + 전용 regex를 정규 소스로 하며, 시나리오 작성·보정 시 본 표를 기준으로 검토한다. js 수정 시 본 표도 반드시 갱신.

| 금지 표현 | 대체 | 이유 |
|-----------|------|------|
| 경제 | 자원 / 일꾼 / 확장 | 해설 톤 아님 |
| 포토캐논 / 포톤캐논 / 포토 캐논 | 캐논 | 정식 표기 |
| 로보틱스 퍼실리티 | 로보틱스 | 해설 톤 약칭 |
| 로보틱스 서포트 베이 | 서포트 베이 | 해설 톤 약칭 |
| 시타델 / 시타델 오브 아둔 | 아둔 | 해설 톤 약칭 |
| SCV 라인 / 프로브 라인 / 드론 라인 / 일꾼 라인 | SCV를 / 프로브를 / 일꾼을 / 일꾼 초토화 | '라인' 오용 |
| 착공 | 건설합니다 / 올립니다 / 짓기 시작합니다 | 군사 용어, 해설 톤 아님 |
| 가스 수입 | 가스 수급 | 해설 톤 아님 |
| 쓰러지다 / 쓰러집 / 쓰러진 | 무너지다 / 밀리다 / 잡아냅니다 / 처리합니다 | SC 용어 아님 |
| 경쟁 | 싸움 (예: '뮤탈 타이밍 싸움') | 부자연스러움. 예외 없음 — '테크 경쟁'도 금지 → '테크를 올립니다' 등으로 변환 |
| 미러 (단독 사용) | 동일한 빌드 / 같은 빌드 | 실제 해설에서 '미러' 표현 안 씀 |
| 플릿 (단독, '플릿 비콘' 제외) | 플릿 비콘 | 유닛/건물 혼동 |
| 한글+한글 '+' 연결 | 쉼표·공백으로 분리 | 해설 톤 아님 |
| ~전의 핵심! | 구체 서술 | 정보 전달 톤 |
| 커맨드 센터 / 컨트롤 타워 / 미사일 터렛 / 미사일터렛 | 커맨드센터 / 컨트롤타워 / 터렛 | 붙여쓰기 |
| 스포닝 풀 / 히드라리스크 덴 / 히드라 덴 / 퀸즈 네스트 / 선큰 콜로니 / 선큰 | 스포닝풀 / 히드라덴 / 퀸즈네스트 / 성큰 | 정식 표기 |

### 분기 선택 메커니즘 (`conditionStat` + `baseProbability`)

능력치는 `ScriptBranch.conditionStat`으로 **분기 선택 확률**에만 관여한다. 이벤트의 army/resource 수치를 직접 보정하지 않는다.

**복합 능력치**: `conditionStat`에 `'+'`로 2개 이상 지정 가능 (예: `'attack+control'`, `'strategy+sense'`). 내부적으로 split 후 평균값 사용.

**decisive 분기의 가중 선택 (50:50 블렌딩)**: `decisive: true` 이벤트가 있는 분기는 `_armyBiasedBranchSelect`로 선택되며, **baseProbability 50% + (누적 병력 비율 + conditionStat 능력치 차이) 50%**로 가중치가 결정된다 (0.4~0.6 캡, 즉 최대 60/40). 시나리오 작성자가 baseProbability로 기본 승률을 제어하면서도 선수 능력치와 경기 흐름이 결전에 반영된다.

**선행 분기 조건 (`conditionPriorBranchIds`)**: 이전 Phase에서 특정 분기가 선택되었을 때만 후보에 포함. `conditionPriorBranchIds: ['ling_even']` → 이전에 `ling_even` 분기를 거친 경기에서만 이 분기가 후보. 복수 조건은 AND (모두 충족 필요). 미설정(null) → 조건 없음.

### 맵 조건 (`requiresMapTag`)

특정 맵에서만 발생하는 이벤트: `'rushShort'`(근거리), `'rushLong'`(원거리), `'airHigh'`(공중 개방), `'terrainHigh'`(복잡 지형)

## Home/Away 규칙

- **홈/어웨이 보정은 절대 없음** (위치를 정하는 곳에만 쓰임)
- 승률 계산, 이벤트 선택, 빌드 상성 등 모든 시뮬레이션 로직에서 홈/어웨이 위치가 결과에 영향을 주면 안 됨
- 빌드 상성 함수는 반드시 반대칭: `f(A,B) = -f(B,A)`

### 역방향 매칭 (isReversed)

- **homeBuildIds와 awayBuildIds는 겹치면 안 됨** → 겹치면 역방향 매칭이 깨져 승률 편향 발생
- 매칭 흐름: Phase 1(정방향) 실패 → Phase 2(역방향)에서 빌드 스왑 매칭 → `isReversed=true` → `{home}`/`{away}` 텍스트, army/resource, LogOwner 전부 자동 스왑
- 시나리오 작성 후 반드시 **홈/어웨이 반전 테스트**로 승률 차이 검증 (동일 능력치 기준 ±5%p 이내)

## 시나리오 보정 루프 절차

> **프롬프트**: "시나리오 보정 루프 절차 따라서 {종족전} 모든 검증 기준을 통과할 때까지 반복해, 5번 반복이 됐으면 멈추고 결과파일 만들어줘"

### 개별 시나리오 사전 루프 (`calibration_status.md` 'Y' 처리 전)

> **시나리오별 Y/O/X 상태 관리**: `lib/core/constants/scenarios/docs/calibration_status.md`의 `## {matchup} (N개)` 섹션.
> 이 문서가 전 종족전 보정 진행 상황의 단일 진실 공급원 (SSOT)이다.

전체 보정 루프(아래) 5단계에서 재검출되어 2·3단계로 되돌아가는 **순환을 방지**하기 위해,
각 시나리오를 'Y'로 표기하기 전 아래 값을 반드시 선확인한다.

```
A. 해당 시나리오 1000경기 실행
   - flutter test --name "{Matchup}.*{scenario_label}" test/all_scenarios_test.dart
   - 출력: test/output/{matchup}/ 통계 md

B. 사전 검증 (이 값들이 5단계 C계층 FAIL을 유발)
   - C13 승률: 미러 45~55%, 크로스 30~70%
   - C14 홈/어웨이 반전 차이 ±5%p 이내
   - C15 500경기 고유 로그 50+ (다양성)
   - 로그에 '미러/경쟁/쓰러지다/착공/SCV 라인' 등 금지어 부재 (CLAUDE.md '금지어' 표)
   - 승자 최종 병력 ≥ 패자 (B17), decisive 이후 패자 행동 없음 (B19)

C. 판단
   - 위 값 만족 + 사용자 육안 검수 OK → `calibration_status.md` 해당 시나리오 'Y' 처리
   - 어느 하나라도 실패 → 시나리오 수정 후 A부터 재실행
```

> 이 사전 루프를 건너뛰고 'Y' 처리하면, 5단계 전체 루프에서 C13/C14/C15가 FAIL로 잡혀 다시 개별 보정으로 되돌아와야 한다.

### 절차 (종족전 전체)

```
1. 시뮬레이션 실행
   - 해당 종족전 보정 테스트 실행 (flutter test --name "{Matchup}" test/calibration_test.dart)
   - 출력: test/output/{matchup}/log.json

2. 검증 기준 체크
   - node tools/calibration_criteria.js test/output/{matchup}/log.json
   - 출력: test/output/{matchup}/log_result.md (PASS/FAIL + 위반 목록)

3. 위반 항목 자동 수정
   - 에러(error) 항목: 반드시 수정
   - 경고(warning) 항목: 가능하면 수정
   - A계층(텍스트): 동일 유형은 일괄 치환 허용 (예: 금지어 전체 교체)
   - B/C계층(구조/밸런스): 한 라운드에 최대 2항목만 수정
   - 이전 라운드에서 PASS였던 항목이 FAIL로 바뀌면 즉시 롤백하고 보고
   - 수정 대상 파일: lib/core/constants/scenarios/{matchup}/ 내 파일들
   - build_orders.dart는 공유 파일이므로 동시 수정 금지
   - 수정 후 flutter analyze로 린트 검사

4. 반복 (최대 5회)
   - PASS면 즉시 종료
   - 5회 반복 후에도 FAIL이면 남은 위반 목록과 함께 종료

5. 결과 파일 생성
   - test/output/{matchup}/result.md에 최종 리포트 저장
   - 각 반복의 에러/경고 수 변화 추이 포함
   - C13/C14/C15 FAIL이 남아 있으면 **해당 시나리오를 `calibration_status.md`에서 'Y'→'X'로 되돌리고** 개별 사전 루프로 회귀 표기
```

### 검증 기준 요약 (tools/calibration_criteria.js)

| 레벨 | 코드 | 기준 | 심각도   |
|------|------|------|-------|
| A (줄) | A1 | 금지어 ('경제', '포토캐논', '쓰러지다' 등) | error |
| A (줄) | A2 | 건물명 규칙 (CLAUDE.md 표기 테이블) | error |
| A (줄) | A3 | 플레이스홀더 미치환 ({home}, {away}) | error |
| A (줄) | A5 | Owner 불일치 (home 이벤트에 away 주체) | error |
| A (줄) | A6 | Army 범위 (0~200) | error |
| A (줄) | A7 | Resource 범위 (0~10000) | error |
| A (줄) | A8 | 이벤트 필수 필드 (homeArmy/awayArmy/homeResources/awayResources, 0이라도 필수) | error |
| B (경기) | ~~B10~~ | ~~시스템 해설 비율~~ (제거됨 - 짧은 경기에서 무의미) | -  |
| B (경기) | B11 | 테크트리 순서 (유닛 → 선행 건물 존재). 방어 맥락 예외: 상대 유닛 방어 텍스트는 스킵 | error |
| B (경기) | B12 | 동일 텍스트 3줄 연속 반복 | error |
| B (경기) | B17 | 승자 최종 병력 ≥ 패자 (decisive 예외) | error |
| B (경기) | B19 | 게임 종료 후 패자 행동 금지 | error |
| B (경기) | B20 | 유닛 타이밍 (고테크 유닛 조기 등장 금지) | error |
| B (경기) | B21 | 종족 간 유닛 혼입 방지 (다른 종족 유닛 주체 금지) | error |
| B (경기) | ~~B22~~ | ~~한 줄에 건물 3개 이상 건설 금지~~ (비활성화 - 시나리오 보정 시 불가피) | -  |
| B (경기) | B23 | 저그 유닛 테크건물 생산 서술 금지 (라바/해처리에서 생산) | error |
| B (경기) | B24 | 선행건물 완성 전 후속건물 동시 착공 금지 | error |
| C (통계) | C13 | 승률 30~70% (미러 45~55%) | error |
| C (통계) | C14 | 홈/어웨이 반전 ±5%p | error |
| C (통계) | C15 | 텍스트 다양성 (500경기 50+고유) | warn  |
| C (통계) | C16 | 분기 활성화율 5% 이상 (시나리오별 그룹 내) | warn  |
| C (통계) | ~~C17~~ | ~~decisive 종료 비율 30~70%~~ (비활성화 - 수동 조절) | -  |
| D (파일) | D1 | 개별 시나리오에 recoveryResourcePerLine 개별 설정 감지 (통합 관리 위반) | error |

### 팀 구성 (Agent Teams)

종족전별 병렬 보정 작업 시 팀을 구성하여 진행:

```
팀원 6명 (종족전별 1명):
- TvT 담당: scenarios/tvt/ 보정
- TvZ 담당: scenarios/tvz/ 보정
- PvT 담당: scenarios/pvt/ 보정
- PvP 담당: scenarios/pvp/ 보정
- ZvP 담당: scenarios/zvp/ 보정
- ZvZ 담당: scenarios/zvz/ 보정

각 팀원의 작업:
1. 자기 종족전 테스트 실행 → JSON 로그 내보내기
2. calibration_criteria.js로 검증
3. 위반 항목 수정 (자기 종족전 시나리오 파일만 수정)
4. 최대 5회 반복
5. {matchup}Result.md 생성

주의: build_orders.dart는 공유 파일이므로 동시 수정 금지
→ 각 팀원이 자기 종족전 시나리오 파일만 수정
→ build_orders.dart 수정이 필요하면 리더에게 보고
```

## Game Design Reference

게임 디자인 상세 문서는 `GAME_DESIGN.md` 참조:
- 선수 시스템 (능력치, 등급, 레벨, 컨디션)
- 성장/하락 시스템
- 경기 시뮬레이션 규칙
- 시즌 시스템
- 아이템/장비 시스템
- 이적 시장

## 종족전별 경기 흐름 레퍼런스

> 시나리오 작성 시 참고한 실제 프로게이머 경기 분석. 새 시나리오 추가/보정 시 참조.

### TvT
- **BBS vs 노배럭더블**: BBS 쪽이 센터배럭 마린3 + 본진마린2 + SCV를 끌고 앞마당 벙커링 공격. 수비 측이 SCV 정찰 성공 시 마린 끊기 → 후반 유리. 정찰 실패 시 벙커링부터 공격 유리.
- **배럭더블 vs 팩더블**: 둘 다 밸런스형. 팩더블이 벌처 먼저 나오는 이점, 배럭더블은 병력 증가가 빠름. 벌처싸움이 TvT 메인이벤트. 크게 밀리면 패배 직결, 비등하면 시즈탱크 → 라인 유지 → 드랍십 운영. 후반은 시즈탱크+골리앗+드랍십으로 확장기지/라인 타격하며 집중력 싸움. 스타포트를 섞어 레이스 운용도 가능 → 상대는 아머리+골리앗 대응 필요.

### ZvZ
- **9풀 vs 9오버풀**: 둘 다 공격적, 9오버풀 약 우위(드론 +1). 저글링 발업 타이밍 차이가 관건. 본진 드론까지 타격하면 승리 직결. 스파이어 전환 시점이 위험 (병력 빈 시간). 뮤탈전은 스커지+스포어로 수비하며 드론 견제 승부.
- **12앞마당 vs 9풀**: ZvZ에서 12앞은 수비형. 발업 저글링이 드론 초토화/앞마당 파괴 시 9풀 승리. 노발업 저글링+드론+성큰으로 막으면 12앞 승률 수직상승. 이후 12앞이 뮤탈+스커지에서 차이나며 대부분 승리.

### PvP
- **원게이트드라군넥서스 vs 노게이트넥서스**: 밸런스 vs 수비형. 초반 질럿→드라군으로 괴롭히기 vs 프로브+질럿 협공 수비. 수비 성공 시 게이트 확장 속도 차이로 노게이트 유리. 중후반은 드라군+셔틀리버 컨트롤 싸움 + 하이템플러 스톰.
- **원게이트로보 vs 투게이트드라군**: 로보 측은 셔틀+리버 합류 전까지 버티기, 투게이트 측은 드라군 물량으로 빠른 교전 유도. 셔틀 폭사가 가장 중요한 이벤트. 교전 결착 안 나면 앞마당 확장 후 견제+컨트롤 승부.

### TvZ
- **배럭더블 vs 12앞마당**: 가장 흔한 TvZ. 이후 T는 발키리+바이오닉/5배럭/메카닉 등, Z는 2~3해처리 뮤탈/럴커 등 무궁무진. 초반 소수 마린vs저글링 교환 중요. 중반은 뮤탈 견제vs터렛+엔베 수비. 테란 한방병력(마린메딕 3부대+시즈탱크3+사이언스베슬) vs 저그 순환병력(저글링+뮤탈+럴커). T:Z의 분수령은 저그 3~4가스 유지 여부.
- **BBS vs 12앞마당**: 3연벙 벙커링 → 앞마당 파괴 시도. 성큰 vs 벙커 완성 경쟁. 정찰 성공 시 드론으로 센터배럭 끊기 가능.

### ZvP
- **12앞마당 vs 포지더블**: 국룰. 저그 히드라 압박 vs 프로토스 질럿+캐논 라인. 히드라에 앞마당 밀리면 저그 승리. 커세어로 오버로드 사냥 → 하이템플러+스톰 완성 시 방어 성공. 이후 질럿+드라군+하이템플러 한방병력 vs 디파일러+울트라+저글링 순환. 프로토스 한방병력 괴멸 = 저그 승리, 저그 확장기지 파괴 = 프로토스 승리.
- **9풀 vs 포지더블**: 캐논 완성 전 6저글링 도착. 프로브로 방어하며 캐논+게이트 완성까지 버티기. 본진 침투 시 프로브 피해 심각.

### PvT
- **사업넥 vs 팩더블**: 국룰. T는 마인/시즈탱크/벌처드랍/5팩 타이밍 등 분기. P는 로보틱스 옵저버/3게이트/패스트아비터 등 분기.
