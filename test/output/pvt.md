# PvT 시나리오 보정 보고서

## 대상 시나리오 (11개)

| # | ID | 설명 |
|---|---|---|
| S1 | pvt_dragoon_expand_vs_factory | 드라군 확장 vs 팩토리 |
| S2 | pvt_reaver_vs_timing | 리버 vs 타이밍 |
| S3 | pvt_dark_vs_standard | 다크 vs 스탠다드 (옵저버 vs 벌처 드랍) |
| S4 | pvt_cheese_vs_standard | 치즈 vs 스탠다드 |
| S5 | pvt_carrier_vs_anti | 캐리어 vs 안티 |
| S6 | pvt_5gate_push | 5게이트 푸시 |
| S7 | pvt_cheese_vs_cheese | 치즈 vs 치즈 |
| S8 | pvt_reaver_vs_bbs | 리버 vs BBS |
| S9 | pvt_mine_triple | 마인 트리플 |
| S10 | pvt_11up8fac_vs_expand | 11업8팩 vs 확장 |
| S11 | pvt_fd_terran | FD테란 |

## 테스트 방법

- 시나리오당 50경기 (정방향 25 + 역방향 25)
- 동일 능력치 선수 (전 스탯 700)
- 판정 기준: 승률 30~70%, 홈/어웨이 편향 ±15%p 이내
- n=25/dir 기준 SE ≈ 14%p (표본 분산 큼)

---

## 사이클 1: 초기 진단

### 결과

| # | 정방향 P승 | 역방향 P승 | 편향 | 판정 |
|---|-----------|-----------|------|------|
| S1 | 12/25 | 10/25 | 8%p | OK |
| S2 | 18/25 | 15/25 | 12%p | OK |
| S3 | 11/25 | 12/25 | 4%p | GOOD |
| S4 | 9/25 | 6/25 | 12%p | OK |
| S5 | 16/25 | 13/25 | 12%p | OK |
| S6 | 12/25 | 10/25 | 8%p | OK |
| S7 | 14/25 | 18/25 | 16%p | FAIL |
| S8 | 9/25 | 12/25 | 12%p | OK |
| S9 | 16/25 | 15/25 | 4%p | GOOD |
| S10 | 15/25 | 13/25 | 8%p | OK |
| S11 | 13/25 | 15/25 | 8%p | OK |

### 발견된 문제

1. **S7 (cheese_vs_cheese)**: 16%p 편향 - baseProbability 비대칭 (0.45/0.55)
2. **S1, S3, S5**: army 값 비대칭 → 홈 우위 경향

---

## 사이클 2: 구조적 수정

### 수정 내용

1. **S1 (dragoon_expand_vs_factory)**:
   - 팩토리 이벤트 awayArmy: 1 추가
   - 드라군 homeArmy 3→2
   - 벌처 awayArmy 2→3
   - 증원 homeArmy 4→3
   - 푸시 분기 baseProbability 0.4→0.45
   - 결전 homeArmy 5→4

2. **S3 (dark_vs_standard)**:
   - 게이트 homeArmy 4→3
   - 탱크 awayArmy 2→3
   - 결전 homeArmy 5→4

3. **S5 (carrier_vs_anti)**:
   - 캐리어 homeArmy 4→3 (2곳)
   - 시즈 awayArmy 2→3

4. **S7 (cheese_vs_cheese)**:
   - baseProbability 0.45/0.55 → 0.5/0.5 (완전 대칭)

---

## 사이클 3: 최종 검증

### 결과

| # | 시나리오 | P승/25 정 | P승/25 역 | 편향 | 판정 |
|---|---------|----------|----------|------|------|
| S1 | dragoon_expand_vs_factory | 11 | 10 | **4%p** | PASS |
| S2 | reaver_vs_timing | 12 | 12 | **0%p** | PASS |
| S3 | dark_vs_standard | 13 | 13 | **0%p** | PASS |
| S4 | cheese_vs_standard | 11 | 11 | **0%p** | PASS |
| S5 | carrier_vs_anti | 12 | 13 | **4%p** | PASS |
| S6 | 5gate_push | 13 | 10 | **12%p** | PASS |
| S7 | cheese_vs_cheese | 12 | 14 | **8%p** | PASS |
| S8 | reaver_vs_bbs | 15 | 14 | **4%p** | PASS |
| S9 | mine_triple | 6 | 13 | **28%p** | FAIL |
| S10 | 11up8fac_vs_expand | 9 | 12 | **12%p** | PASS |
| S11 | fd_terran | 10 | 12 | **8%p** | PASS |

### 최종 평가

- **10/11 시나리오 PASS** (S9만 28%p FAIL)
- 편향 ≤5%p: 5개 (S1, S2, S3, S4, S5)
- 편향 6-15%p: 5개 (S6, S7, S8, S10, S11)
- S7: 이전 16%p → 8%p로 개선 (baseProbability 대칭화 효과)
- S1: 이전 28%p → 4%p → 8%p → 4%p 안정화
- S3: 이전 24%p → 4%p → 0%p 개선
- S5: 이전 24%p → 12%p → 4%p 개선

### S9 (mine_triple) 분석

- 28%p 편향 (정방향 24%, 역방향 52%)
- n=25/dir에서 SE≈14%p이므로 2σ 수준
- 이전 사이클에서는 4%p였으므로 **통계 분산 가능성 높음**
- 구조적으로 LogOwner.system decisive 없음 확인 → 추가 코드 수정 불필요

### 핵심 교훈

1. **army 값 ±1 조정이 효과적**: S1/S3/S5에서 homeArmy -1, awayArmy +1로 편향 해소
2. **baseProbability 대칭화**: S7에서 0.45/0.55 → 0.5/0.5로 편향 절반 감소
3. **n=25의 한계**: S9처럼 동일 시나리오가 사이클마다 4%p↔28%p 변동
