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
flutter test test/pvp_all_scenarios_100games_test.dart

# 이름으로 특정 테스트만 실행
flutter test -n "PvP S1:" test/pvp_all_scenarios_100games_test.dart
```

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

### 시나리오 스크립트 파일 구조 (`core/constants/`)

```
scenario_scripts.dart          # 프레임워크 클래스 정의 (ScenarioScript, ScriptPhase, ScriptBranch, ScriptEvent 등)
scenario_tvt.dart (16개)       # TvT 시나리오
scenario_tvz.dart (11개)       # TvZ 시나리오
scenario_pvt.dart (11개)       # PvT 시나리오
scenario_pvp.dart (10개)       # PvP 시나리오
scenario_zvp.dart (11개)       # ZvP 시나리오
scenario_zvz.dart  (9개)       # ZvZ 시나리오
build_orders.dart              # BuildOrder 정의 + BuildOrderData (빌드 저장소)
```

## Key Components

### State Management (`game_provider.dart`)
- `gameStateProvider`: 전체 게임 상태 관리 (StateNotifierProvider)
- `GameState`: SaveData를 감싸는 상태 객체 (playerTeam, currentSeason, inventory 등)
- `GameStateNotifier`: 게임 로직 메서드 (startNewGame, loadGame, save, updatePlayer 등)
- 파생 Provider: `playerTeamPlayersProvider`, `allTeamsProvider`, `currentSeasonProvider`, `inventoryProvider` 등이 `gameStateProvider`에 의존

### Match Simulation (`match_simulation_service.dart`)
- **Stream 기반**: `simulateMatchWithLog()`가 `Stream<SimulationState>`를 반환 → UI가 실시간 소비
- `SimulationState`: 병력/자원/로그 상태
- `BattleLogEntry`: 로그 텍스트 + 소유자(home/away/system)
- `getIntervalMs()` 콜백으로 시뮬레이션 중 속도 변경 가능
- 테스트 시 `forcedHomeBuildId`, `forcedAwayBuildId` 파라미터로 특정 빌드 조합 강제 지정

### Models (`domain/models/`)
- `Player`: 선수 (능력치 8개: sense, control, attack, harass, strategy, macro, defense, scout)
- `PlayerStats`: 능력치 클래스 (컨디션 적용, 성장/하락 로직 포함)
- `Team`: 팀 (players, money, actionPoints)
- `Match`: 경기 정보 (7전 4선승제)
- `Season`: 시즌 (프로리그 + 개인리그)
- Hive 어노테이션 사용 (`@HiveType`, `@HiveField`) - 모델 변경 시 `build_runner` 실행 필요

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
- **선수 위치**: `home` / `away` (player1/player2 사용 안 함)

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

종족전별 시나리오 검증 테스트 (test/ 폴더):
- `tvt_scenarios_100games_test.dart`, `tvz_scenarios_100games_test.dart`, `pvt_all_scenarios_100games_test.dart`, `pvp_all_scenarios_100games_test.dart`, `zvp_scenario_100games_test.dart`, `zvz_scenario_100games_test.dart`
- 테스트 출력: `test/output/` 디렉토리에 마크다운 통계 리포트 생성
- 테스트 패턴: 동일 능력치(~700) + 100% 컨디션 선수로 균형 시나리오 검증, `forcedHomeBuildId`/`forcedAwayBuildId`로 빌드 고정

### 보정 기준
- 승률: 동일 능력치 기준 30~70% (미러는 45~55%)
- 홈/어웨이: 반전 시 승률 차이 ±5%p 이내
- 다양성: 500경기 중 최소 50+ 고유 로그

## 스타크래프트 경기 다움 (핵심 원칙)

경기 시뮬레이션의 최우선 목표는 **실제 스타크래프트 중계를 보는 듯한 몰입감**이다.
모든 경기는 시나리오 스크립트(`ScenarioScript`)로 진행되며, 빌드 조합마다 고유한 내러티브가 펼쳐진다.

### 시나리오 스크립트 구조

```
ScenarioScript
├── phases: [ScriptPhase, ...]     # 경기 흐름 단계 (오프닝 → 중반 → 결전)
│   ├── linearEvents: [ScriptEvent]  # 순차 이벤트 (오프닝, 전개)
│   └── branches: [ScriptBranch]     # 분기 이벤트 (교전, 결전 - 능력치/확률 기반 선택)
├── homeBuildIds / awayBuildIds      # 매칭 대상 빌드 (겹침 금지)
└── mapRequirement                   # 맵 조건 필터 (선택)
```

- **Phase**: `startLine` 기준으로 활성화, linearEvents(순차) 또는 branches(분기) 중 하나
- **Branch**: `conditionStat` + `baseProbability`로 선택. 선수 능력치에 따라 다른 전개
- **Event**: 텍스트 + 병력/자원 변동 + `favorsStat`(능력치 보정) + `decisive`(즉시 승패)

### 내러티브 품질 규칙

1. **빌드 자연 노출**: 빌드명을 직접 언급하지 않고, 건물/유닛 생산 묘사를 통해 자연스럽게 드러남
2. **방송 어미 톤**: `_transformEnding()`이 35% 확률로 어미 변환 ("~합니다" → "~하구요" / "~하죠" / "~하네요")
3. **텍스트 다양성**: `altText`(50% 대체), `skipChance`(확률 스킵)으로 매번 다른 경기 연출
4. **해설 코멘터리**: `LogOwner.system` 이벤트로 상황 해설 삽입
5. **용어 규칙**: '경제'라는 단어 사용 금지 → '자원', '일꾼', '확장' 등 구체적 표현

### 능력치 반영 (`favorsStat`)

이벤트에 `favorsStat: 'attack'` 등을 지정하면 해당 능력치가 높은 선수에게 유리하게 병력/자원 변동 적용:
- 능력치 차이 0 → 보정 없음 / 차이 800 → 최대 ±30% 보정

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

## Game Design Reference

게임 디자인 상세 문서는 `GAME_DESIGN.md` 참조:
- 선수 시스템 (능력치, 등급, 레벨, 컨디션)
- 성장/하락 시스템
- 경기 시뮬레이션 규칙
- 시즌 시스템
- 아이템/장비 시스템
- 이적 시장
