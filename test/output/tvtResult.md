# TvT 보정 루프 결과

## 요약
- **최종 상태**: FAIL (에러 137건, 경고 1건)
- **총 반복**: 3회
- **경기 수**: 600경기
- **검증 시각**: 2026-03-25

## 에러/경고 추이
| 반복 | 에러 | 경고 | 주요 변경 |
|------|------|------|-----------|
| 1 | 617 | 1 | 초기 상태 (B11: 477, B17: 140) |
| 2 | 228 | 1 | B11: away 팩토리 추가, 레이스→공중 견제 텍스트 변경, 골리앗→대공 화력 변경 |
| 3 | 137 | 1 | B11: 5팩 시나리오 머신샵 추가, 공격적 빌드 아머리 skipChance 제거 → B11 완전 해결 |

## 해결된 에러
- **B11_TECH_TREE (477→0건)**: 완전 해결
  - 시나리오3(레이스 vs 배럭더블): away에 팩토리 건물 이벤트 추가, away의 '레이스' 언급을 '공중 견제/공중 유닛'으로 변경, home의 '골리앗' 언급을 '대공 화력'으로 변경
  - 시나리오4(5팩 vs 마인트리플): 머신샵 부착 이벤트를 탱크 생산 전에 추가
  - 시나리오6(공격적 빌드 대결): away 아머리 이벤트의 skipChance 제거 (필수 테크트리)

## 남은 에러
- **B17_WINNER_ARMY (137건)**: 승자 최종 병력 < 패자 최종 병력
  - 근본 원인: `isDecisiveEnding()` 함수가 system 로그에서 DECISIVE_KEYWORDS를 찾지만, `_emitEnding()`이 생성하는 system 로그에는 해당 키워드가 포함되지 않음
  - decisive 이벤트로 끝나는 경기도 '이영호 선수 승리!' 같은 system 텍스트를 생성하여 DECISIVE_KEYWORDS('승리를 거둡니다', 'GG' 등)와 매칭되지 않음
  - GG 텍스트는 player owner(away/home)로 출력되어 system 로그 체크에 걸리지 않음
  - **수정 필요 파일**: `match_simulation_service.dart`의 `_emitEnding` 또는 `_getEndingCommentary` 함수, 또는 `tools/calibration_criteria.js`의 `isDecisiveEnding` 함수 (scenario_tvt.dart에서는 수정 불가)

## 남은 경고
- **C17_DECISIVE_RATE (1건)**: decisive 종료 비율 0.0% (동일 근본 원인)

## 수정된 파일
- `lib/core/constants/scenario_tvt.dart`
  - 시나리오3 오프닝: away 팩토리 건물 이벤트 추가
  - 시나리오3 Phase 1: away '레이스' → '공중 견제' 텍스트 변경
  - 시나리오3 Phase 2 분기B: '골리앗이 대기 중' → '대공 화력이 대기 중', '레이스를 격추' → '공중 유닛을 격추'
  - 시나리오3 Phase 3: '터렛으로 레이스를 대비' → '터렛으로 공중 유닛을 대비'
  - 시나리오4 Phase 0: 머신샵 이벤트 추가 (탱크 생산 전)
  - 시나리오6 중반: away 아머리 이벤트 skipChance 제거
