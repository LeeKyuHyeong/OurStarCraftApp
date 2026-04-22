# 전 종족전 시나리오 보정 통합 현황

> 보정 루프: `calibration_criteria.js` 기반 전체 검증
> 사전 루프: 개별 시나리오 1000경기 C13/C14/C15 검증 → Y 표기
> Y = 사전 루프 통과 | O = 미러(보정 대상 아님) | X = 미보정 | ㅁ = 작성 중

---

## 전체 요약

| 종족전 | 시나리오 | 보정 루프 | Y | O | X/ㅁ | 진행률 |
|--------|:-------:|:---------:|:-:|:-:|:---:|:-----:|
| ZvZ | 21 | 재검증 | 0 | 6 | 15 | 0% |
| TvT | 36 | 재검증 | 0 | 8 | 28 | 0% |
| TvZ | 56 | 재검증 | 0 | 0 | 56 | 0% |
| PvT | 54 | FAIL | 0 | 0 | 54 | 0% |
| PvP | 36 | 재검증 | 0 | 0 | 36 | 0% |
| ZvP | 63 | 재검증 | 0 | 0 | 63 | 0% |
| **합계** | **266** | | **0** | **14** | **252** | **0%** |

---

## 설정 레퍼런스

### ScenarioScript (시나리오 전체)

| 필드 | 타입 | 기본값 | 설명 |
|------|------|--------|------|
| `id` | String | *필수* | 시나리오 고유 ID (예: `'tvt_bbs_vs_1bar_double'`) |
| `matchup` | String | *필수* | 종족전 (예: `'TvT'`, `'ZvP'`) |
| `homeBuildIds` | List\<String\> | *필수* | 홈 빌드 ID 목록. `awayBuildIds`와 겹치면 안 됨 |
| `awayBuildIds` | List\<String\> | *필수* | 어웨이 빌드 ID 목록. `homeBuildIds`와 겹치면 안 됨 |
| `description` | String | *필수* | 시나리오 설명 |
| `phases` | List\<ScriptPhase\> | *필수* | 경기 흐름 단계 (오프닝 → 중반 → 결전) |
| `mapRequirement` | MapRequirement? | null | 맵 조건 필터 (특정 맵 태그에서만 매칭) |
| `decisiveWeight` | double | 1.0 | decisive 분기 선택 가중치. >1.0: decisive 종료 증가, <1.0: 감소 |

### ScriptPhase (경기 단계)

| 필드 | 타입 | 기본값 | 설명 |
|------|------|--------|------|
| `name` | String | *필수* | 페이즈 이름 (디버그/리포트용) |
| `startLine` | int? | null | 페이즈 시작 라인. Phase 0만 필수 (시나리오 진입 게이트). Phase 1+는 이전 페이즈 종료 후 즉시 시작 |
| `linearEvents` | List\<ScriptEvent\>? | null | 순차 이벤트 (오프닝, 전개). `branches`와 상호 배타 |
| `branches` | List\<ScriptBranch\>? | null | 분기 이벤트 (교전, 결전). `linearEvents`와 상호 배타 |
| `recoveryArmyPerLine` | int | 0 | 매 라인마다 양측 병력 회복량 |
| `recoveryResourcePerLine` | int | 50 | 매 라인마다 양측 자원 회복량 (확장 보너스 +100/확장) |

### ScriptBranch (분기)

| 필드 | 타입 | 기본값 | 설명 |
|------|------|--------|------|
| `id` | String | *필수* | 분기 고유 ID. 통계 리포트 및 `conditionPriorBranchIds` 체인에서 참조 |
| `description` | String? | null | 분기 한국어 설명 (통계 리포트용) |
| `conditionStat` | String? | null | 능력치 기반 분기 조건. 해당 능력치 우세 측 분기 선택 확률 증가. 복합 능력치: `'attack+strategy'` |
| `homeStatMustBeHigher` | bool | true | `true`: 홈 능력치 높을 때 우세 분기 / `false`: 어웨이 능력치 높을 때 우세 분기 |
| `baseProbability` | double | 1.0 | 기본 선택 가중치. 다른 분기와의 상대 비율로 작용 |
| `events` | List\<ScriptEvent\> | *필수* | 분기 선택 시 실행되는 이벤트 목록 |
| `conditionHomeBuildIds` | List\<String\>? | null | 홈 빌드 ID 필터. 설정 시 해당 빌드와 매칭되어야 후보에 포함 |
| `conditionAwayBuildIds` | List\<String\>? | null | 어웨이 빌드 ID 필터. 위와 동일 |
| `conditionPriorBranchIds` | List\<String\>? | null | 분기 체인 조건. 이전 Phase에서 선택된 분기 ID가 모두 포함되어야 후보에 포함 |

### ScriptEvent (이벤트)

| 필드 | 타입 | 기본값 | 설명 |
|------|------|--------|------|
| `text` | String | *필수* | 로그에 표시되는 해설 텍스트. `{home}`, `{away}` 플레이스홀더 사용 가능 (역방향 매칭 시 자동 스왑) |
| `owner` | LogOwner | *필수* | 이벤트 주체. `home` / `away` / `system` |
| `homeArmy` | int | 0 | 홈 병력 변동 (양수=증가, 음수=감소). 범위: 0~200 |
| `awayArmy` | int | 0 | 어웨이 병력 변동. 범위: 0~200 |
| `homeResource` | int | 0 | 홈 자원 변동. 범위: 0~10000 |
| `awayResource` | int | 0 | 어웨이 자원 변동. 범위: 0~10000 |
| `decisive` | bool | false | true면 즉시 승패 결정 (해당 이벤트 owner 측 승리) |
| `skipChance` | double | 0.0 | 이벤트 스킵 확률 (0.0~1.0). 다양성 확보용 |
| `altText` | String? | null | 50% 확률로 `text` 대신 표시되는 대체 텍스트 |
| `requiresMapTag` | String? | null | 맵 태그 조건. `'rushShort'` / `'rushLong'` / `'airHigh'` / `'terrainHigh'` |
| `homeExpansion` | bool | false | true면 홈 확장 이벤트 → 홈 recovery +75/확장 |
| `awayExpansion` | bool | false | true면 어웨이 확장 이벤트 → 어웨이 recovery +75/확장 |

---

## 능력치와 경기 결과의 관계

능력치(stats)는 **분기 선택 확률**에만 관여한다. 이벤트의 army/resource 수치를 직접 보정하지 않는다.

- `ScriptBranch.conditionStat`: 해당 능력치 우세 측의 분기가 선택될 확률 증가
- 복합 능력치 지원: `'attack+strategy'` 처럼 `+`로 연결하면 평균값으로 판정

| 능력치 | 설명 | 주요 분기 맥락 |
|--------|------|---------------|
| `'attack'` | 공격력 | 정면 교전 승패 분기 |
| `'harass'` | 견제력 | 드랍/견제 성공 여부 분기 |
| `'control'` | 컨트롤 | 마이크로 교전 결과 분기 |
| `'defense'` | 수비력 | 수비 성공/실패 분기 |
| `'strategy'` | 전략 | 테크 전환/타이밍 판단 분기 |
| `'macro'` | 매크로 | 자원 관리/확장 운영 분기 |
| `'sense'` | 감각 | 직감 판단/위기 대응 분기 |
| `'scout'` | 정찰 | 정찰 성공/빌드 리딩 분기 |

---

## 분기 선택 로직 (3단계)

```
1단계: 빌드 ID 필터링
  - conditionHomeBuildIds / conditionAwayBuildIds가 있는 분기 → 빌드 매칭 검사
  - 매칭된 분기 우선, 없으면 조건 없는 분기 사용

1-2단계: 분기 체인 필터링
  - conditionPriorBranchIds가 있는 분기 → 이전 Phase 선택 ID와 대조
  - 체인 충족 분기 + 조건 없는 분기로 후보 구성

2단계: conditionStat 처리
  - 능력치 우세/열세 관계없이 모든 분기 eligible 유지
  - 능력치 차이는 이후 가중 선택에서 반영

3단계: 가중 선택 (분기 종류에 따라 분리)
  ├─ decisive 분기 있음 → _armyBiasedBranchSelect (60/40 캡)
  │   - 병력 비율 85%+ 압도 → 해당 측 확정 선택
  │   - 병력 댐핑(0.2) + conditionStat 가중(±0.1) → 0.4~0.6 캡
  │   - 최대 60/40 비율로 제한 (한쪽 쏠림 방지)
  └─ decisive 없음 → _armyInfluencedBranchSelect (부드러운 영향)
      - 분기 이벤트의 순 병력 방향(홈 유리/어웨이 유리) 계산
      - 50% baseProbability + 50% 병력 선호도 블렌드
```

### conditionStat 사용 예시

```dart
// 공격력 높은 쪽이 교전 승리 분기로 갈 확률 증가
ScriptBranch(
  id: 'engage_win',
  conditionStat: 'attack',
  homeStatMustBeHigher: true,   // 홈 attack 높으면 이 분기 우세
  baseProbability: 1.0,
  events: [/* 홈 교전 승리 이벤트 */],
),
ScriptBranch(
  id: 'engage_lose',
  conditionStat: 'attack',
  homeStatMustBeHigher: false,  // 어웨이 attack 높으면 이 분기 우세
  baseProbability: 1.0,
  events: [/* 어웨이 교전 승리 이벤트 */],
),
```

### conditionPriorBranchIds 사용 예시

```dart
// Phase 2에서 'early_aggression' 분기가 선택된 경우에만 후보에 포함
ScriptBranch(
  id: 'followup_attack',
  conditionPriorBranchIds: ['early_aggression'],
  baseProbability: 1.0,
  events: [/* 후속 공격 이벤트 */],
),
```

---

## ZvZ (21개) — 재검증 필요

> 자원 관련 재검증 필요 (2026-04-21 초기화)

### 빌드 목록 (6개)

| # | 빌드 ID | 이름 | 스타일 |
|---|---------|------|--------|
| 1 | zvz_4pool | 4풀 | cheese |
| 2 | zvz_9pool_speed | 9풀 속업 | aggressive |
| 3 | zvz_9pool_lair | 9풀 레어 | balanced |
| 4 | zvz_9overpool | 9오버풀 | balanced |
| 5 | zvz_12pool | 12풀 | defensive |
| 6 | zvz_12hatch | 12앞마당 | defensive |

### 미러 (6개)

| # | 파일명 | Home | Away | 보정 |
|---|--------|------|------|:----:|
| 1 | 4pool_mirror | zvz_4pool | zvz_4pool | Y |
| 2 | 9pool_speed_mirror | zvz_9pool_speed | zvz_9pool_speed | Y |
| 3 | 9pool_lair_mirror | zvz_9pool_lair | zvz_9pool_lair | O |
| 4 | 9overpool_mirror | zvz_9overpool | zvz_9overpool | O |
| 5 | 12pool_mirror | zvz_12pool | zvz_12pool | O |
| 6 | 12hatch_mirror | zvz_12hatch | zvz_12hatch | O |

### 크로스 (15개)

| # | 파일명 | Home | Away | 보정 |
|---|--------|------|------|:----:|
| 7 | 4pool_vs_9pool_speed | zvz_4pool | zvz_9pool_speed | X |
| 8 | 4pool_vs_9pool_lair | zvz_4pool | zvz_9pool_lair | X |
| 9 | 4pool_vs_9overpool | zvz_4pool | zvz_9overpool | X |
| 10 | 4pool_vs_12pool | zvz_4pool | zvz_12pool | X |
| 11 | 4pool_vs_12hatch | zvz_4pool | zvz_12hatch | X |
| 12 | 9pool_speed_vs_9pool_lair | zvz_9pool_speed | zvz_9pool_lair | X |
| 13 | 9pool_speed_vs_9overpool | zvz_9pool_speed | zvz_9overpool | X |
| 14 | 9pool_speed_vs_12pool | zvz_9pool_speed | zvz_12pool | X |
| 15 | 9pool_speed_vs_12hatch | zvz_9pool_speed | zvz_12hatch | X |
| 16 | 9pool_lair_vs_9overpool | zvz_9pool_lair | zvz_9overpool | X |
| 17 | 9pool_lair_vs_12pool | zvz_9pool_lair | zvz_12pool | X |
| 18 | 9pool_lair_vs_12hatch | zvz_9pool_lair | zvz_12hatch | X |
| 19 | 9overpool_vs_12pool | zvz_9overpool | zvz_12pool | X |
| 20 | 9overpool_vs_12hatch | zvz_9overpool | zvz_12hatch | X |
| 21 | 12hatch_vs_12pool | zvz_12hatch | zvz_12pool | X |

---

## TvT (36개) — 재검증 필요

> 자원 관련 재검증 필요 (2026-04-21 초기화)

### 빌드 목록 (8개)

| # | 빌드 ID | 이름 | 스타일 |
|---|---------|------|--------|
| 1 | tvt_bbs | BBS | cheese |
| 2 | tvt_1fac_1star | 원팩원스타 | aggressive |
| 3 | tvt_2fac_push | 투팩타이밍 | aggressive |
| 4 | tvt_2star | 투스타 레이스 | aggressive |
| 5 | tvt_1bar_double | 원배럭더블 | balanced |
| 6 | tvt_1fac_double | 원팩더블 | balanced |
| 7 | tvt_nobar_double | 노배럭더블 | defensive |
| 8 | tvt_fd_rush | FD 러쉬 | aggressive |

### 미러 (8개)

| # | 파일명 | Home | Away | 보정 |
|---|--------|------|------|:----:|
| 1 | bbs_mirror | tvt_bbs | tvt_bbs | O |
| 2 | 1fac_1star_mirror | tvt_1fac_1star | tvt_1fac_1star | O |
| 3 | 2fac_push_mirror | tvt_2fac_push | tvt_2fac_push | O |
| 4 | 2star_mirror | tvt_2star | tvt_2star | O |
| 5 | 1bar_double_mirror | tvt_1bar_double | tvt_1bar_double | O |
| 6 | 1fac_double_mirror | tvt_1fac_double | tvt_1fac_double | O |
| 7 | nobar_double_mirror | tvt_nobar_double | tvt_nobar_double | O |
| 8 | fd_rush_mirror | tvt_fd_rush | tvt_fd_rush | O |

### BBS 크로스 (6개)

| # | 파일명 | Home | Away | 보정 |
|---|--------|------|------|:----:|
| 9 | bbs_vs_1bar_double | tvt_bbs | tvt_1bar_double | X |
| 10 | bbs_vs_1fac_double | tvt_bbs | tvt_1fac_double | X |
| 11 | bbs_vs_1fac_1star | tvt_bbs | tvt_1fac_1star | X |
| 12 | bbs_vs_2fac_push | tvt_bbs | tvt_2fac_push | X |
| 13 | bbs_vs_2star | tvt_bbs | tvt_2star | X |
| 14 | bbs_vs_nobar_double | tvt_bbs | tvt_nobar_double | X |

### 원팩원스타 크로스 (5개)

| # | 파일명 | Home | Away | 보정 |
|---|--------|------|------|:----:|
| 15 | 1fac_1star_vs_2fac_push | tvt_1fac_1star | tvt_2fac_push | X |
| 16 | 1fac_1star_vs_2star | tvt_1fac_1star | tvt_2star | X |
| 17 | 1fac_1star_vs_1bar_double | tvt_1fac_1star | tvt_1bar_double | X |
| 18 | 1fac_1star_vs_1fac_double | tvt_1fac_1star | tvt_1fac_double | X |
| 19 | 1fac_1star_vs_nobar_double | tvt_1fac_1star | tvt_nobar_double | X |

### 투팩 크로스 (4개)

| # | 파일명 | Home | Away | 보정 |
|---|--------|------|------|:----:|
| 20 | 1bar_double_vs_2fac_push | tvt_1bar_double | tvt_2fac_push | X |
| 21 | 2fac_push_vs_1fac_double | tvt_2fac_push | tvt_1fac_double | X |
| 22 | 2star_vs_2fac_push | tvt_2star | tvt_2fac_push | X |
| 23 | 2fac_push_vs_nobar_double | tvt_2fac_push | tvt_nobar_double | X |

### 투스타 크로스 (3개)

| # | 파일명 | Home | Away | 보정 |
|---|--------|------|------|:----:|
| 24 | 2star_vs_1bar_double | tvt_2star | tvt_1bar_double | X |
| 25 | 2star_vs_1fac_double | tvt_2star | tvt_1fac_double | X |
| 26 | 2star_vs_nobar_double | tvt_2star | tvt_nobar_double | X |

### 확장형 크로스 (3개)

| # | 파일명 | Home | Away | 보정 |
|---|--------|------|------|:----:|
| 27 | 1bar_double_vs_1fac_double | tvt_1bar_double | tvt_1fac_double | X |
| 28 | nobar_double_vs_1bar_double | tvt_nobar_double | tvt_1bar_double | X |
| 29 | 1fac_double_vs_nobar_double | tvt_1fac_double | tvt_nobar_double | X |

### FD러쉬 크로스 (7개)

| # | 파일명 | Home | Away | 보정 |
|---|--------|------|------|:----:|
| 30 | fd_rush_vs_bbs | tvt_fd_rush | tvt_bbs | X |
| 31 | fd_rush_vs_1fac_1star | tvt_fd_rush | tvt_1fac_1star | X |
| 32 | fd_rush_vs_2fac_push | tvt_fd_rush | tvt_2fac_push | X |
| 33 | fd_rush_vs_2star | tvt_fd_rush | tvt_2star | X |
| 34 | fd_rush_vs_1bar_double | tvt_fd_rush | tvt_1bar_double | X |
| 35 | fd_rush_vs_1fac_double | tvt_fd_rush | tvt_1fac_double | X |
| 36 | fd_rush_vs_nobar_double | tvt_fd_rush | tvt_nobar_double | X |

---

## TvZ (56개) — 재검증 필요

> 자원 관련 재검증 필요 (2026-04-21 초기화)

---

## PvT (54개) — FAIL (루프)

> 보정 루프 FAIL (에러 1, 경고 22) | 개별 시나리오 test_pvt.md 참조

---

## PvP (36개) — 재검증 필요

> 자원 관련 재검증 필요 (2026-04-21 초기화)

---

## ZvP (63개) — 재검증 필요

> 자원 관련 재검증 필요 (2026-04-21 초기화)

---

## build_orders.dart 이벤트 풀 제거 계획

현재 시나리오 스크립트에 빈 라인이 있으면 `build_orders.dart`의 `getMidLateEvent()`가 호출되어 중후반 이벤트를 채운다.
전 종족전 시나리오 보정이 완료되어 **모든 라인이 시나리오로 커버**되면, `build_orders.dart` 내부의 이벤트 풀(mid-late, clash 등)은 호출되지 않는 죽은 코드가 된다.

**전체 보정 완료 후 제거 대상:**
- `BuildOrderData`의 mid-late 이벤트 풀 (tvtMidLateEvents, tvzMidLateEvents 등 9개)
- clash 이벤트 풀 (aggressiveVsAggressive, comebackEvents, microEvents 등)
- `getMidLateEvent()`, `getClashEvents()` 메서드
- `match_simulation_service.dart`의 빈 라인 채우기 로직 (`homeStep == null && awayStep == null` 분기)

**제거 조건:** 전 종족전 266개 시나리오 진행률 100% + 보정 루프 전체 PASS
