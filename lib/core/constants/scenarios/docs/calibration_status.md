# 전 종족전 시나리오 보정 통합 현황

> 보정 루프: `calibration_criteria.js` 기반 전체 검증
> 사전 루프: 개별 시나리오 1000경기 C13/C14/C15 검증 → Y 표기
> Y = 사전 루프 통과 | O = 미러(보정 대상 아님) | X = 미보정 | ㅁ = 작성 중

---

## ZvZ (21개) — PASS 완료

> 보정 루프 PASS (2026-04-10) | 전체 사전 루프 완료 후 test_zvz.md 삭제

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
| 3 | 9pool_lair_mirror | zvz_9pool_lair | zvz_9pool_lair | Y |
| 4 | 9overpool_mirror | zvz_9overpool | zvz_9overpool | Y |
| 5 | 12pool_mirror | zvz_12pool | zvz_12pool | Y |
| 6 | 12hatch_mirror | zvz_12hatch | zvz_12hatch | Y |

### 크로스 (15개)

| # | 파일명 | Home | Away | 보정 |
|---|--------|------|------|:----:|
| 7 | 4pool_vs_9pool_speed | zvz_4pool | zvz_9pool_speed | Y |
| 8 | 4pool_vs_9pool_lair | zvz_4pool | zvz_9pool_lair | Y |
| 9 | 4pool_vs_9overpool | zvz_4pool | zvz_9overpool | Y |
| 10 | 4pool_vs_12pool | zvz_4pool | zvz_12pool | Y |
| 11 | 4pool_vs_12hatch | zvz_4pool | zvz_12hatch | Y |
| 12 | 9pool_speed_vs_9pool_lair | zvz_9pool_speed | zvz_9pool_lair | Y |
| 13 | 9pool_speed_vs_9overpool | zvz_9pool_speed | zvz_9overpool | Y |
| 14 | 9pool_speed_vs_12pool | zvz_9pool_speed | zvz_12pool | Y |
| 15 | 9pool_speed_vs_12hatch | zvz_9pool_speed | zvz_12hatch | Y |
| 16 | 9pool_lair_vs_9overpool | zvz_9pool_lair | zvz_9overpool | Y |
| 17 | 9pool_lair_vs_12pool | zvz_9pool_lair | zvz_12pool | Y |
| 18 | 9pool_lair_vs_12hatch | zvz_9pool_lair | zvz_12hatch | Y |
| 19 | 9overpool_vs_12pool | zvz_9overpool | zvz_12pool | Y |
| 20 | 9overpool_vs_12hatch | zvz_9overpool | zvz_12hatch | Y |
| 21 | 12hatch_vs_12pool | zvz_12hatch | zvz_12pool | Y |

---

## TvT (36개) — PASS (루프), 사전 루프 진행 중

> 보정 루프 PASS (2026-04-17) | 경고 C17 1건 (decisive 비율)

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
| 9 | bbs_vs_1bar_double | tvt_bbs | tvt_1bar_double | Y |
| 10 | bbs_vs_1fac_double | tvt_bbs | tvt_1fac_double | Y |
| 11 | bbs_vs_1fac_1star | tvt_bbs | tvt_1fac_1star | Y |
| 12 | bbs_vs_2fac_push | tvt_bbs | tvt_2fac_push | Y |
| 13 | bbs_vs_2star | tvt_bbs | tvt_2star | Y |
| 14 | bbs_vs_nobar_double | tvt_bbs | tvt_nobar_double | Y |

### 원팩원스타 크로스 (5개)

| # | 파일명 | Home | Away | 보정 |
|---|--------|------|------|:----:|
| 15 | 1fac_1star_vs_2fac_push | tvt_1fac_1star | tvt_2fac_push | Y |
| 16 | 1fac_1star_vs_2star | tvt_1fac_1star | tvt_2star | Y |
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

## TvZ (56개) — PASS (루프), 사전 루프 미진행

> 보정 루프 PASS (2026-04-05) | 개별 시나리오 test_tvz.md 참조

---

## PvT (54개) — FAIL (루프)

> 보정 루프 FAIL (에러 1, 경고 22) | 개별 시나리오 test_pvt.md 참조

---

## PvP (36개) — PASS (루프), 사전 루프 미진행

> 보정 루프 PASS | 개별 시나리오 test_pvp.md 참조

---

## ZvP (63개) — PASS (루프), 사전 루프 미진행

> 보정 루프 PASS (경고 22건 C16) | 개별 시나리오 test_zvp.md 참조

---

## 전체 요약

| 종족전 | 시나리오 | 보정 루프 | Y | O | X/ㅁ | 진행률 |
|--------|:-------:|:---------:|:-:|:-:|:---:|:-----:|
| ZvZ | 21 | PASS | 21 | 0 | 0 | 100% |
| TvT | 36 | PASS | 8 | 8 | 20 | 44% |
| TvZ | 56 | PASS | 0 | 0 | 56 | 0% |
| PvT | 54 | FAIL | 0 | 0 | 54 | 0% |
| PvP | 36 | PASS | 0 | 0 | 36 | 0% |
| ZvP | 63 | PASS | 0 | 0 | 63 | 0% |
| **합계** | **266** | | **29** | **8** | **229** | **14%** |
