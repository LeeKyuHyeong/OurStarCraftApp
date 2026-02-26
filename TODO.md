# MyStar 구현 TODO

> 마지막 업데이트: 2026-02-26

---
## ~~시나리오 보정 진행~~ ✅ 완료 (2026-02-26)

### 보정 결과 요약

| 매치업 | 시나리오 수 | n/dir | PASS | 핵심 수정 |
|--------|-----------|-------|------|----------|
| TvT | 16 | 30 | 16/16 | LogOwner.system→분기, army 대칭화 |
| TvZ | 11 | 50 | 11/11 | LogOwner.system→분기, baseProbability 대칭 |
| PvT | 11 | 25 | 10/11 | army ±1 조정, baseProbability 대칭 |
| PvP | 10 | 150 | 10/10 | baseProbability 미세 조정 |
| ZvP | 11 | 25 | 11/11 | LogOwner.system→분기, army 총합 재조정 |
| ZvZ | 9 | 50 | 9/9 | conditionStat 제거, army 패널티 대칭 |

**근본 원인**: `LogOwner.system` + `decisive: true` 이벤트가 `homeArmy >= awayArmy`로 승자 결정 → 항상 홈 유리. 전 매치업에서 분기(branch) 구조로 변환하여 해결.

리포트: `test/output/` (tvt.md, tvz.md, pvt.md, pvp.md, zvp.md, zvz.md)

### PvT 피드백 반영 (9건, 2026-02-26)
- 공격형 빌드에 "확장 서두르네요" 인터랙션 차단
- "시타델 오브 아둔" → "아둔" 용어 수정
- "운영의 시간" → "양측 테크 경쟁이 치열합니다" 수정
- 초패스트 다크 드랍 → 육지 침투로 변경
- 감지도구 없는 상황에서 다크 텍스트 강화
- "질럿 돌진! 마린 라인" → "질럿+드라군 돌진! 탱크 라인" 수정
- "피드백! 상대 에너지 유닛" → "다크 아콘 피드백! 사이언스 베슬" 수정
- "탱크가 대기하고 있었습니다" → "병력이 대기하고 있었습니다" 수정
- "마린 스플릿" → "병력 분산" 수정

## 시나리오 현황

전 종족전 시나리오 스크립트 **68개** 완성.

| 매치업 | 시나리오 수 | 파일 |
|--------|-----------|------|
| TvZ | 11 | `scenario_tvz.dart` |
| PvT | 11 | `scenario_pvt.dart` |
| ZvP | 11 | `scenario_zvp.dart` |
| TvT | 16 | `scenario_tvt.dart` |
| ZvZ | 9 | `scenario_zvz.dart` |
| PvP | 10 | `scenario_pvp.dart` |

### 보정 기준
- 승률: 동일 능력치 기준 30~70% (미러는 45~55%)
- 다양성: 500경기 중 최소 50+ 고유 로그
- 빌드 논리: 선행건물 없이 유닛 생산 금지, 상대 행동 없이 대응 금지
- 홈/어웨이: 반전 시 승률 차이 ±5%p 이내

### 테스트
종족전별 시나리오 검증 테스트 (`test/` 폴더):
- `tvt_scenarios_100games_test.dart`
- `tvz_scenarios_100games_test.dart`
- `pvt_all_scenarios_100games_test.dart`
- `pvp_all_scenarios_100games_test.dart`
- `zvp_scenario_100games_test.dart`
- `zvz_scenario_100games_test.dart`
- `high_sample_bias_test.dart` (고표본 편향 검증, n=150/dir)

---

## ~~고표본 보정 (n=150/dir)~~ ✅ 완료 (2026-02-26)

저표본(n=25~50/dir)에서 >15%p 편향이 관측된 4개 시나리오를 n=150/dir로 재검증 → **전부 노이즈 확인, 수정 불필요**.

| 시나리오 | 저표본 편향 | 고표본 결과 (n=150/dir) | 판정 |
|---------|----------|----------------------|------|
| PvT S9 (mine_triple) | 28%p (n=25) | 153-147 (1.0%p) | PASS |
| ZvZ S8 (12풀 vs 3해처리) | 22%p (n=50) | 157-143 (2.3%p) | PASS |
| ZvZ S5 (4풀 vs 9풀) | 20%p (n=50) | 148-152 (0.7%p) | PASS |
| TvT S12 (wraith_mirror) | 26%p (n=30) | 152-148 (0.7%p) | PASS |

테스트: `test/high_sample_bias_test.dart`

---

## 남은 작업

- [ ] 이벤트 텍스트 감수/세부 보정 (전 종족전)
- [ ] ZvT 저그 홈 시점 전용 스크립트 (현재 TvZ 역방향 매칭으로 커버)

---

## 완료 항목

<details>
<summary>시나리오 스크립트 (68개, 2026-02-26)</summary>

**TvZ (11개)**
1. 바이오 vs 뮤탈 (`tvz_bio_vs_mutal`)
2. 메카닉 vs 럴커/디파일러 (`tvz_mech_vs_lurker`)
3. 치즈 vs 스탠다드 (`tvz_cheese_vs_standard`)
4. 111 밸런스 vs 매크로 (`tvz_111_vs_macro`)
5. 투스타 레이스 vs 뮤탈 (`tvz_wraith_vs_mutal`)
6. 치즈 vs 치즈 (`tvz_cheese_vs_cheese`)
7. 9풀 vs 스탠다드 (`tvz_9pool_vs_standard`)
8. 발키리 바이오닉 vs 뮤탈 (`tvz_valkyrie_vs_mutal`)
9. 팩더블 vs 3해처리 (`tvz_double_vs_3hatch`)
10. 스탠다드 vs 1해처리 올인 (`tvz_standard_vs_1hatch_allin`)
11. 메카닉 vs 하이브 (`tvz_mech_vs_hive`)

**PvT (11개)**
1. 드라군 확장 vs 팩토리 (`pvt_dragoon_expand_vs_factory`)
2. 리버 vs 타이밍 (`pvt_reaver_vs_timing`)
3. 옵저버 vs 벌처 드랍 (`pvt_observer_vs_vulture_drop`)
4. 치즈 vs 스탠다드 (`pvt_cheese_vs_standard`)
5. 캐리어 vs 안티 (`pvt_carrier_vs_anti`)
6. 5게이트 푸시 (`pvt_5gate_push`)
7. 치즈 vs 치즈 (`pvt_cheese_vs_cheese`)
8. 리버 vs BBS (`pvt_reaver_vs_bbs`)
9. 마인 트리플 (`pvt_mine_triple`)
10. 11업8팩 vs 확장 (`pvt_11up8fac_vs_expand`)
11. FD테란 (`pvt_fd_terran`)

**ZvP (11개)**
1. 히드라 vs 포지 (`zvp_hydra_vs_forge`)
2. 뮤탈 vs 포지 (`zvp_mutal_vs_forge`)
3. 9풀 vs 포지 (`zvp_9pool_vs_forge`)
4. 치즈 vs 치즈 (`zvp_cheese_vs_cheese`)
5. 뮤커지 vs 커세어리버 (`zvp_mukerji_vs_corsair_reaver`)
6. 스커지+디파일러 vs 포지더블 (`zvp_scourge_defiler`)
7. 973 히드라 러시 (`zvp_973_hydra_rush`)
8. 스탠다드 vs 2게이트 (`zvp_standard_vs_2gate`)
9. 3해처리 vs 커세어리버 (`zvp_3hatch_vs_corsair_reaver`)
10. 히드라럴커 vs 포지 (`zvp_hydra_lurker_vs_forge`)
11. 치즈 vs 포지 (`zvp_cheese_vs_forge`)

**TvT (16개)**
1. 배럭더블 vs 팩더블 (`tvt_rax_double_vs_fac_double`)
2. BBS vs 더블 (`tvt_bbs_vs_double`)
3. 레이스 vs 배럭더블 (`tvt_wraith_vs_rax_double`)
4. 5팩 vs 배럭더블 (`tvt_5fac_vs_rax_double`)
5. BBS vs 테크 (`tvt_bbs_vs_tech`)
6. 공격적 빌드 대결 (`tvt_aggressive_mirror`)
7. 배럭더블 vs 원팩확장 (`tvt_cc_first_vs_1fac_expand`)
8. 투팩벌처 vs 원팩확장 (`tvt_2fac_vs_1fac_expand`)
9. 원팩원스타 vs 5팩토리 (`tvt_1fac_push_vs_5fac`)
10. BBS 미러 (`tvt_bbs_mirror`)
11. 원팩원스타 미러 (`tvt_1fac_push_mirror`)
12. 투스타 레이스 미러 (`tvt_wraith_mirror`)
13. 5팩토리 미러 (`tvt_5fac_mirror`)
14. 배럭더블 미러 (`tvt_cc_first_mirror`)
15. 투팩벌처 미러 (`tvt_2fac_vulture_mirror`)
16. 원팩확장 미러 (`tvt_1fac_expand_mirror`)

**ZvZ (9개)**
1. 9풀 vs 9오버풀 (`zvz_9pool_vs_9overpool`)
2. 12앞마당 vs 9풀 (`zvz_12hatch_vs_9pool`)
3. 4풀 vs 12앞마당 (`zvz_4pool_vs_12hatch`)
4. 3해처리 미러 (`zvz_3hatch_mirror`)
5. 4풀 vs 9풀 (`zvz_4pool_vs_9pool`)
6. 4풀 vs 3해처리 (`zvz_4pool_vs_3hatch`)
7. 9풀 미러 (`zvz_9pool_mirror`)
8. 12풀 vs 3해처리 (`zvz_12pool_vs_3hatch`)
9. 9오버풀 미러 (`zvz_9overpool_mirror`)

**PvP (10개)**
1. 드라군 넥서스 미러 (`pvp_dragoon_nexus_mirror`)
2. 드라군 vs 노게이트 (`pvp_dragoon_vs_nogate`)
3. 로보 vs 2게이트 드라군 (`pvp_robo_vs_2gate_dragoon`)
4. 다크 vs 드라군 (`pvp_dark_vs_dragoon`)
5. 질럿 러시 (`pvp_zealot_rush`)
6. 다크 vs 질럿 러시 (`pvp_dark_vs_zealot_rush`)
7. 로보 미러 (`pvp_robo_mirror`)
8. 4게이트 vs 멀티 (`pvp_4gate_vs_multi`)
9. 질럿 러시 vs 리버 (`pvp_zealot_rush_vs_reaver`)
10. 다크 미러 (`pvp_dark_mirror`)
</details>

<details>
<summary>빌드 상성 보정 (enums.dart, 2026-02-25)</summary>

| 매치업 | 시나리오 | 이전 승률 | 조정 내용 | 조정 후 승률 |
|--------|---------|----------|----------|------------|
| TvT | BBS vs 더블 | 48~60% | specific 18→5 (합계 28→15) | **46%** |
| TvT | 레이스 vs 배럭더블 | 58~61% | specific 12→0 (합계 22→10) | **54%** |
| PvT | 치즈 vs 스탠다드 | 84% | specific 30→5 (합계 40→15) | **60%** |
| PvT | 캐리어 vs 안티 | 29% | specific -25→-12 (합계 -25→-12) | **44%** |
| PvP | 다크올인 | 82% | specific 15→8 (합계 25→18) | **70%** |
| ZvZ | 4풀 vs 12앞 | 79~82% | specific 20→9 (합계 30→19) | **60%** |
</details>

<details>
<summary>이벤트/멘트 수정 (19개)</summary>

- [x] 확장 멘트 중복 방지 - 양쪽 "확장 서두르네요" 경기당 1회 제한
- [x] PvT '셔틀 리버로 뒷마당 기습' → '본진 기습' 변경
- [x] 모든 종족전 일꾼 타격 이벤트 '라인' 제거 (20곳)
- [x] '스피드' 멘트 전면 정리 → 속업/발업 용어 통일 (12곳)
- [x] '경제 흔들기/우위' 등 → '일꾼 털기/확장기지 우위' (해설 용어로 변경)
- [x] '불굴의 정신력' → '테란의 병력이 줄어들지 않습니다! 막강한 화력!'
- [x] '질럿 스피드 연구' → '질럿 발업 완성'
- [x] PvT '질럿으로 벌처 잡아내고' → '드라군으로 벌처 잡아내고'
- [x] '상대확장견제!' - 상대 확장 이벤트 없이 나오는 문제 차단
- [x] 저글링 교전 - 한쪽만 생산했는데 '서로 저글링 접전' 노출 차단
- [x] 수비 빌드 선택 시 '견제 나갈 타이밍' 멘트 노출 방지
- [x] '히든베이스 발각되지 않았습니다' - 히든베이스 시도 이력 필요
- [x] '더블 커맨드! 경제력 우위로 물량전!' - 후반 어색 → 수비형 빌드 공통 멘트 수정
- [x] PvP 동일 오프닝에서 '공격적/수비적 대결' 멘트 노출 방지
- [x] PvP 포토캐논 이벤트 - 패스트다크 정찰 성공 시에만 노출
- [x] ZvZ 중후반 '스커지로 뮤탈 격추' 이벤트 보장
- [x] 9오버풀 vs 12앞마당 스포닝풀 타이밍 간격 확대
- [x] 방송 해설 용어 1차 정리 (34곳)
- [x] 방송 해설 용어 2차 정리 (23곳)
</details>

<details>
<summary>핵심 시스템 (10개)</summary>

- [x] 데이터 모델 (Player, Team, Match, Season, Item, Equipment, Inventory)
- [x] 상태 관리 (Riverpod)
- [x] 저장/로드 (Hive)
- [x] 경기 시뮬레이션 엔진 (시나리오 스크립트 기반)
- [x] 14경기 + 개인리그 일정 자동 생성
- [x] 선수 성장/하락 시스템
- [x] 레벨(1~20, 경험치) + 커리어(5단계, 시간) 분리 시스템
- [x] 선수 vs 선수 상대 전적 기록
- [x] 개인리그 시드 순위 반영
- [x] PC방 예선 같은 팀 회피 조 편성
</details>

<details>
<summary>화면 (22개)</summary>

타이틀, 감독명 입력, 팀 선택, 맵 추첨, 이적, 메인 메뉴, 로스터 선택, 경기 시뮬레이션, 저장/로드, 선수 정보, 선수 순위, 구단 순위, 연습경기, 시즌 종료, 위너스리그, PC방 예선, 듀얼토너먼트, 조지명식, 본선 토너먼트, 아이템 상점, 행동 관리, 장비 관리
</details>

<details>
<summary>AI/시즌 시스템 (6개)</summary>

- [x] AI 컨디션/특훈/팬미팅/아이템 관리
- [x] 시즌 완료 처리 (레벨업, 은퇴, 신인 생성)
- [x] 플레이오프 UI (3/4위전 → 2/3위전 → 결승전)
</details>

<details>
<summary>부가 기능 (7개)</summary>

- [x] 선수 사진 등록, R 버튼, Preview 모드
- [x] go_router, 반응형 레이아웃 (Responsive.sp)
- [x] 승리 보상 + 대회 상금 시스템
</details>

<details>
<summary>UI 개선 (12개)</summary>

- [x] 시스템 정리 (부상/특수상태 제거, 타팀 전적 기록)
- [x] 로스터 화면 레이아웃 개선
- [x] 로스터 제출 화면 (3열 구조, 맵 순차 매핑)
- [x] 듀얼토너먼트 화면 (종족 표시, 아마추어 지원)
- [x] 경기 결과 화면 (세트별 결과, ACE 표시)
- [x] PC방 예선 조 편성 (24개조 + 아마추어 채움)
- [x] 매치 시뮬레이션 개선 (에이스결정전, NEXT 클릭)
- [x] 구단 순위 화면 (UI 통일, 색상 추가)
- [x] 선수 정보 화면 (8각형 차트, 전적 탭)
- [x] 조지명식 화면 (가로 배치, 통과자 박스)
- [x] 행동력 화면 (전체 조회, 일괄 진행)
- [x] 맵 추첨 화면 (썸네일, 정보 박스)
</details>

---

## 게임 규칙

| 항목 | 내용 |
|------|------|
| 로스터 | 최소 10명 |
| 경기 형식 | 7전 4선승제 |
| 능력치 | 센스/컨트롤/공격력/견제/전략/물량/수비력/정찰 (8개) |
| 등급 | F- ~ SSS (25단계) |
| 레벨 | 1~20 (경험치 기반, 레벨업 시 능력치 상승) |
| 커리어 | 신인→상승세→전성기→베테랑→노장 (시간 기반) |
| 컨디션 | 내부 0~110, 표시 0~100 |
| 승률 계산 | 능력치 50당 1% (최대 ±40%) + 레벨당 ±2% |
| 승패 조건 | 병력 4:1 격차 또는 200줄 강제 판정 |
| 보상 | 승리 +5만원, 프로리그 우승 150만/준우승 70만, 개인리그 우승 80만/준우승 40만 |

---

## 종족전별 경기 흐름 레퍼런스

> 시나리오 작성 시 참고한 실제 프로게이머 경기 분석. 새 시나리오 추가/보정 시 참조.

<details>
<summary>TvT</summary>

- **BBS vs 노배럭더블**: BBS 쪽이 센터배럭 마린3 + 본진마린2 + SCV를 끌고 앞마당 벙커링 공격. 수비 측이 SCV 정찰 성공 시 마린 끊기 → 후반 유리. 정찰 실패 시 벙커링부터 공격 유리.

- **배럭더블 vs 팩더블**: 둘 다 밸런스형. 팩더블이 벌처 먼저 나오는 이점, 배럭더블은 병력 증가가 빠름. 벌처싸움이 TvT 메인이벤트. 크게 밀리면 패배 직결, 비등하면 시즈탱크 → 라인 유지 → 드랍십 운영. 후반은 시즈탱크+골리앗+드랍십으로 확장기지/라인 타격하며 집중력 싸움. 스타포트를 섞어 레이스 운용도 가능 → 상대는 아머리+골리앗 대응 필요.
</details>

<details>
<summary>ZvZ</summary>

- **9풀 vs 9오버풀**: 둘 다 공격적, 9오버풀 약 우위(드론 +1). 저글링 발업 타이밍 차이가 관건. 본진 드론까지 타격하면 승리 직결. 스파이어 전환 시점이 위험 (병력 빈 시간). 뮤탈전은 스커지+스포어로 수비하며 드론 견제 승부.

- **12앞마당 vs 9풀**: ZvZ에서 12앞은 수비형. 발업 저글링이 드론 초토화/앞마당 파괴 시 9풀 승리. 노발업 저글링+드론+성큰으로 막으면 12앞 승률 수직상승. 이후 12앞이 뮤탈+스커지에서 차이나며 대부분 승리.
</details>

<details>
<summary>PvP</summary>

- **원게이트드라군넥서스 vs 노게이트넥서스**: 밸런스 vs 수비형. 초반 질럿→드라군으로 괴롭히기 vs 프로브+질럿 협공 수비. 수비 성공 시 게이트 확장 속도 차이로 노게이트 유리. 중후반은 드라군+셔틀리버 컨트롤 싸움 + 하이템플러 스톰.

- **원게이트로보 vs 투게이트드라군**: 로보 측은 셔틀+리버 합류 전까지 버티기, 투게이트 측은 드라군 물량으로 빠른 교전 유도. 셔틀 폭사가 가장 중요한 이벤트. 교전 결착 안 나면 앞마당 확장 후 견제+컨트롤 승부.
</details>

<details>
<summary>TvZ</summary>

- **배럭더블 vs 12앞마당**: 가장 흔한 TvZ. 이후 T는 발키리+바이오닉/5배럭/메카닉 등, Z는 2~3해처리 뮤탈/럴커 등 무궁무진. 초반 소수 마린vs저글링 교환 중요. 중반은 뮤탈 견제vs터렛+엔베 수비. 테란 한방병력(마린메딕 3부대+시즈탱크3+사이언스베슬) vs 저그 순환병력(저글링+뮤탈+럴커). T:Z의 분수령은 저그 3~4가스 유지 여부.

- **BBS vs 12앞마당**: 3연벙 벙커링 → 앞마당 파괴 시도. 성큰 vs 벙커 완성 경쟁. 정찰 성공 시 드론으로 센터배럭 끊기 가능.
</details>

<details>
<summary>ZvP</summary>

- **12앞마당 vs 포지더블**: 국룰. 저그 히드라 압박 vs 프로토스 질럿+캐논 라인. 히드라에 앞마당 밀리면 저그 승리. 커세어로 오버로드 사냥 → 하이템플러+스톰 완성 시 방어 성공. 이후 질럿+드라군+하이템플러 한방병력 vs 디파일러+울트라+저글링 순환. 프로토스 한방병력 괴멸 = 저그 승리, 저그 확장기지 파괴 = 프로토스 승리.

- **9풀 vs 포지더블**: 캐논 완성 전 6저글링 도착. 프로브로 방어하며 캐논+게이트 완성까지 버티기. 본진 침투 시 프로브 피해 심각.
</details>

<details>
<summary>PvT</summary>

- **사업넥 vs 팩더블**: 국룰. T는 마인/시즈탱크/벌처드랍/5팩 타이밍 등 분기. P는 로보틱스 옵저버/3게이트/패스트아비터 등 분기.
</details>
