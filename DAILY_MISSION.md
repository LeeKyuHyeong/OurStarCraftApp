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

### 경기 시뮬레이션 이벤트 시스템에 Observer 패턴 + Event-Driven Architecture 적용
- **영역**: 이벤트 기반 아키텍처 / 디커플링 설계 | **난이도**: 중급

### 이벤트 기반 경기 로그 시스템에 CQRS 패턴 적용
- **영역**: 이벤트 소싱 / CQRS 아키텍처 설계 | **난이도**: 고급

### Match Simulation의 Stream 기반 로그를 Event Sourcing 패턴으로 재설계
- **영역**: Event-Driven Architecture / 도메인 이벤트 설계 | **난이도**: 고급

### Match Simulation Service에 전략 패턴(Strategy Pattern) 적용
- **영역**: 디자인 패턴 / 서비스 계층 리팩토링 | **난이도**: 중급

### Spring Boot 매치 기록 API 서버 구축
- **영역**: 백엔드 API 설계 + 도메인 모델링 | **난이도**: 중급

### Spring Boot 게임 데이터 API 서버 신규 구축
- **영역**: Backend API 설계 / 프로젝트 아키텍처 확장 | **난이도**: 중급

---

미션을 진행하시려면 **'오늘 미션 진행해줘'** 라고 말씀해 주세요.
