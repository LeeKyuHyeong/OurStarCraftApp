# Daily Dev Mission — OurStarCraftApp

> 생성일: 2026-03-31 | 프로젝트: OurStarCraftApp

---

## 미션: Match Simulation Service에 전략 패턴(Strategy Pattern) 적용

- **영역**: 디자인 패턴 / 서비스 계층 리팩토링
- **난이도**: 중급

### 문제점
`MatchSimulationService`(4,127줄)가 빌드 스타일 결정(`_determineBuildStyle`), 승률 계산(`calculateWinRate`), 해설 생성(`_getCommentary`, `_getBuildMatchupCommentary`, `_getOpeningMismatchCommentary` 등 8개 메서드), 경기 종료 판정(`_checkWinCondition`) 등 이질적인 책임을 단일 클래스에 모두 담고 있다. 특히 `BuildStyle`(aggressive/defensive/balanced/cheese) 4가지 분기가 `calculateWinRate` 내부에서 `if-else` 체인으로 반복되며(라인 246~260), 새로운 빌드 스타일 추가 시 여러 메서드를 동시에 수정해야 하는 OCP 위반 구조다.

### 왜 면접 강점이 되는가
와디즈(결제 수단 분기), 빗썸(주문 체결 전략), 캐치테이블(예약 정책 분기) 모두 런타임에 전략을 교체하는 설계가 핵심이다. 4,000줄 God Class를 전략 패턴으로 분해한 경험은 "레거시를 구조적으로 개선할 수 있는 개발자"임을 증명하는 강력한 사례가 된다.

### 구현 가이드
1. **전략 인터페이스 정의** — `lib/domain/services/strategies/build_strategy.dart`에 `abstract class BuildStrategy`를 생성한다. `selectBuild(PlayerStats, GameMap) → BuildType?`, `getStyleBonus(BuildStyle opponent) → double`, `generateCommentary(SimulationState) → String?` 세 메서드를 선언한다.
2. **구체 전략 클래스 분리** — `AggressiveBuildStrategy`, `DefensiveBuildStrategy`, `BalancedBuildStrategy`, `CheeseBuildStrategy` 4개 클래스를 구현한다. `_determineBuildStyle`의 조건 분기(라인 87~108의 attackScore/defenseScore 비교)를 각 클래스의 `matches(PlayerStats)` 판별 로직으로 이동하고, `calculateWinRate` 내부의 `buildBonus` 계산(라인 246: `aggressive vs defensive → 22` 등)을 `getStyleBonus()`로 위임한다.
3. **팩토리 + 컨텍스트 적용** — `BuildStrategyFactory`를 만들어 `PlayerStats` + `Random` 기반으로 적절한 전략 객체를 반환한다. `MatchSimulationService`는 `factory.create(stats)`로 전략을 얻어 `strategy.selectBuild()`를 호출하는 컨텍스트 역할만 수행한다. 기존 `_normalBuildType`, `_findBestCounter` 로직은 해당 전략 내부로 캡슐화한다.
4. **기존 테스트로 회귀 검증** — `flutter test test/tvt_scenarios_100games_test.dart` 등 6개 종족전 테스트를 실행하여 승률 범위(30~70%)와 홈/어웨이 반전 차이(±5%p)가 유지되는지 확인한다. 리팩토링 전후 동일 시드 기반 결과 비교 테스트를 추가한다.

### 면접 질문 3선

**Q1.** 전략 패턴과 단순 if-else 분기의 차이점은 무엇이며, 어떤 상황에서 전략 패턴이 오버엔지니어링이 되는가?
> 핵심 키워드: OCP(개방-폐쇄 원칙), 변경 빈도와 분기 복잡도 기준

**Q2.** 전략 객체를 런타임에 선택하는 방식(Map 레지스트리 vs DI 컨테이너 vs 팩토리)의 트레이드오프를 설명해주세요.
> 핵심 키워드: 의존성 역전(DIP), 테스트 용이성(Mock 주입)

**Q3.** 4,000줄짜리 서비스 클래스를 리팩토링할 때 회귀 버그를 방지하기 위한 전략은 무엇인가요?
> 핵심 키워드: 특성 테스트(Characterization Test), 점진적 추출(Strangler Fig)

---

## 이전 미션 기록

### Spring Boot 매치 기록 API 서버 구축
- **영역**: 백엔드 API 설계 + 도메인 모델링 | **난이도**: 중급

### Spring Boot 게임 데이터 API 서버 신규 구축
- **영역**: Backend API 설계 / 프로젝트 아키텍처 확장 | **난이도**: 중급

---

미션을 진행하시려면 **'오늘 미션 진행해줘'** 라고 말씀해 주세요.
