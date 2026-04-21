# 경기 시뮬레이션 프로세스 (MATCH_PROC.md)

## 전체 흐름도

```
simulateMatchWithLog()
  │
  ├─ 승률 계산 + 능력치 추출
  │
  ├─ 홈 빌드 선택 (forced or 능력치+맵 기반 점수)
  ├─ 어웨이 빌드 선택 (같은 로직)
  │
  ├─ 빌드 null? ──YES──→ _fallbackSimulation() → END
  │      │NO
  │
  ├─ BuildType 매핑
  │
  ├─ 시나리오 매칭 (정방향 → 역방향)
  │      │
  │      ├─ 매칭 성공 → Phase/Event 실행
  │      └─ 매칭 실패 → 빌드 스텝만 실행 (generic + clash)
  │
  ├─ LINE LOOP ─────────────────────────┐
  │   ├─ Phase 활성화 체크               │
  │   ├─ linearEvent or Branch 선택      │
  │   ├─ 이벤트 텍스트 + 병력/자원 변동   │
  │   ├─ decisive 체크 → 승패?           │
  │   ├─ Clash 트리거 체크               │
  │   ├─ 승리 조건 체크                  │
  │   └─ 회복 적용 → 다음 라인 ──────────┘
  │
  └─ _emitEnding() → GG → 종료
```

---

## 1단계: 진입점 — simulateMatchWithLog()

**파일:** `match_simulation_service.dart:360`

- `homePlayer`, `awayPlayer`, `map` + 선택적 `forcedHomeBuildId`/`forcedAwayBuildId` 수신
- `calculateWinRate()`로 기본 승률 계산
- 선수 능력치 추출 (`effectiveStatsWithEquipment`)

---

## 2단계: 빌드 선택

**파일:** `build_orders.dart:6288-6363`

```
forced 빌드 지정됨? → 해당 빌드 사용
아니면 → BuildOrderData.getBuildOrder() 호출
```

### 선택 로직 (종족별 분기)

- **저그**: `_selectOpening()` → `_selectTransition()` → `composeBuild(opening, transition)`
- **테란/프로토스**: 같은 패턴. 치즈/풀빌드면 트랜지션 생략

### 점수 시스템 (`_selectOpening`, lines 6366-6436)

- **능력치 점수**: 빌드의 `keyStats` 2개에 해당하는 선수 능력치 합산
- **맵 보너스**: rushDistance, resources, terrain 등 맵 속성에 따라 가중치
- **치즈 게이트**: 5~15% 확률로 치즈 빌드 후보 포함
- 최고 점수 빌드 선택

---

## 3단계: BuildType 매핑

**파일:** `enums.dart:447`

- `BuildType.getById(buildId)` → 빌드 ID를 BuildType enum으로 변환
- BuildType 없으면 `_determineBuildStyle()`로 스타일만 결정 (aggressive/balanced/defensive/cheese)

---

## 4단계: 시나리오 매칭

**파일:** `scenario_scripts.dart:458-507`

### 2-Pass 알고리즘

| Pass | 조건 | 예시 |
|------|------|------|
| **1. 정방향** | `homeBuildId ∈ script.homeBuildIds` AND `awayBuildId ∈ script.awayBuildIds` | TvZ 시나리오에서 T=home, Z=away |
| **2. 역방향** | reverseMatchup 검색, 빌드 ID 스왑 매칭 | ZvT 시나리오에서 home↔away 뒤집기, `isReversed=true` |

**매칭 실패 시:** `null` 반환 → 시나리오 없이 generic 실행 + clash
> ⚠️ 현재 모든 빌드 조합이 시나리오로 커버되므로 매칭 실패는 발생하지 않음 (284개 시나리오, 100% 커버리지)

---

## 5단계: 시나리오 실행 or 폴백

```
빌드 자체가 null?  → _fallbackSimulation() (generic 이벤트 풀만 사용)
시나리오 매칭 성공? → Phase별 순차 실행
시나리오 매칭 실패? → 빌드 스텝 순차 실행 + clash 자연 발생
```

---

## 6단계: Phase별 이벤트 실행

**파일:** `match_simulation_service.dart:3550-3743`

```
LOOP (lineCount < maxLines, !isFinished):
  현재 lineCount >= phase.startLine? → 해당 phase 활성화

  phase에 linearEvents 있으면 → 순차 실행
  phase에 branches 있으면   → 분기 선택 후 실행
```

### 분기 선택 (`_selectScriptBranch`)

1. `conditionHomeBuildIds`/`conditionAwayBuildIds`로 빌드 필터링
2. `conditionStat` + `baseProbability`로 능력치 기반 확률 선택

### 이벤트 처리

- `skipChance`로 확률 스킵
- `altText` 50% 대체
- `{home}`/`{away}` 플레이스홀더 치환 (reversed면 자동 스왑)
- `_transformEnding()` 35% 어미 변환
- `decisive`: 즉시 승패 판정 (확률 체크 후)

---

## 7단계: Clash (교전) 발생

**파일:** `match_simulation_service.dart:679-1200`

### 트리거 조건

- 빌드 스텝에 `isClash == true`
- ZvZ: line ≥ 10이면 40%, line ≥ 25이면 15%
- 일반: line ≥ 50이면 10%

### 교전 처리

- 공격자 결정 (aggressive 70%, 아니면 power 기반)
- `BuildOrderData.getClashEvents()`로 이벤트 풀 구성
- `winRate` 보정 적용
- 교전 사이 2라인 회복 (60라인 이후 1라인)

---

## 8단계: 승리 판정

**파일:** `match_simulation_service.dart:3972-4002`

| 조건 | 결과 |
|------|------|
| `decisive` 이벤트 발동 | 즉시 승패 |
| 한쪽 army ≤ 0 | 상대 승리 |
| 양쪽 army ≤ 0 | 50/50 랜덤 |
| line ≥ 50 + army 5:1 비율 | 우세 측 승리 |
| line ≥ 100 + 종합점수 3:1 | 우세 측 승리 |
| line = 200 (최대) | 종합점수로 판정 |

---

## 9단계: 종료

- `_emitEnding()` → 마무리 텍스트 → GG → `isFinished = true`

---

## 빌드 선택 시스템 상세: 오프닝 + 트랜지션 조합

`composeBuild(opening, transition)`에서 **`id: transition.id`** — 최종 빌드 ID는 항상 트랜지션 ID.

### 최종 빌드 ID 결정 규칙

| 종족 | 조건 | 최종 빌드 ID |
|------|------|-------------|
| 저그 | `style == cheese` | 오프닝 ID (예: zvp_4pool) |
| 저그 | 그 외 | 트랜지션 ID (예: zvp_trans_973_hydra) |
| 테란/프로토스 | `style == cheese` OR `steps.last.line > 16` | 오프닝 ID (자체완결) |
| 테란/프로토스 | 그 외 | 트랜지션 ID |

### 종족전별 오프닝 풀 → 최종 빌드 ID

**TvZ 테란** (terranOpeningsTvZ → terranTransitionsTvZ)
- 오프닝: tvz_bunker(cheese,L25), tvz_sk_opening(agg,L16), tvz_4bar_enbe(agg,L45), tvz_1bar_double(bal,L13), tvz_1fac_double(bal,L14), tvz_nobar_double(def,L13)
- 자체완결: **tvz_bunker**, **tvz_4bar_enbe**
- 트랜지션: **tvz_trans_bionic_push**, **tvz_trans_mech_goliath**, **tvz_trans_111_balance**, **tvz_trans_valkyrie**, **tvz_trans_wraith**, **tvz_trans_enbe_push**
- **정상 게임 최종 빌드: 8개**

**ZvT 저그** (zergOpeningsZvT → zergTransitionsZvT)
- 오프닝: zvt_4pool(cheese,L21), zvt_9pool(agg,L16), zvt_9overpool(agg,L14), zvt_12pool(bal,L16), zvt_12hatch(bal,L16), zvt_3hatch_nopool(def,L16)
- 자체완결: **zvt_4pool** (치즈만)
- 트랜지션: **zvt_trans_mutal_ultra**, **zvt_trans_2hatch_mutal**, **zvt_trans_lurker_defiler**, **zvt_trans_530_mutal**, **zvt_trans_mutal_lurker**, **zvt_trans_ultra_hive**
- **정상 게임 최종 빌드: 7개**

**TvP 테란** (terranOpeningsTvP → terranTransitionsTvP)
- 자체완결: **tvp_bbs**
- 트랜지션: **tvp_trans_tank_defense**, **tvp_trans_timing_push**, **tvp_trans_upgrade**, **tvp_trans_bio_mech**, **tvp_trans_5fac_mass**, **tvp_trans_anti_carrier**
- **정상 게임 최종 빌드: 7개**

**PvT 프로토스** (protossOpeningsPvT → protossTransitionsPvT)
- 자체완결: **pvt_proxy_gate**, **pvt_dark_swing**, **pvt_2gate_open**
- 트랜지션: **pvt_trans_5gate_push**, **pvt_trans_5gate_arbiter**, **pvt_trans_5gate_carrier**, **pvt_trans_reaver_push**, **pvt_trans_reaver_arbiter**, **pvt_trans_reaver_carrier**
- **정상 게임 최종 빌드: 9개**

**ZvP 저그** (zergOpeningsZvP → zergTransitionsZvP)
- 자체완결: **zvp_4pool**, **zvp_5drone** (치즈만)
- 트랜지션: **zvp_trans_5hatch_hydra**, **zvp_trans_mutal_hydra**, **zvp_trans_hive_defiler**, **zvp_trans_973_hydra**, **zvp_trans_mukerji**, **zvp_trans_yabarwi**, **zvp_trans_hydra_lurker**
- **정상 게임 최종 빌드: 9개**

**PvZ 프로토스** (protossOpeningsPvZ → protossTransitionsPvZ)
- 자체완결: **pvz_proxy_gate**, **pvz_cannon_rush**, **pvz_2star_corsair**
- 트랜지션: **pvz_trans_dragoon_push**, **pvz_trans_corsair**, **pvz_trans_archon**, **pvz_trans_forge_expand**
- **정상 게임 최종 빌드: 7개**

### 독립 BuildOrder vs 오프닝/트랜지션 구분

각 매치업에는 **독립 BuildOrder** (예: zvp_9pool, pvz_8gat)와 **오프닝+트랜지션 시스템**이 공존.
- 정상 게임: 스코어링 시스템 → 오프닝+트랜지션 경로만 사용
- 독립 BuildOrder: `forcedBuildId` 또는 스코어링 없는 폴백에서만 선택됨
- 시나리오는 `homeBuildIds`에 트랜지션 ID + 독립 ID를 함께 포함하여 양쪽 커버

---

## 시나리오 커버리지 분석

> 분석 스크립트: `tools/coverage_analysis.js`

### 전체 요약 (2026-04-03 기준)

| 매치업 | 시나리오 수 | 빌드 수 | 커버리지 |
|--------|-----------|---------|---------|
| **TvT** | 45 | 9 (9미러+36크로스) | **100%** |
| **TvZ** | 56 | 8T×7Z | **100%** |
| **PvT** | 63 | 9P×7T | **100%** |
| **PvP** | 36 | 8 (8미러+28크로스) | **100%** |
| **ZvP** | 63 | 9Z×7P | **100%** |
| **ZvZ** | 21 | 6 (6미러+15크로스) | **100%** |
| **총합** | **284** | — | **100%** |

모든 빌드 조합이 시나리오로 커버됨. 폴백(build_orders.dart 로그) 발동 없음.
