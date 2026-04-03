# Daily Dev Mission — OurStarCraftApp

> 생성일: 2026-04-02 | 프로젝트: OurStarCraftApp

---

## 미션: GameStateNotifier 상태 변이를 Unit of Work 패턴으로 트랜잭션 관리

- **영역**: 트랜잭션 관리 / 데이터 일관성 / Unit of Work 패턴
- **난이도**: 중급

### 문제점
`GameStateNotifier`의 게임 상태 변경 메서드들(`updatePlayer`, `save`, `startNewGame` 등)은 여러 엔티티를 순차적으로 수정하면서 중간에 실패하면 일부만 반영되는 부분 업데이트 문제가 발생할 수 있다. 예를 들어 시즌 진행 중 선수 능력치 변경 + 팀 자원 차감 + 인벤토리 업데이트가 하나의 논리적 트랜잭션이지만, Hive 저장 시점이 분산되어 데이터 정합성을 보장하지 못한다. `SaveRepository`와 `GameStateNotifier` 사이에 변경 추적 및 일괄 커밋/롤백 메커니즘이 없어 장애 복원력이 취약하다.

### 왜 면접 강점이 되는가
와디즈(투자), 빗썸(거래) 같은 금융 도메인 스타트업에서 "복수 엔티티의 원자적 상태 변경"은 핵심 과제이며, Unit of Work 패턴으로 트랜잭션 경계를 설계한 경험은 Spring의 `@Transactional` 이면의 원리를 이해하고 있음을 증명한다.

### 구현 가이드
1. **UnitOfWork 클래스 설계** — `Map<String, EntityChange>` 형태로 변경된 엔티티(Player, Team, Season, Inventory)를 추적하는 `UnitOfWork` 클래스를 만든다. `registerDirty()`, `registerNew()`, `registerDeleted()` 메서드로 변경 사항을 등록하고, 실제 저장은 하지 않는다.
2. **commit/rollback 메커니즘 구현** — `commit()` 호출 시 `SaveRepository`를 통해 모든 변경을 일괄 저장하고, 중간 실패 시 `rollback()`으로 변경 전 스냅샷(`GameState` 복사본)을 복원한다. Java 백엔드 관점에서 Spring `TransactionSynchronizationManager`와 동일한 역할임을 문서화한다.
3. **GameStateNotifier 리팩토링** — 기존 `updatePlayer()`, 시즌 진행 등 복합 로직에서 직접 `state = state.copyWith(...)` 후 `save()`하는 패턴을 `unitOfWork.registerDirty(player)` → 로직 완료 후 `unitOfWork.commit()`으로 전환한다.
4. **낙관적 잠금(Optimistic Lock) 추가** — `SaveData`에 `version` 필드를 추가하고, `commit()` 시 버전 불일치 감지 로직을 넣어 동시 저장 충돌을 방지한다. JPA의 `@Version` 어노테이션과 동일한 개념임을 포트폴리오에 명시한다.

### 면접 질문 3선

**Q1.** Unit of Work 패턴과 Repository 패턴의 관계를 설명하고, Spring에서 `@Transactional`이 내부적으로 어떻게 Unit of Work 역할을 하는지 설명해주세요.
> 핵심 키워드: 변경 추적(Dirty Checking), 영속성 컨텍스트(Persistence Context)

**Q2.** 트랜잭션 중간에 외부 API 호출이 포함된 경우, 롤백 범위를 어떻게 설계하시겠습니까?
> 핵심 키워드: 보상 트랜잭션(Compensating Transaction), Saga 패턴

**Q3.** 낙관적 잠금과 비관적 잠금의 차이를 설명하고, 각각 어떤 상황에서 선택하는지 실제 사례와 함께 말씀해주세요.
> 핵심 키워드: `@Version` vs `SELECT FOR UPDATE`, 충돌 빈도 기반 선택

---

## 다음 할 일: 시나리오 리팩토링 후속 작업

> 2026-04-01 시나리오 오프닝 매칭 + 트랜지션 분기 리팩토링 완료 후

### 완료된 작업
- ScriptBranch에 `conditionHomeBuildIds`/`conditionAwayBuildIds` 추가
- TvZ: 11개 → 7개 시나리오 (커버리지 38% → 83%)
- PvT: 11개 → 7개 시나리오 (트랜지션 분기 통합)
- ZvP: 11개 → 6개 시나리오 (Z측 트랜지션 분기)

### 남은 작업
1. **보정 루프 실행** — `flutter test test/{tvz,pvt,zvp}/calibration_test.dart` → 새 시나리오 밸런스 검증
2. **TvZ standard_vs_standard.dart 집중 검증** — 가장 큰 통합 시나리오, 승률/다양성 확인 필요
3. **미러 종족전 현행 유지** — TvT/PvP/ZvZ는 자체완결 빌드라 변경 불필요, 추후 필요시 보강

---

## 이전 미션 기록

- MatchSimulationService 동시성 제어 + 캐싱 전략 설계 (동시성 / 캐싱 아키텍처)
- GameState 동시성 제어 + 낙관적 락킹 전략 설계 (동시성 / 낙관적 락킹)
- BuildOrderData 캐싱 계층 설계 + Cache Aside 패턴 적용 (캐싱 전략 / 성능 최적화)
- MatchSimulationService 동시성 제어 + 비동기 파이프라인 설계 (동시성 / 비동기 처리)
- SaveRepository에서 비즈니스 로직 분리 + 도메인 예외 계층 설계 (클린 아키텍처 / 계층 분리)
- 경기 시뮬레이션 이벤트 시스템에 Observer 패턴 + Event-Driven Architecture 적용
- 이벤트 기반 경기 로그 시스템에 CQRS 패턴 적용
- Match Simulation의 Stream 기반 로그를 Event Sourcing 패턴으로 재설계
- Match Simulation Service에 전략 패턴(Strategy Pattern) 적용
- Spring Boot 매치 기록 API 서버 구축
- Spring Boot 게임 데이터 API 서버 신규 구축

---

미션을 진행하시려면 **'오늘 미션 진행해줘'** 라고 말씀해 주세요.
