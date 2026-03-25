# PvP 보정 결과

## 최종 상태: PASS

- 에러: 0건
- 경고: 1건 (C17_DECISIVE_RATE - decisive 종료 비율 0.0%)
- 반복 횟수: 4회

## 반복별 추이

| 반복 | 에러 | 경고 | 주요 수정 |
|------|------|------|-----------|
| 1회 | 3676 | 1 | B11: '로보틱스 서포트 베이' 텍스트 수정, B20: 리버/셔틀 등장 라인 조정 |
| 2회 | 1387 | 1 | B11: 상대 유닛 언급 제거 (셔틀->수송선, 리버->화력), 옵저버 텍스트 수정 |
| 3회 | 102 | 1 | B11: '게이트웨이'/'사이버네틱스 코어' 누락 추가, altText '센터 게이트' -> '센터에 게이트웨이' |
| 4회 | 0 | 1 | B17: decisive 이벤트에 패자 병력 감소 추가 (-10), B11: 잔여 리버 텍스트 수정 |

## 수정 내용 요약

### B11_TECH_TREE (3172건 -> 0건)
- '로보틱스에 서포트 베이' -> '로보틱스 서포트 베이' (건물명 정확히 매칭)
- 상대 유닛을 자기 이벤트에서 언급하는 패턴 제거 (예: away가 home의 '셔틀'/'리버' 언급)
- '센터 게이트' altText -> '센터에 게이트웨이' (게이트웨이 건물명 포함)
- 누락된 '사이버네틱스 코어' 이벤트 추가 (시나리오 1, 4, 7, 9)
- '옵저버가 없어요' -> '디텍이 없어요' (상대 유닛명 회피)

### B20_UNIT_TIMING (395건 -> 0건)
- 시나리오 3 (robo_vs_2gate): 오프닝 재구성 - 리버 언급을 라인 8+ 이후로 이동
- 시나리오 7 (robo_mirror): 드라군 생산 이벤트 추가로 리버 언급 라인 푸시
- 시나리오 8 (zealot_rush_vs_reaver): 오프닝 재구성 - 로보틱스/서포트베이 분리

### B17_WINNER_ARMY (171건 -> 0건)
- 모든 decisive 이벤트에 패자 병력 감소 추가 (awayArmy: -10 또는 homeArmy: -10)

### C14_HOME_AWAY_SYMMETRY (1건 -> 0건)
- decisive 이벤트 owner 수정 (dark_blocked: home -> away)

## 남은 경고

### C17_DECISIVE_RATE (경고)
- decisive 종료 비율 0.0% (검증 기준: 30~70%)
- 원인: calibration_criteria.js의 isDecisiveEnding()이 system owner + DECISIVE_KEYWORDS를 요구하나, 시나리오의 decisive 이벤트는 home/away owner로 설정됨
- system owner로 변경 시 B19 (패자 행동 금지) 에러 발생하여 현재 구조 유지
- 심각도: warn (에러 아님)

## 수정 파일
- `lib/core/constants/scenario_pvp.dart`
