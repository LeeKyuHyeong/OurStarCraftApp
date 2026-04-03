# ZVZ 시나리오 보정 추이

> 총 21개 시나리오 | 보정 완료 시 O로 변경

| # | 시나리오명 | Home 빌드 | Away 빌드 | 보정횟수 | 비고 | 완료 |
|---|-----------|----------|----------|---------|------|:----:|
| 1 | 12hatch_mirror | zvz_12hatch | zvz_12hatch | 0 | | X |
| 2 | 12hatch_vs_12pool | zvz_12hatch | zvz_12pool | 0 | | X |
| 3 | 12hatch_vs_3hatch_nopool | zvz_12hatch | zvz_3hatch_nopool | 0 | | X |
| 4 | 12pool_mirror | zvz_12pool | zvz_12pool | 0 | | X |
| 5 | 12pool_vs_3hatch_nopool | zvz_12pool | zvz_3hatch_nopool | 0 | | X |
| 6 | 3hatch_nopool_mirror | zvz_3hatch_nopool | zvz_3hatch_nopool | 0 | | X |
| 7 | 4pool_vs_3hatch | zvz_pool_first | zvz_3hatch_nopool | 0 | | X |
| 8 | 9overpool_mirror | zvz_9overpool | zvz_9overpool | 0 | | X |
| 9 | 9overpool_vs_12hatch | zvz_9overpool | zvz_12hatch | 0 | | X |
| 10 | 9overpool_vs_12pool | zvz_9overpool | zvz_12pool | 0 | | X |
| 11 | 9overpool_vs_3hatch_nopool | zvz_9overpool | zvz_3hatch_nopool | 0 | | X |
| 12 | 9pool_mirror_single | zvz_9pool | zvz_9pool | 0 | | X |
| 13 | 9pool_vs_12hatch | zvz_9pool | zvz_12hatch | 0 | | X |
| 14 | 9pool_vs_12pool | zvz_9pool | zvz_12pool | 0 | | X |
| 15 | 9pool_vs_3hatch_nopool | zvz_9pool | zvz_3hatch_nopool | 0 | | X |
| 16 | 9pool_vs_9overpool | zvz_9pool | zvz_9overpool | 0 | | X |
| 17 | pool_first_mirror | zvz_pool_first | zvz_pool_first | 0 | | X |
| 18 | pool_first_vs_12hatch | zvz_pool_first | zvz_12hatch | 0 | | X |
| 19 | pool_first_vs_12pool | zvz_pool_first | zvz_12pool | 0 | | X |
| 20 | pool_first_vs_9overpool | zvz_pool_first | zvz_9overpool | 0 | | X |
| 21 | pool_first_vs_9pool | zvz_pool_first | zvz_9pool | 0 | | X |

---

## 커버리지

모든 빌드 조합 커버 완료 (6미러 + 15크로스 = 21개). 미커버 없음.

## 홈/어웨이 편향 수정 이력 (2026-04-03)

baseProbability 비대칭 + 비대칭 linear phase로 인한 10.7%p 편향 → 1.0%p로 해소.

### baseProbability 균등화 (7개 파일)
| 파일 | 수정 전 (공격/방어) | 수정 후 |
|------|-------------------|---------|
| pool_first_vs_9pool | 0.8 / 1.0 | 1.0 / 1.0 |
| pool_first_vs_9overpool | 0.9 / 1.0 | 1.0 / 1.0 |
| pool_first_vs_12pool | 0.6 / 1.0 | 1.0 / 1.0 |
| pool_first_vs_12hatch | 0.7 / 1.0 | 1.0 / 1.0 |
| 4pool_vs_3hatch | 0.5 / 1.0 | 1.0 / 1.0 |
| 9pool_vs_3hatch_nopool | 0.6 / 1.0 | 1.0 / 1.0 |
| 9overpool_vs_3hatch_nopool | 0.5 / 1.0 | 1.0 / 1.0 |

### 비대칭 linear phase 수정 (4개 파일)
- 9pool_vs_12hatch: 뮤탈 견제 이벤트에 skipChance 0.5 추가
- 9overpool_vs_12hatch: 동일
- 12hatch_vs_12pool: 홈 전용 이벤트 skipChance 0.5 + 어웨이 대응 이벤트 추가
- 12pool_vs_3hatch_nopool: 어웨이 병력 누적 감소 (awayArmy 6→5)
