# Daily Dev Mission — OurStarCraftApp

> 생성일: 2026-04-01 | 프로젝트: OurStarCraftApp

---

## 미션: SaveRepository에서 비즈니스 로직 분리 + 도메인 예외 계층 설계

- **영역**: 클린 아키텍처 / 계층 분리 / 예외 처리 전략
- **난이도**: 중급

### 문제점
`SaveRepository`(647줄)가 순수 영속성 계층임에도 `createNewGame()`, `_createFirstSeason()`, `_createProleagueSchedule()` 같은 도메인 로직을 직접 포함하고 있어 계층 간 책임이 혼재되어 있다. 또한 서비스 계층(`PlayoffService`, `IndividualLeagueService`)이 `ArgumentError` 같은 원시 예외를 던지고 있어 호출자 측에서 도메인 오류와 시스템 오류를 구분할 수 없다. Repository 인터페이스 없이 Hive에 직접 의존하고 있어 저장소 교체나 단위 테스트가 불가능하다.

### 왜 면접 강점이 되는가
와디즈·빗썸 같은 핀테크 스타트업은 결제·정산 도메인에서 계층 분리와 명확한 예외 전략이 필수다. "Repository에서 도메인 로직을 왜 분리했는지", "커스텀 예외 계층을 어떻게 설계했는지"를 구체적 코드와 함께 설명하면 아키텍처 이해도를 효과적으로 어필할 수 있다.

### 구현 가이드
1. **IGameRepository 인터페이스 추출** — `save_repository.dart`에서 `loadGame()`, `saveGame()`, `deleteSlot()` 등 순수 CRUD 시그니처만 추상 클래스 `IGameRepository`로 분리하고, `SaveRepository`가 이를 구현하도록 변경. Riverpod Provider에서도 인터페이스 타입으로 주입.
2. **GameInitializationService 도메인 서비스 생성** — `SaveRepository.createNewGame()` 내부의 `_createFirstSeason()`, `_createProleagueSchedule()`, 선수/팀 초기화 로직을 `lib/domain/services/game_initialization_service.dart`로 이동. Repository는 생성된 `SaveData`를 받아 저장만 수행.
3. **도메인 예외 계층 설계** — `lib/domain/models/exceptions.dart`에 `DomainException(abstract)` → `InvalidRosterException`, `InsufficientFundsException`, `SeasonPhaseException` 등 커스텀 예외 클래스를 정의. `PlayoffService`의 `ArgumentError`를 `SeasonPhaseException`으로 교체.
4. **Provider 계층 예외 매핑** — `GameStateNotifier`에서 도메인 예외를 catch하여 `GameState.error` 필드에 사용자 친화적 메시지로 변환하는 에러 핸들링 레이어 추가. 시스템 예외(`HiveError` 등)와 도메인 예외의 처리 경로를 분리.

### 면접 질문 3선

**Q1.** Repository 계층에 비즈니스 로직이 섞이면 어떤 문제가 발생하고, 이를 어떻게 해결하셨나요?
> 핵심 키워드: 단일 책임 원칙(SRP), 의존성 역전 원칙(DIP)

**Q2.** 커스텀 예외 계층을 설계할 때 checked vs unchecked 전략을 어떻게 결정하셨나요?
> 핵심 키워드: 복구 가능성(recoverable), 계층별 예외 변환(exception translation)

**Q3.** 저장소 구현체를 Hive에서 Room이나 Remote API로 교체해야 한다면 어떤 설계가 필요한가요?
> 핵심 키워드: 인터페이스 분리, 어댑터 패턴(Adapter Pattern)

---
## 이전 미션 기록

## 미션: 경기 시뮬레이션 이벤트 시스템에 Observer 패턴 + Event-Driven Architecture 적용

- **영역**: 이벤트 기반 아키텍처 / 디커플링 설계
- **난이도**: 중급

### 문제점
현재 `MatchSimulationService`는 `Stream<SimulationState>`로 경기 로그를 UI에 직접 전달하지만, 병력 변동·자원 변동·승패 판정·해설 삽입 등 부가 로직이 시뮬레이션 메인 루프에 결합되어 있다. 새로운 관심사(통계 수집, 리플레이 저장, 업적 달성 판정 등)를 추가하려면 서비스 코드를 직접 수정해야 하므로 OCP(개방-폐쇄 원칙)를 위반하며, 테스트 시에도 전체 시뮬레이션을 돌려야만 개별 로직을 검증할 수 있다.

### 왜 면접 강점이 되는가
와디즈·빗썸 같은 핀테크/커머스 서비스는 결제·주문·정산 등 핵심 플로우에 이벤트 기반 아키텍처(Kafka, Spring ApplicationEvent)를 적극 활용한다. Observer 패턴으로 도메인 이벤트를 발행-구독 구조로 분리한 경험은 "확장 가능한 시스템을 설계할 줄 아는 개발자"임을 직접 증명한다.

### 구현 가이드
1. **도메인 이벤트 정의** — `MatchEvent` 추상 클래스를 만들고, `ArmyChangedEvent`, `ResourceChangedEvent`, `PhaseTransitionEvent`, `MatchEndedEvent` 등 구체 이벤트를 생성한다. 각 이벤트는 `matchId`, `timestamp`, `payload`를 포함하도록 설계한다. (Java라면 sealed interface + record 활용)
2. **EventPublisher 인터페이스 분리** — `MatchEventPublisher`를 정의하고, `publish(MatchEvent event)` 메서드를 둔다. `MatchSimulationService`는 이 Publisher에만 의존하게 하여 구체 구독자를 알지 못하도록 한다. Spring 환경이라면 `ApplicationEventPublisher`를 래핑하는 어댑터로 구현한다.
3. **EventListener 구현체 작성** — `StatisticsCollector`(경기 통계 집계), `ReplayRecorder`(리플레이 데이터 저장), `AchievementChecker`(업적 조건 판정) 등 3개 이상의 리스너를 만든다. 각 리스너는 `@EventListener` 또는 `Observer` 인터페이스를 구현하며, 자신이 관심 있는 이벤트 타입만 처리한다.
4. **단위 테스트로 검증** — 각 리스너를 독립적으로 테스트한다. Mock `MatchEvent`를 발행하여 `StatisticsCollector`가 올바른 집계를 하는지, `AchievementChecker`가 조건 충족 시 정확히 트리거되는지 검증한다. 시뮬레이션 전체를 실행하지 않고도 개별 관심사를 테스트할 수 있음을 보여준다.

### 면접 질문 3선

**Q1.** Observer 패턴과 Pub/Sub 패턴의 차이점은 무엇이며, 각각 어떤 상황에 적합한가요?
> 핵심 키워드: 직접 참조 vs 메시지 브로커, 동기/비동기 결합도

**Q2.** Spring의 `@EventListener`에서 `@TransactionalEventListener(phase = AFTER_COMMIT)`를 사용해야 하는 이유와 사용하지 않았을 때 발생할 수 있는 문제는?
> 핵심 키워드: 트랜잭션 경계, 롤백 시 이벤트 소실, eventual consistency

**Q3.** 이벤트 리스너가 많아지면 처리 순서나 실패 전파를 어떻게 관리하시겠습니까? 실무에서 이벤트 유실을 방지하는 전략은?
> 핵심 키워드: Outbox 패턴, 멱등성(idempotency), Dead Letter Queue

---
## 이전 미션 기록

## 미션: 이벤트 기반 경기 로그 시스템에 CQRS 패턴 적용

- **영역**: 이벤트 소싱 / CQRS 아키텍처 설계
- **난이도**: 고급

### 문제점
`MatchSimulationService`가 `Stream<SimulationState>`로 경기 로그를 생성하면서 동시에 `BattleLogEntry`의 읽기/쓰기를 단일 모델로 처리하고 있다. 경기 진행 중 병력/자원 변동(Write)과 UI 로그 표시(Read)가 같은 `SimulationState` 객체를 공유하여, 통계 집계·리플레이·로그 검색 같은 조회 요구사항이 추가될수록 모델이 비대해지고 성능 병목이 발생할 수 있다.

### 왜 면접 강점이 되는가
와디즈(투자 이벤트 로그), 빗썸(거래 체결 이벤트), 캐치테이블(예약 상태 변경) 모두 **이벤트 스트림 기반의 쓰기/읽기 분리**가 핵심 아키텍처 과제다. CQRS + Event Sourcing을 실제 도메인에 적용한 경험은 시니어급 설계 역량을 증명한다.

### 구현 가이드
1. **Command 모델 분리** — `SimulationCommand` 인터페이스를 정의하고, `UpdateArmyCommand`, `UpdateResourceCommand`, `ApplyDecisiveCommand` 등 경기 상태 변경 명령을 Value Object로 추출한다. `MatchSimulationService.simulateMatchWithLog()`의 병력/자원 변동 로직을 Command Handler가 처리하도록 위임한다.
2. **Event Store 계층 구현** — `MatchEvent`(eventType, timestamp, payload) 도메인 이벤트를 정의하고, `MatchEventStore` 클래스에서 `BattleLogEntry` 생성 시점마다 이벤트를 append-only 리스트에 저장한다. Hive의 새 Box(`matchEventBox`, TypeId 23)를 활용하여 영속화한다.
3. **Query 모델(Read Projection) 구현** — `MatchReadModel` 클래스를 만들어 `MatchEventStore`의 이벤트 스트림을 구독하고, UI 표시용 `BattleLogView`(텍스트 + owner), 통계용 `MatchStatsSummary`(승률, 병력 추이), 리플레이용 `ReplayTimeline`(타임스탬프 기반 재생 목록)으로 각각 프로젝션한다.
4. **Eventual Consistency 처리 및 테스트** — Command 처리 → Event 발행 → Read Model 갱신 사이의 비동기 흐름을 `StreamController`로 연결하고, 기존 `test/tvt_scenarios_100games_test.dart` 등에서 동일 시나리오를 CQRS 경로로 실행하여 결과 일치 여부를 검증한다.

### 면접 질문 3선

**Q1.** CQRS에서 Command와 Query를 분리하면 어떤 트레이드오프가 발생하며, Eventual Consistency 문제를 어떻게 해결했나요?
> 핵심 키워드: Eventual Consistency, Read Projection 지연

**Q2.** Event Sourcing에서 이벤트 스키마가 변경될 때 기존 이벤트와의 호환성은 어떻게 보장하나요?
> 핵심 키워드: Event Upcasting, Schema Versioning

**Q3.** Write 모델과 Read 모델의 데이터 정합성을 모니터링하기 위해 어떤 전략을 사용할 수 있나요?
> 핵심 키워드: Compensating Event, Reconciliation Job

---
## 이전 미션 기록

## 미션: Match Simulation의 Stream 기반 로그를 Event Sourcing 패턴으로 재설계

- **영역**: Event-Driven Architecture / 도메인 이벤트 설계
- **난이도**: 고급

### 문제점
`MatchSimulationService.simulateMatchWithLog()`는 `Stream<SimulationState>`로 실시간 경기 상태를 방출하지만, 각 이벤트가 단순 로그 텍스트(`BattleLogEntry`)에 불과하여 이벤트 재생(replay), 상태 복원, 감사 추적이 불가능하다. `SimulationState`가 병력/자원/로그를 뭉뚱그려 관리하므로, 특정 시점의 상태 스냅샷을 만들거나 "왜 이 선수가 졌는가"를 역추적할 수 없다. 이는 실제 서비스에서 주문/결제/매칭 같은 핵심 도메인의 상태 변화를 추적 불가능하게 만드는 안티패턴과 동일하다.

### 왜 면접 강점이 되는가
빗썸(거래 이력 추적), 와디즈(펀딩 상태 변화), 캐치테이블(예약 상태 머신) 모두 도메인 이벤트의 불변 기록과 상태 복원이 핵심이다. Event Sourcing을 직접 설계해본 경험은 "CQRS/이벤트 드리븐 아키텍처를 실무에 적용할 수 있는가"라는 시니어 레벨 질문에 구체적으로 답할 수 있게 해준다.

### 구현 가이드
1. **도메인 이벤트 정의** — `BattleLogEntry`를 대체하는 `MatchEvent` sealed class 계층 설계. `ArmyChangeEvent`, `ResourceChangeEvent`, `PhaseTransitionEvent`, `DecisiveEvent` 등 각 이벤트가 `timestamp`, `sequenceNumber`, `aggregateId(matchId)`를 가지도록 구성. Java라면 `sealed interface MatchEvent permits ...` 패턴 적용.
2. **Event Store 구현** — `MatchEventStore` 클래스를 만들어 이벤트 append-only 저장소 역할 수행. `append(MatchEvent)`, `getEvents(matchId)`, `getEventsAfter(sequenceNumber)` 메서드 제공. Hive 기반이지만, 인터페이스는 `EventStore<T>`로 추상화하여 향후 Kafka/RDB 전환 가능하게 설계.
3. **상태 복원(Projection)** — `SimulationState`를 이벤트 리스트로부터 재구성하는 `MatchProjection.rebuild(List<MatchEvent>)` 구현. 임의 시점까지의 이벤트만 적용하면 해당 시점의 정확한 상태 스냅샷 생성 가능. 스냅샷 캐싱으로 매번 전체 리플레이 방지.
4. **기존 Stream과 통합** — `simulateMatchWithLog()`가 기존 `Stream<SimulationState>` 대신 `Stream<MatchEvent>`를 방출하고, UI 레이어의 Riverpod Provider에서 Projection을 통해 화면 상태로 변환. `GameStateNotifier`에서 경기 종료 시 이벤트 스트림 전체를 `MatchEventStore`에 persist.

### 면접 질문 3선

**Q1.** Event Sourcing에서 이벤트 스키마가 변경되면 기존 저장된 이벤트는 어떻게 처리하나요?
> 핵심 키워드: Upcasting, 이벤트 버저닝(Event Versioning)

**Q2.** Event Store의 이벤트가 수백만 건으로 늘어날 때 상태 복원 성능을 어떻게 보장하나요?
> 핵심 키워드: Snapshot, Projection 최적화

**Q3.** CQRS 없이 Event Sourcing만 적용할 때의 트레이드오프와, 읽기 모델 분리가 필요해지는 시점은 언제인가요?
> 핵심 키워드: Read Model 분리 기준, Eventual Consistency

---
## 이전 미션 기록

## 미션: 이벤트 기반 경기 로그 시스템에 CQRS 패턴 적용

- **영역**: 이벤트 소싱 / CQRS 아키텍처 설계
- **난이도**: 고급

### 문제점
현재 `MatchSimulationService`는 경기 시뮬레이션(Command)과 로그 조회/통계 생성(Query)이 하나의 서비스에 혼재되어 있다. `BattleLogEntry`가 실시간 스트림으로 소비되고 버려지는 구조라 경기 리플레이, 통계 집계, 이벤트 추적 등 읽기 요구사항 확장이 어렵다. 쓰기 모델과 읽기 모델이 분리되지 않아 성능 최적화와 독립적 스케일링이 불가능하다.

### 왜 면접 강점이 되는가
빗썸(거래 이벤트), 와디즈(펀딩 상태 변경), 캐치테이블(예약 이벤트) 등 이벤트 드리븐 아키텍처를 핵심으로 쓰는 스타트업에서 CQRS/Event Sourcing 경험은 시니어급 설계 역량을 증명하는 강력한 차별점이다.

### 구현 가이드
1. **Command 모델 분리** — `MatchCommandService` 클래스를 생성하고, 시뮬레이션 실행(`simulateMatch`)과 상태 변경 로직만 담당하도록 추출한다. 각 상태 변경을 `MatchEvent`(도메인 이벤트 클래스: `GameStarted`, `ArmyClashed`, `ResourceChanged`, `GameEnded`)로 발행하는 구조로 변환한다.
2. **Event Store 설계** — `MatchEventStore` 클래스를 만들어 `MatchEvent` 리스트를 경기 ID(`matchId`) 기준으로 저장한다. Hive를 활용해 `@HiveType(typeId: 23)` 이벤트 모델을 정의하고, 이벤트 append-only 저장소 패턴을 적용한다. 이벤트에는 `timestamp`, `eventType`, `payload`, `aggregateId`를 포함한다.
3. **Query 모델 분리** — `MatchQueryService` 클래스를 생성하여 읽기 전용 책임(경기 리플레이 조회, 선수별 통계 집계, 승률 계산)을 담당한다. Event Store의 이벤트를 Projection하여 `MatchReadModel`(비정규화된 조회용 DTO)을 구성하는 `MatchProjection` 클래스를 구현한다.
4. **EventBus 구현** — `MatchEventBus`를 Dart의 `StreamController`로 구현하여 Command 측에서 발행한 이벤트를 Query 측 Projection이 구독하는 비동기 파이프라인을 완성한다. Riverpod Provider로 DI 연결하고, 이벤트 핸들러 등록/해제 생명주기를 관리한다.

### 면접 질문 3선

**Q1.** CQRS에서 Command 모델과 Query 모델을 분리했을 때 데이터 정합성(Eventual Consistency)은 어떻게 보장하나요?
> 핵심 키워드: Eventual Consistency, Projection 동기화

**Q2.** Event Sourcing에서 이벤트 스키마가 변경되면 기존 이벤트는 어떻게 처리하나요? (이벤트 버저닝)
> 핵심 키워드: Upcasting, 스키마 진화(Schema Evolution)

**Q3.** CQRS 도입이 오버엔지니어링이 되는 경우는 언제이고, 이 프로젝트에서 CQRS를 선택한 근거는 무엇인가요?
> 핵심 키워드: 읽기/쓰기 비대칭, 트레이드오프 분석

---
## 이전 미션 기록

## 미션: 이벤트 기반 경기 로그 시스템에 CQRS 패턴 적용

- **영역**: 이벤트 소싱 / CQRS 아키텍처 설계
- **난이도**: 고급

### 문제점
현재 `match_simulation_service.dart`의 `simulateMatchWithLog()`는 경기 시뮬레이션(Command)과 로그 조회/통계 생성(Query)이 하나의 Stream 파이프라인에 결합되어 있다. `BattleLogEntry`가 생성과 동시에 소비되며, 경기 후 통계 분석(`test/output/` 리포트 생성)은 별도 테스트 코드에서 로그를 다시 파싱하는 구조다. 이는 쓰기 모델과 읽기 모델의 책임이 분리되지 않아 확장성과 테스트 용이성을 떨어뜨린다.

### 왜 면접 강점이 되는가
빗썸 같은 핀테크에서는 주문 체결(Command)과 잔고 조회(Query)를 분리하는 CQRS가 핵심 아키텍처이며, 와디즈·캐치테이블도 예약/결제 이벤트를 이벤트 소싱으로 처리하는 추세다. 실제 도메인(경기 시뮬레이션)에 CQRS를 적용한 경험은 "패턴을 아는 수준"이 아니라 "트레이드오프를 이해하고 적용한 수준"을 증명한다.

### 구현 가이드
1. **Event Store 설계** — `MatchEvent` 도메인 이벤트 클래스를 정의한다. `BattleLogEntry`를 래핑하여 `eventId`, `matchId`, `timestamp`, `eventType`(ARMY_CHANGE, RESOURCE_CHANGE, DECISIVE 등), `payload`를 포함하는 불변 이벤트 객체로 만든다. Java 관점에서 `sealed interface MatchEvent permits ArmyEvent, ResourceEvent, DecisiveEvent` 구조를 설계한다.
2. **Command 측 분리** — `MatchCommandService`를 만들어 시뮬레이션 실행만 담당하게 한다. `SimulationState` 변경 로직을 이벤트 발행(`MatchEvent` 리스트 append)으로 전환하고, 이벤트 스토어(`MatchEventStore`)에 순서 보장하여 저장한다. Hive의 `TypeId: 23`을 `MatchEvent`에 할당한다.
3. **Query 측 분리** — `MatchQueryService`를 만들어 이벤트 스토어를 구독(replay)하여 읽기 전용 뷰모델(`MatchSummaryView`, `MatchStatisticsView`)을 구성한다. 기존 `test/output/` 리포트 생성 로직을 이 Query 서비스로 이관하여, 이벤트 리플레이만으로 통계를 재생성할 수 있게 한다.
4. **Eventual Consistency 처리** — Command 완료 후 Query 뷰가 갱신되기까지의 지연을 `StreamController`의 `onDone` 콜백으로 동기화한다. UI(`match_screen`)에서는 Query 뷰모델만 구독하도록 변경하고, 로딩 상태를 표시하여 최종 일관성(Eventual Consistency)을 사용자에게 자연스럽게 노출한다.

### 면접 질문 3선

**Q1.** CQRS를 적용할 때 Command 모델과 Query 모델의 데이터 저장소를 분리해야 하는 경우와 같은 저장소를 써도 되는 경우를 각각 설명해주세요.
> 핵심 키워드: 읽기/쓰기 부하 비대칭, Eventual Consistency vs Strong Consistency

**Q2.** 이벤트 소싱에서 이벤트 스키마가 변경되었을 때(예: 필드 추가/삭제) 기존 이벤트를 어떻게 처리하시겠습니까?
> 핵심 키워드: 이벤트 업캐스팅(Upcasting), 스키마 버전 관리

**Q3.** CQRS 도입 시 발생하는 Eventual Consistency 문제를 사용자 경험 측면에서 어떻게 해결하셨나요?
> 핵심 키워드: Optimistic UI Update, Saga 패턴

---
## 이전 미션 기록

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
