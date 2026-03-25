# PvP 보정 결과 (2차 재실행)

## 최종 상태: PASS

- 에러: 0건
- 경고: 1건 (C17_DECISIVE_RATE - decisive 종료 비율 100.0%)
- 반복 횟수: 1회 (1회차에서 즉시 PASS)

## 반복별 추이

| 반복 | 에러 | 경고 | 주요 수정 |
|------|------|------|-----------|
| 1회 | 0 | 1 | 수정 불필요 (PASS) |

## 남은 경고

### C17_DECISIVE_RATE (경고)
- decisive 종료 비율 100.0% (검증 기준: 30~70%)
- 원인: match_simulation_service.dart가 모든 경기 종료 시 'GG를 선언합니다' 텍스트를 추가
- 'GG'가 DECISIVE_KEYWORDS에 포함되어 isDecisiveEnding()이 모든 경기에서 true 반환
- scenario_pvp.dart 수정으로는 해결 불가 (시뮬레이션 서비스 레벨 이슈)
- 수정 대상: match_simulation_service.dart 또는 calibration_criteria.js
- 심각도: warn (에러 아님) - PASS 조건에 영향 없음

## 수정 파일
- 이번 라운드에서는 수정 없음 (1회차에서 PASS)
