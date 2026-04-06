# TvT 시나리오 보정 루프 최종 결과

- **상태**: ✅ PASS
- **총 경기 수**: 4500 (45개 시나리오 × 100경기)
- **최종 에러**: 0건
- **최종 경고**: 0건
- **완료 일시**: 2026-04-05

## 반복 이력

| 라운드 | 에러 | 경고 | 주요 수정 내용 |
|--------|------|------|----------------|
| Round 1 | 832 → 58 | 0 | B11 선행건물 누락 대량 수정 + A5 Owner 불일치 수정 |
| Round 2 | 58 → 4 | 0 | bbs_vs_2star skipChance 제거, bbs_vs_5fac away 스타포트 이벤트 추가, 5fac_mirror guerrilla altText 수정 |
| Round 3 | 4 → 0 | 0 | 5fac_mirror finishing 분기 altText에 스타포트 추가 |

## 수정된 파일 목록

- `lib/core/constants/scenarios/tvt/5fac_mirror.dart`
  - guerrilla 분기 away altText: `드랍십이 떠났습니다` → `수송선이 떠났습니다`
  - finishing 분기 home altText: `드랍십 두 대 생산` → `스타포트에서 드랍십 두 대 생산`
  - away 머신샵 이벤트 추가, desperate 분기 스타포트 표기 추가

- `lib/core/constants/scenarios/tvt/1fac_1star_vs_2star.dart`
  - 스타포트 이벤트 텍스트 보강, 드랍십 altText에 컨트롤타워 추가

- `lib/core/constants/scenarios/tvt/fd_rush_vs_nobar_double.dart`
  - away 스타포트+컨트롤타워 이벤트 추가

- `lib/core/constants/scenarios/tvt/1bar_double_vs_1fac_double.dart`
  - home 팩토리 이벤트 순서 조정

- `lib/core/constants/scenarios/tvt/2fac_push_vs_1fac_double.dart`
  - away 아머리 텍스트에 스타포트 대비 표현 추가

- `lib/core/constants/scenarios/tvt/1fac_1star_vs_2fac_push.dart`
  - away 스타포트 이벤트 skipChance 제거

- `lib/core/constants/scenarios/tvt/2star_vs_1bar_double.dart`
  - away 스타포트 정찰 이벤트 추가 (skipChance 없음)

- `lib/core/constants/scenarios/tvt/2star_vs_1fac_double.dart`
  - away 스타포트 정찰 이벤트 추가 (skipChance 없음)

- `lib/core/constants/scenarios/tvt/bbs_vs_2star.dart`
  - home 스타포트 정찰 이벤트 skipChance 제거 (B11 위반 해결)

- `lib/core/constants/scenarios/tvt/bbs_vs_1fac_1star.dart`
  - away 스타포트 정찰 이벤트 추가

- `lib/core/constants/scenarios/tvt/bbs_vs_5fac.dart`
  - away 스타포트 정찰 이벤트 추가 (B11 위반 해결)

- `lib/core/constants/scenarios/tvt/2star_mirror.dart`
  - A5 Owner 불일치 이벤트 2건 텍스트 수정

- `lib/core/constants/scenarios/tvt/bbs_vs_2star.dart`
  - attrition 분기 텍스트 수정 (레이스 표현 개선)

## 주요 문제 패턴 및 해결책

### B11_TECH_TREE (선행건물 미등록)
- **원인 1**: skipChance가 있는 건물 등록 이벤트가 스킵될 때 이후 유닛 이벤트에서 위반
  → 핵심 건물 등록 이벤트의 skipChance 제거
- **원인 2**: altText가 메인 텍스트의 건물명을 포함하지 않을 때 altText 발동 시 위반
  → altText에도 건물명 포함
- **원인 3**: build_orders.dart 폴백이 발동되어 레이스/드랍십 이벤트가 선행건물 없이 등장
  → 시나리오에 상대 건물 정찰 이벤트 추가하여 양쪽 모두 건물 등록
- **원인 4**: system 이벤트에서 유닛 언급 시 양쪽 모두 선행건물이 등록되어 있어야 함
  → 상대방 측에도 건물명이 포함된 이벤트(정찰/확인) 추가

### A5_OWNER_MISMATCH (주체-Owner 불일치)
- **원인**: 이벤트 텍스트의 주어가 Owner와 다른 선수를 지칭
  → 텍스트를 Owner 선수가 주어가 되도록 수정
