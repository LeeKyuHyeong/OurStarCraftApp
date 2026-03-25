# Daily Dev Mission — OurStarCraftApp

> 생성일: 2026-03-25 | 프로젝트: OurStarCraftApp

---

## 미션: REST API 백엔드 서버 신규 구축 — 매치 시뮬레이션 결과 저장/조회 API

- **영역**: Spring Boot 백엔드 신규 구축 + API 설계
- **난이도**: 중급

### 문제점
현재 OurStarCraftApp은 Flutter 클라이언트에서 Hive 로컬 저장소(`save_repository.dart`)로만 데이터를 관리하며, 서버 사이드가 전혀 없다. `match_simulation_service.dart`의 시뮬레이션 결과(승률, 로그, 빌드 조합별 통계)가 로컬에만 존재하여 유저 간 랭킹, 전적 공유, 통계 대시보드 등 확장이 불가능하다. 백엔드 개발자 포트폴리오로서 서버 레이어가 없는 것은 치명적 약점이다.

### 왜 면접 강점이 되는가
와디즈·빗썸·캐치테이블 모두 "기존 클라이언트 전용 서비스에 API 서버를 설계·구축한 경험"을 높이 평가한다. 도메인 모델(`Player`, `Match`, `Season`)을 JPA 엔티티로 재설계하고 RESTful API를 만드는 과정은 실무 온보딩과 동일한 흐름이다.

### 구현 가이드
1. **프로젝트 초기화**: `backend/` 디렉토리에 Spring Boot 3.x + Gradle 프로젝트 생성. 의존성: `spring-boot-starter-web`, `spring-boot-starter-data-jpa`, `h2`(개발용), `spring-boot-starter-validation`. 패키지 구조는 `com.ourstarcraft.api.{domain,application,presentation,infrastructure}`로 헥사고날 아키텍처 적용.
2. **도메인 모델 설계**: Flutter의 `Player`(능력치 8종), `Match`(7전4선승 `SetResult`), `Season` 모델을 참고하여 JPA `@Entity` 설계. `MatchResult` 엔티티에 `homePlayerId`, `awayPlayerId`, `homeBuildId`, `awayBuildId`, `winnerSide`, `sets`(JSON 컬럼)를 포함. `@Embedded`로 `PlayerStats`(sense, control, attack 등 8개) 분리.
3. **API 구현**: `MatchResultController`에 `POST /api/v1/matches`(결과 저장), `GET /api/v1/matches?matchup=PvT&page=0`(페이징 조회), `GET /api/v1/statistics/winrate?matchup=TvZ`(종족전별 승률 통계) 엔드포인트 구현. `@Valid` + DTO 분리(`MatchResultRequest`/`MatchResultResponse`), 글로벌 예외 핸들러(`@RestControllerAdvice`) 적용.
4. **테스트 & 문서화**: `@DataJpaTest`로 리포지토리 슬라이스 테스트, `@WebMvcTest`로 컨트롤러 테스트 작성. 시나리오별 100경기 결과를 seed 데이터로 활용. Swagger(`springdoc-openapi`) 연동으로 API 문서 자동 생성.

### 면접 질문 3선

**Q1.** 클라이언트 로컬 저장소(Hive)에서 서버 DB로 전환할 때 데이터 정합성을 어떻게 보장했나요? 오프라인 → 온라인 동기화 전략은?
> 핵심 키워드: Optimistic Locking(`@Version`), Idempotency Key

**Q2.** 종족전별 승률 통계 API에서 10만 건 이상의 매치 데이터를 실시간 집계할 때 성능 병목은 어디서 발생하고, 어떻게 해결하시겠습니까?
> 핵심 키워드: Materialized View / 캐싱(`@Cacheable`), CQRS 패턴

**Q3.** API 버전 관리(`/api/v1/`)를 도입한 이유와, 하위 호환성을 깨뜨리지 않으면서 응답 스키마를 변경해야 할 때의 전략은?
> 핵심 키워드: URI Versioning vs Header Versioning, Backward Compatibility

---
## 이전 미션 기록

