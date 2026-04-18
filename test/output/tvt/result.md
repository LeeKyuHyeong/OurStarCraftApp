# TvT 시나리오 보정 루프 최종 결과

- **최종 상태**: ✅ PASS
- **종료 사유**: 3차 라운드에서 모든 에러 제거 (절차 4단계 "PASS면 즉시 종료")
- **검증 도구**: tools/calibration_criteria.js
- **시뮬레이션 규모**: 36개 시나리오 × 100경기 = 3,600경기
- **검증 일자**: 2026-04-17

## 라운드별 추이

| 라운드 | 상태 | 에러 | 경고 | 비고 |
|--------|------|------|------|------|
| 1차 | ❌ FAIL | 173 | 1 | A2/A5/B11/B22 위반 다수 |
| 2차 | ❌ FAIL | 11 | 1 | 1차 수정 효과 173→11 (94% 감소) |
| 3차 | ✅ PASS | 0 | 1 | 모든 에러 제거 |

## 라운드별 수정 내역

### 1차 → 2차 (수정)

| 위반 코드 | 건수 | 수정 파일 | 수정 내용 |
|-----------|------|-----------|-----------|
| A2_BUILDING_NAME | 56 | `bbs_vs_1bar_double.dart` | '커맨드 센터' → '커맨드센터' (4곳, 일괄 치환) |
| A5_OWNER_MISMATCH | 28 | `1fac_1star_vs_2star.dart` | home altText의 `{away}` → `{home}` (1곳), away altText의 `{home}` → `{away}` (1곳) |
| B11_TECH_TREE | 32 | `1fac_1star_vs_2fac_push.dart` | away의 '레이스' 단어 → '터렛' (스타포트 미선행 텍스트 수정) |
| B22_MULTI_BUILDING_LINE | 57 | `1fac_1star_vs_2fac_push.dart` | "팩토리 완성, 머신샵 부착하면서 스타포트도 건설" → 두 ScriptEvent로 분리 (팩토리/머신샵 + 스타포트) |

### 2차 → 3차 (수정)

| 위반 코드 | 건수 | 수정 파일 | 수정 내용 |
|-----------|------|-----------|-----------|
| B22_MULTI_BUILDING_LINE | 11 | `1fac_1star_vs_2star.dart` | "엔지니어링 베이, 아머리, 아카데미를 나눠서 올립니다" → 두 ScriptEvent로 분리 (엔베 + 아카데미/아머리) |

## 남은 경고 (미수정)

### C17_DECISIVE_RATE (warning, 1건)

```
decisive 종료 비율 1.5% (최소 30% 필요) [54/3600]
```

- **심각도**: warning (절차상 "가능하면 수정", PASS 자체에는 영향 없음)
- **미수정 사유**:
  - 36개 시나리오 전반에 `decisive: true` 추가가 필요한 광범위 작업
  - 한 라운드당 B/C 항목 최대 2개 수정 룰을 초과할 위험
  - decisive 추가가 B17(승자 병력)/B19(종료 후 행동) 위반을 새로 유발할 가능성
  - 절차 4단계 "PASS면 즉시 종료" 규칙 적용
- **권고**: 후속 라운드에서 별도 보정 작업으로 시나리오별 결정적 분기 추가 고려

## 핵심 검증 결과 (C13/C14/C15)

| 코드 | 항목 | 상태 |
|------|------|------|
| C13 | 승률 30~70% (미러 45~55%) | ✅ PASS |
| C14 | 홈/어웨이 반전 ±5%p | ✅ PASS |
| C15 | 텍스트 다양성 (500경기 50+ 고유) | ✅ PASS |

→ test_tvt.md 'Y'→'X' 회귀 표기 불필요.

## 수정 파일 요약

- `lib/core/constants/scenarios/tvt/bbs_vs_1bar_double.dart`
- `lib/core/constants/scenarios/tvt/1fac_1star_vs_2star.dart`
- `lib/core/constants/scenarios/tvt/1fac_1star_vs_2fac_push.dart`

build_orders.dart는 수정하지 않음 (공유 파일 보호 규칙 준수).

## 후속 권장 작업

1. C17 보정: decisive 종료 비율 30%까지 끌어올리기 위한 시나리오별 결정 분기 추가
2. 동일 절차로 다른 종족전(TvZ/PvT/PvP/ZvP/ZvZ) 보정 진행
