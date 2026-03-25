# ZvZ 보정 최종 리포트

- **최종 상태**: PASS
- **반복 횟수**: 4회
- **최종 에러**: 0건
- **최종 경고**: 40건 (B10: 39, C17: 1)
- **수정 파일**: lib/core/constants/scenario_zvz.dart

## 반복별 에러/경고 추이

| 반복 | 에러 | 경고 | 주요 수정 |
|------|------|------|-----------|
| 1회 | 1696 | 48 | 초기 상태 |
| 2회 | 384 | 41 | B11: 시나리오 2,4,8에 스파이어/레어 추가, B17: 결전 분기 army 강화 |
| 3회 | 175 | 40 | B11: 시나리오 6 스포닝풀 추가, B17: 4풀 시나리오 army 대폭 강화 |
| 4회 | 75 | 38 | B11: 시나리오 8,9 스포닝풀 추가, B17: 4pool vs 12hatch army 추가 강화 |
| 5회 (최종) | 0 | 40 | B11: 9오버풀미러 스포닝풀, B17: 4pool vs 12hatch army 최종 조정 |

## 수정 내용 요약

### B11_TECH_TREE 수정 (1475건 -> 0건)
- 시나리오 2 (12hatch vs 9pool): home에 레어+스파이어 건설 이벤트 추가
- 시나리오 4 (3hatch mirror): away에 레어+스파이어 건설 이벤트 추가
- 시나리오 6 (4pool vs 3hatch): away altText에 스포닝풀 키워드 추가
- 시나리오 8 (12pool vs 3hatch): away에 스포닝풀+스파이어 건설 이벤트 추가
- 시나리오 9 (9overpool mirror): away 오프닝에 스포닝풀 키워드 추가

### B17_WINNER_ARMY 수정 (220건 -> 0건)
- 모든 결전(decisive) 분기의 army 델타 강화
- 특히 4풀 시나리오(3,5,6)에서 decisive 승자의 army 대폭 증가 (+30~40, -40~50)
- 뮤탈 결전 시나리오(1,4,7,8,9)에서도 army 델타 강화 (+5/-8, +3/-3)

### C14_HOME_AWAY_SYMMETRY 수정 (1건 -> 0건)
- army 델타 대칭화로 자연 해소

## 남은 경고

### B10_SYSTEM_RATIO (39건)
- 4풀 vs 12hatch 시나리오에서 시스템 해설 비율 31.3% (최대 30% 초과)
- 이벤트 수가 적은 시나리오(16줄)에서 시스템 이벤트 비율이 높아지는 구조적 문제

### C17_DECISIVE_RATE (1건)
- decisive 종료 비율 0.0% (최소 30% 필요)
- 시나리오의 decisive 이벤트는 정상 작동하나, calibration_criteria.js의 isDecisiveEnding()이 system owner + DECISIVE_KEYWORDS 조합으로 감지하는 반면, 시뮬레이션 엔진의 _emitEnding()이 GG를 loser owner로 출력하여 불일치 발생
- match_simulation_service.dart 또는 calibration_criteria.js 수정 필요 (scenario 파일로는 해결 불가)
