# TvZ 보정 2차 결과 리포트

- **최종 상태**: FAIL (build_orders.dart 기인 에러 잔존)
- **보정 라운드**: 5회 실행
- **최종 에러**: 704건 (대부분 build_orders.dart 기인)
- **최종 경고**: 149건

## 에러/경고 추이

| 라운드 | 에러 | 경고 | 주요 변경 |
|--------|------|------|-----------|
| 초기 | 1371 | 124 | - |
| 1차 | 1115 | 122 | B11: 히드라덴 선행건물 추가, B20: 울트라리스크 타이밍 수정 |
| 2차 | 1069 | 132 | B20: 울트라 캐번 이벤트 순서 조정 |
| 3차 | 1077 | 142 | C14: baseProbability 균등화 + conditionStat 추가 (S5,S7,S3,S10) |
| 4차 | 683 | 143 | C14: 비결정적 분기에 decisive 추가 (8개 분기) |
| 5차 | 704 | 149 | 추가 테스트 (코드 변경 없음, 랜덤 변동) |

## PASS 항목

| 코드 | 기준 | 상태 |
|------|------|------|
| A1 | 금지어 | PASS |
| A3 | 플레이스홀더 미치환 | PASS |
| A5 | Owner 불일치 | PASS |
| A6 | Army 범위 (0~200) | PASS |
| A7 | Resource 범위 (0~10000) | PASS |
| B12 | 동일 텍스트 3줄 연속 반복 | PASS |
| B17 | 승자 최종 병력 >= 패자 | PASS |
| B19 | 게임 종료 후 패자 행동 금지 | PASS |
| B20 | 유닛 타이밍 | PASS |
| C13 | 승률 30~70% | PASS |
| C14 | 홈/어웨이 반전 +/-5%p | PASS |
| C15 | 텍스트 다양성 | PASS |

## FAIL 항목 (build_orders.dart 기인)

| 코드 | 건수 | 원인 |
|------|------|------|
| B11 | 578 | build_orders.dart 폴백 이벤트에서 선행건물 없이 유닛 언급 (발키리->아머리, 퀸->퀸즈네스트, 가디언->그레이터 스파이어 등) |
| B21 | 114 | build_orders.dart 폴백 이벤트에서 종족 간 유닛 혼입 (저글링 서라운드, 마린 스플릿, 탱크 시즈모드 등) |
| A2 | 12 | build_orders.dart 폴백 이벤트의 건물명 표기 오류 (퀸즈 네스트, 미사일 터렛) |

## 경고 항목

| 코드 | 건수 | 상태 |
|------|------|------|
| B10 | 126 | 시스템 해설 비율 < 10% (일부 경기) |
| C16 | 22 | 분기 활성화율 4.5% (최소 5%) |
| C17 | 1 | decisive 종료 비율 100% (최대 70%) |

## 수정 내역

### scenario_tvz.dart 변경사항
1. **B11 수정**: 시나리오 2(_tvzMechVsLurker) 오프닝에 히드라덴 건설 이벤트 추가
2. **B20 수정**: 시나리오 11(_tvzMechVsHive) 울트라리스크 캐번 이벤트를 Phase 2로 이동 후 순서 조정
3. **C14 수정**: 비대칭 baseProbability 균등화 (0.9/1.1 -> 1.0/1.0) + conditionStat 추가
   - S3(_tvzCheeseVsStandard): bunker_complete 분기
   - S5(_tvzCheeseVsCheese): bunker_crushes_zerg, lings_destroy_terran 분기
   - S7(_tvz9poolVsStandard): terran_scouted, ling_rush_success 분기
   - S10(_tvzMechVsHive): mech_overwhelm, hive_all_out, rebuild_race 분기
4. **C14 수정**: 비결정적 최종 분기에 decisive: true 추가 (총 8개 분기)
   - S0: last_drop_allin / S1: zerg_breaks_through / S3: zerg_mass_overwhelm
   - S5: lings_destroy_terran / S7: zerg_leverages_lead / S8: zerg_overwhelms
   - S9: defiler_stops_push, massive_trade / S10: hive_all_out, rebuild_race

### build_orders.dart 수정 필요 사항 (리더 보고)
- `퀸즈 네스트` -> `퀸즈네스트` 표기 수정
- `미사일 터렛` -> `터렛` 표기 수정
- B21 종족 유닛 혼입 이벤트 수정 (저글링 서라운드, 마린 스플릿, 오버로드 투하 등)
- B11 선행건물 누락 이벤트 수정 (발키리->아머리, 퀸->퀸즈네스트 등)
