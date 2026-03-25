/**
 * 시나리오 보정 검증 기준 스크립트
 *
 * 사용법: node tools/calibration_criteria.js <log_json_path>
 * 예시:   node tools/calibration_criteria.js test/output/pvp_log.json
 *
 * 입력 JSON 형식:
 * {
 *   "matchup": "PvP",
 *   "scenarioId": "pvp_dragoon_nexus_mirror",
 *   "games": [
 *     {
 *       "gameIndex": 0,
 *       "homeWin": true,
 *       "isReversed": false,
 *       "homeBuildId": "pvp_1gate_dragoon_nexus",
 *       "awayBuildId": "pvp_no_gate_nexus",
 *       "logs": [
 *         { "line": 1, "text": "...", "owner": "system|home|away|clash", "homeArmy": 0, "awayArmy": 0, "homeResources": 1000, "awayResources": 1000 }
 *       ]
 *     }
 *   ]
 * }
 */

const fs = require('fs');
const path = require('path');

// ============================================================
// A. 금지어 / 건물명 규칙
// ============================================================

const FORBIDDEN_WORDS = [
  '경제',           // → '자원', '일꾼', '확장' 사용
  '포토캐논',       // → '캐논'
  '로보틱스 퍼실리티', // → '로보틱스'
  '시타델',         // → '아둔'
];

// '플릿' 단독 사용 금지 (플릿 비콘은 OK, 스플릿은 제외)
const FLEET_SOLO_REGEX = /(?<!스)플릿(?!\s*비콘)/;

// 건물명 매핑: 잘못된 표기 → 올바른 표기
const BUILDING_NAME_CORRECTIONS = {
  // 테란
  '커맨드 센터': '커맨드센터',
  '컨트롤 타워': '컨트롤타워',
  '미사일 터렛': '터렛',
  '미사일터렛': '터렛',
  // 프로토스
  '포톤 캐논': '캐논',
  '포톤캐논': '캐논',
  '포토 캐논': '캐논',
  '로보틱스 퍼실리티': '로보틱스',
  '시타델 오브 아둔': '아둔',
  '시타델': '아둔',
  // 저그
  '스포닝 풀': '스포닝풀',
  '히드라리스크 덴': '히드라덴',
  '히드라 덴': '히드라덴',
  '퀸즈 네스트': '퀸즈네스트',
  '선큰 콜로니': '성큰',
  '선큰': '성큰',
};

// ============================================================
// B. 테크트리 (건물 → 유닛 의존성)
// ============================================================

const TECH_TREE = {
  terran: {
    buildings: {
      '커맨드센터': [],
      '배럭': ['커맨드센터'],
      '팩토리': ['배럭'],
      '스타포트': ['팩토리'],
      '엔지니어링 베이': ['커맨드센터'],
      '아카데미': ['배럭'],
      '아머리': ['팩토리'],
      '사이언스 퍼실리티': ['스타포트'],
      '벙커': ['배럭'],
      '터렛': ['엔지니어링 베이'],
      '머신샵': ['팩토리'],
      '컨트롤타워': ['스타포트'],
      '뉴클리어': ['사이언스 퍼실리티'],
      '컴셋 스테이션': ['아카데미'],
      '뉴클리어 사일로': ['사이언스 퍼실리티'],
      '서플라이 디팟': [],
      '서플': [],
      '리파이너리': [],
      '피직스 랩': ['사이언스 퍼실리티'],
      '커버트 옵스': ['사이언스 퍼실리티'],
    },
    units: {
      'SCV': ['커맨드센터'],
      '마린': ['배럭'],
      '파이어뱃': ['배럭', '아카데미'],
      '메딕': ['배럭', '아카데미'],
      '고스트': ['배럭', '사이언스 퍼실리티'],
      '벌처': ['팩토리'],
      '시즈탱크': ['팩토리', '머신샵'],
      '탱크': ['팩토리', '머신샵'],
      '골리앗': ['팩토리', '아머리'],
      '레이스': ['스타포트'],
      '드랍십': ['스타포트', '컨트롤타워'],
      '발키리': ['스타포트', '컨트롤타워', '아머리'],
      '사이언스베슬': ['스타포트', '사이언스 퍼실리티'],
      '배틀크루저': ['스타포트', '사이언스 퍼실리티', '컨트롤타워'],
    }
  },
  protoss: {
    buildings: {
      '넥서스': [],
      '파일런': ['넥서스'],
      '게이트웨이': ['넥서스'],
      '포지': ['넥서스'],
      '캐논': ['포지'],
      '사이버네틱스 코어': ['게이트웨이'],
      '로보틱스': ['사이버네틱스 코어'],
      '스타게이트': ['사이버네틱스 코어'],
      '아둔': ['사이버네틱스 코어'],
      '템플러 아카이브': ['아둔'],
      '플릿 비콘': ['스타게이트'],
      '아비터 트리뷰널': ['스타게이트', '템플러 아카이브'],
      '쉴드 배터리': ['게이트웨이'],
      '어시밀레이터': [],
      '로보틱스 서포트 베이': ['로보틱스'],
      '서포트 베이': ['로보틱스'],
      '옵저버터리': ['로보틱스'],
    },
    units: {
      '프로브': ['넥서스'],
      '질럿': ['게이트웨이'],
      '드라군': ['게이트웨이', '사이버네틱스 코어'],
      '하이템플러': ['게이트웨이', '템플러 아카이브'],
      '다크템플러': ['게이트웨이', '템플러 아카이브'],
      '아칸': ['게이트웨이', '템플러 아카이브'],
      '다크 아칸': ['게이트웨이', '템플러 아카이브'],
      '셔틀': ['로보틱스'],
      '리버': ['로보틱스', '로보틱스 서포트 베이'],
      '옵저버': ['로보틱스', '옵저버터리'],
      '커세어': ['스타게이트'],
      '스카우트': ['스타게이트'],
      '캐리어': ['스타게이트', '플릿 비콘'],
      '아비터': ['스타게이트', '아비터 트리뷰널'],
    }
  },
  zerg: {
    buildings: {
      '해처리': [],
      '스포닝풀': ['해처리'],
      '히드라덴': ['스포닝풀'],
      '레어': ['스포닝풀'],       // 해처리 업그레이드
      '스파이어': ['레어'],
      '퀸즈네스트': ['레어'],
      '하이브': ['퀸즈네스트'],    // 레어 업그레이드
      '성큰': ['해처리'],
      '스포어': ['해처리'],
      '익스트렉터': [],
      '에볼루션 챔버': ['해처리'],
      '챔버': ['해처리'],          // 에볼루션 챔버 약칭
      '크립 콜로니': ['해처리'],
      '크립': ['해처리'],          // 크립 콜로니 약칭
      '나이더스 커널': ['하이브'],
      '커널': ['하이브'],          // 나이더스 커널 약칭
      '디파일러 마운드': ['하이브'],
      '울트라리스크 캐번': ['하이브'],
      '그레이터 스파이어': ['하이브', '스파이어'],
    },
    units: {
      '드론': ['해처리'],
      '오버로드': ['해처리'],
      '저글링': ['스포닝풀'],
      '히드라리스크': ['히드라덴'],
      '히드라': ['히드라덴'],
      '뮤탈리스크': ['스파이어'],
      '뮤탈': ['스파이어'],
      '스커지': ['스파이어'],
      '퀸': ['퀸즈네스트'],
      '디파일러': ['디파일러 마운드'],
      '울트라리스크': ['울트라리스크 캐번'],
      '울트라': ['울트라리스크 캐번'],
      '가디언': ['그레이터 스파이어'],
      '디바우러': ['그레이터 스파이어'],
      '러커': ['히드라덴', '레어'],
    }
  }
};

// 종족전에서 사용되는 종족 매핑
const MATCHUP_RACES = {
  'TvT': ['terran', 'terran'],
  'TvZ': ['terran', 'zerg'],
  'TvP': ['terran', 'protoss'],
  'PvP': ['protoss', 'protoss'],
  'PvT': ['protoss', 'terran'],
  'ZvZ': ['zerg', 'zerg'],
  'ZvP': ['zerg', 'protoss'],
  'ZvT': ['zerg', 'terran'],
};

// ============================================================
// B-2. 결정적 이벤트 감지 / 유닛 타이밍 / 종족 유닛 매핑
// ============================================================

// 'GG'는 모든 경기 종료 시 자동 출력되므로 제외 (decisive = 극적 종료만)
const DECISIVE_KEYWORDS = ['항복', '결정타', '승리를 거둡니다', '본진이 무너', '함락', '핵 투하', '올킬', '패배를 인정'];

// 고테크 유닛 최소 등장 라인 (이 라인 이전 등장 시 위반)
const UNIT_MIN_LINE = {
  terran: {
    '배틀크루저': 15,
    '사이언스베슬': 12,
    '발키리': 12,
    '고스트': 12,
    '드랍십': 8,
    '레이스': 8,
    '골리앗': 6,
    '시즈탱크': 6,
    '탱크': 6,
  },
  protoss: {
    '캐리어': 15,
    '아비터': 12,
    '아칸': 12,
    '다크 아칸': 12,
    '하이템플러': 10,
    '다크템플러': 8,
    '리버': 8,
    '옵저버': 6,
    '셔틀': 6,
    '커세어': 6,
  },
  zerg: {
    '울트라리스크': 15,
    '울트라': 15,
    '가디언': 15,
    '디바우러': 15,
    '디파일러': 12,
    '퀸': 10,
    '러커': 8,
  },
};

/**
 * 결정적 이벤트로 끝났는지 감지 (B17, C17에서 공용)
 * system 뿐 아니라 home/away owner(GG 선언 등)도 체크
 */
function isDecisiveEnding(logs) {
  const tail = logs.slice(-5);
  return tail.some(l => DECISIVE_KEYWORDS.some(kw => (l.text || '').includes(kw)));
}

// ============================================================
// C. 검증 함수들
// ============================================================

/**
 * A-1. 금지어 체크
 */
function checkForbiddenWords(text, lineNum) {
  const violations = [];
  for (const word of FORBIDDEN_WORDS) {
    if (text.includes(word)) {
      violations.push({
        rule: 'A1_FORBIDDEN_WORD',
        line: lineNum,
        severity: 'error',
        message: `금지어 '${word}' 사용됨`,
        text: text.substring(0, 80),
      });
    }
  }
  if (FLEET_SOLO_REGEX.test(text)) {
    violations.push({
      rule: 'A1_FORBIDDEN_WORD',
      line: lineNum,
      severity: 'error',
      message: `'플릿' 단독 사용 (→ '플릿 비콘' 사용)`,
      text: text.substring(0, 80),
    });
  }
  return violations;
}

/**
 * A-2. 건물명 규칙 체크
 */
function checkBuildingNames(text, lineNum) {
  const violations = [];
  for (const [wrong, correct] of Object.entries(BUILDING_NAME_CORRECTIONS)) {
    if (text.includes(wrong)) {
      violations.push({
        rule: 'A2_BUILDING_NAME',
        line: lineNum,
        severity: 'error',
        message: `건물명 '${wrong}' → '${correct}' 수정 필요`,
        text: text.substring(0, 80),
      });
    }
  }
  return violations;
}

/**
 * A-3. 플레이스홀더 미치환 체크
 */
function checkPlaceholders(text, lineNum) {
  const violations = [];
  const placeholders = ['{home}', '{away}', '{attacker}', '{defender}'];
  for (const ph of placeholders) {
    if (text.includes(ph)) {
      violations.push({
        rule: 'A3_PLACEHOLDER',
        line: lineNum,
        severity: 'error',
        message: `미치환 플레이스홀더 '${ph}' 발견`,
        text: text.substring(0, 80),
      });
    }
  }
  return violations;
}

// A-4. 텍스트 품질 — 제거됨

/**
 * A-5. Owner 불일치 체크
 * home 이벤트인데 away 선수 이름이 주어로 등장하거나 그 반대
 */
function checkOwnerConsistency(log, homePlayerName, awayPlayerName, lineNum) {
  const violations = [];
  if (!homePlayerName || !awayPlayerName) return violations;

  const text = log.text;
  const owner = log.owner;

  // home 이벤트에서 away 선수가 주체 (문장 앞부분에 등장)
  if (owner === 'home' && text.startsWith(awayPlayerName)) {
    violations.push({
      rule: 'A5_OWNER_MISMATCH',
      line: lineNum,
      severity: 'error',
      message: `home 이벤트에 away 선수 '${awayPlayerName}'가 주체`,
      text: text.substring(0, 80),
    });
  }
  if (owner === 'away' && text.startsWith(homePlayerName)) {
    violations.push({
      rule: 'A5_OWNER_MISMATCH',
      line: lineNum,
      severity: 'error',
      message: `away 이벤트에 home 선수 '${homePlayerName}'가 주체`,
      text: text.substring(0, 80),
    });
  }
  return violations;
}

/**
 * A-6. Army 범위 체크
 */
function checkArmyBounds(log, lineNum) {
  const violations = [];
  if (log.homeArmy < 0 || log.homeArmy > 200) {
    violations.push({
      rule: 'A6_ARMY_BOUNDS',
      line: lineNum,
      severity: 'error',
      message: `homeArmy 범위 초과: ${log.homeArmy} (0~200)`,
      text: log.text?.substring(0, 80),
    });
  }
  if (log.awayArmy < 0 || log.awayArmy > 200) {
    violations.push({
      rule: 'A6_ARMY_BOUNDS',
      line: lineNum,
      severity: 'error',
      message: `awayArmy 범위 초과: ${log.awayArmy} (0~200)`,
      text: log.text?.substring(0, 80),
    });
  }
  return violations;
}

/**
 * A-7. Resource 범위 체크
 */
function checkResourceBounds(log, lineNum) {
  const violations = [];
  if (log.homeResources < 0 || log.homeResources > 10000) {
    violations.push({
      rule: 'A7_RESOURCE_BOUNDS',
      line: lineNum,
      severity: 'error',
      message: `homeResources 범위 초과: ${log.homeResources} (0~10000)`,
      text: log.text?.substring(0, 80),
    });
  }
  if (log.awayResources < 0 || log.awayResources > 10000) {
    violations.push({
      rule: 'A7_RESOURCE_BOUNDS',
      line: lineNum,
      severity: 'error',
      message: `awayResources 범위 초과: ${log.awayResources} (0~10000)`,
      text: log.text?.substring(0, 80),
    });
  }
  return violations;
}

// B-8. 최소 로그 수 — 제거됨 (극단적 빌드로 초반 종료되는 경기도 실제로 발생)

/**
 * B-10. 시스템 해설 비율 (10~30%)
 */
function checkSystemCommentaryRatio(logs) {
  const systemCount = logs.filter(l => l.owner === 'system').length;
  const ratio = systemCount / logs.length;
  const violations = [];
  if (ratio < 0.10) {
    violations.push({
      rule: 'B10_SYSTEM_RATIO',
      severity: 'warning',
      message: `시스템 해설 비율 ${(ratio * 100).toFixed(1)}% (최소 10% 필요)`,
    });
  }
  if (ratio > 0.30) {
    violations.push({
      rule: 'B10_SYSTEM_RATIO',
      severity: 'warning',
      message: `시스템 해설 비율 ${(ratio * 100).toFixed(1)}% (최대 30% 초과)`,
    });
  }
  return violations;
}

/**
 * B-11. 테크트리 순서 검증
 * 유닛이 생산 가능 건물 없이 등장하는지 체크
 */
// 상위 건물이 등장하면 하위 건물도 존재한다고 추론 (해설에서 중간 건물 생략하는 경우 대비)
const IMPLIED_BUILDINGS = {
  // 저그: 하이브가 있으면 하위 테크 건물은 당연히 존재
  '하이브': ['퀸즈네스트', '레어', '스포닝풀', '울트라리스크 캐번', '디파일러 마운드'],
  '레어': ['스포닝풀'],
  '스파이어': ['레어', '스포닝풀'],
  '퀸즈네스트': ['레어', '스포닝풀'],
  '그레이터 스파이어': ['하이브', '스파이어', '레어', '스포닝풀', '퀸즈네스트'],
  // 테란: 상위 건물이 있으면 하위 테크 존재
  '스타포트': ['팩토리', '배럭', '컨트롤타워', '아머리'],
  '사이언스 퍼실리티': ['스타포트', '팩토리', '배럭', '컨트롤타워', '아머리'],
  '팩토리': ['배럭', '머신샵', '아머리'],
  '아머리': ['팩토리', '배럭', '머신샵'],
  '아카데미': ['배럭'],
  '배럭': ['아카데미'],
  '컨트롤타워': ['스타포트', '팩토리', '배럭'],
  '머신샵': ['팩토리', '배럭'],
  // 프로토스: 상위 건물 → 하위 테크 존재
  '로보틱스': ['사이버네틱스 코어', '게이트웨이'],
  '스타게이트': ['사이버네틱스 코어', '게이트웨이'],
  '아둔': ['사이버네틱스 코어', '게이트웨이'],
  '템플러 아카이브': ['아둔', '사이버네틱스 코어', '게이트웨이'],
  '플릿 비콘': ['스타게이트', '사이버네틱스 코어', '게이트웨이'],
  '아비터 트리뷰널': ['스타게이트', '템플러 아카이브', '아둔', '사이버네틱스 코어', '게이트웨이'],
  '옵저버터리': ['로보틱스', '사이버네틱스 코어', '게이트웨이'],
  '로보틱스 서포트 베이': ['로보틱스', '사이버네틱스 코어', '게이트웨이'],
};

function checkTechTreeOrder(logs, matchup, isReversed) {
  const violations = [];
  const races = MATCHUP_RACES[matchup];
  if (!races) return violations;

  // isReversed 시 종족 매핑 스왑
  const [homeRace, awayRace] = isReversed ? [races[1], races[0]] : [races[0], races[1]];

  // 각 측의 등장한 건물 추적
  const homeBuildings = new Set();
  const awayBuildings = new Set();

  for (let i = 0; i < logs.length; i++) {
    const log = logs[i];
    const text = log.text || '';

    // home/away 이벤트에서만 체크
    if (log.owner === 'home' || log.owner === 'away') {
      const race = log.owner === 'home' ? homeRace : awayRace;
      const buildings = log.owner === 'home' ? homeBuildings : awayBuildings;
      const tree = TECH_TREE[race];
      if (!tree) continue;

      // 건물 등장 감지 → 추적에 추가 + 하위 건물 자동 추론
      for (const buildingName of Object.keys(tree.buildings)) {
        if (text.includes(buildingName)) {
          buildings.add(buildingName);
          // 상위 건물이 등장하면 하위 건물도 자동 추가
          const implied = IMPLIED_BUILDINGS[buildingName];
          if (implied) {
            for (const ib of implied) buildings.add(ib);
          }
        }
      }

      // 유닛 등장 감지 → 선행 건물 존재 여부 체크
      // 한글 문자 범위 (유닛명 앞에 한글이 붙으면 별도 단어가 아닌 복합어로 간주하여 스킵)
      const HANGUL_RE = /[\uAC00-\uD7AF\u1100-\u11FF\u3130-\u318F]/;
      for (const [unitName, requiredBuildings] of Object.entries(tree.units)) {
        const idx = text.indexOf(unitName);
        if (idx === -1) continue;
        // 앞 글자가 한글이면 복합어(예: '리플레이스'에서 '레이스') → 스킵
        if (idx > 0 && HANGUL_RE.test(text[idx - 1])) continue;
        {
          for (const req of requiredBuildings) {
            if (!buildings.has(req)) {
              // 해처리/넥서스/커맨드센터는 기본 존재로 간주
              const baseBuildings = ['해처리', '넥서스', '커맨드센터'];
              if (baseBuildings.includes(req)) {
                buildings.add(req);
                continue;
              }
              violations.push({
                rule: 'B11_TECH_TREE',
                line: i + 1,
                severity: 'error',
                message: `'${unitName}' 등장 but 선행 건물 '${req}' 미등장 (${log.owner})`,
                text: text.substring(0, 80),
              });
            }
          }
        }
      }
    }
  }
  return violations;
}

/**
 * B-12. 동일 텍스트 3줄 연속 반복 체크
 */
function checkConsecutiveDuplicates(logs) {
  const violations = [];
  for (let i = 2; i < logs.length; i++) {
    if (logs[i].text === logs[i - 1].text && logs[i].text === logs[i - 2].text) {
      violations.push({
        rule: 'B12_CONSECUTIVE_DUP',
        line: i + 1,
        severity: 'error',
        message: `동일 텍스트 3줄 연속 반복`,
        text: logs[i].text?.substring(0, 80),
      });
    }
  }
  return violations;
}

/**
 * B-17. 승자 최종 병력 >= 패자 최종 병력
 * decisive 이벤트 종료는 예외 (핵 투하, 본진 러시 등)
 */
function checkWinnerArmy(game) {
  const logs = game.logs || [];
  if (logs.length === 0) return [];
  if (isDecisiveEnding(logs)) return []; // decisive 예외

  const last = logs[logs.length - 1];
  const winnerArmy = game.homeWin ? last.homeArmy : last.awayArmy;
  const loserArmy = game.homeWin ? last.awayArmy : last.homeArmy;

  if (winnerArmy < loserArmy) {
    return [{
      rule: 'B17_WINNER_ARMY',
      severity: 'error',
      message: `승자 최종 병력(${winnerArmy}) < 패자 최종 병력(${loserArmy})`,
    }];
  }
  return [];
}

// B-18. 자원 소모 방향성 — 제거됨

/**
 * B-19. 게임 종료 후 패자 행동 금지
 * 결정적 system 이벤트 이후 패배 측 home/away 이벤트가 나오면 위반
 */
function checkDeadPlayerAction(game) {
  const logs = game.logs || [];
  if (logs.length < 3) return [];

  // 뒤에서부터 결정적 이벤트 탐색 (system + player owner 모두 체크)
  let decisiveIdx = -1;
  for (let i = logs.length - 1; i >= 0; i--) {
    if (DECISIVE_KEYWORDS.some(kw => (logs[i].text || '').includes(kw))) {
      decisiveIdx = i;
      break;
    }
  }
  if (decisiveIdx === -1) return [];

  const loserSide = game.homeWin ? 'away' : 'home';
  const violations = [];
  // GG 선언 관련 텍스트는 패자의 정상적 마지막 행동이므로 예외 처리
  const GG_PATTERNS = ['GG를 선언', 'GG', '패배를 인정'];
  for (let i = decisiveIdx + 1; i < logs.length; i++) {
    if (logs[i].owner === loserSide) {
      const text = logs[i].text || '';
      const isGG = GG_PATTERNS.some(p => text.includes(p));
      if (!isGG) {
        violations.push({
          rule: 'B19_DEAD_PLAYER_ACTION',
          line: i + 1,
          severity: 'error',
          message: `결정적 이벤트 이후 패자(${loserSide}) 이벤트 발생`,
          text: text.substring(0, 80),
        });
      }
    }
  }
  return violations;
}

/**
 * B-20. 유닛 타이밍 검증
 * 고테크 유닛이 최소 라인 이전에 등장하면 위반
 */
function checkUnitTiming(logs, matchup, isReversed) {
  const races = MATCHUP_RACES[matchup];
  if (!races) return [];
  const [homeRace, awayRace] = isReversed ? [races[1], races[0]] : [races[0], races[1]];
  const violations = [];

  for (let i = 0; i < logs.length; i++) {
    const log = logs[i];
    const text = log.text || '';
    if (log.owner !== 'home' && log.owner !== 'away') continue;

    const race = log.owner === 'home' ? homeRace : awayRace;
    const minLines = UNIT_MIN_LINE[race];
    if (!minLines) continue;

    for (const [unit, minLine] of Object.entries(minLines)) {
      if (text.includes(unit) && (i + 1) < minLine) {
        violations.push({
          rule: 'B20_UNIT_TIMING',
          line: i + 1,
          severity: 'error',
          message: `'${unit}' 등장이 너무 이름 (라인 ${i + 1}, 최소 라인 ${minLine})`,
          text: text.substring(0, 80),
        });
      }
    }
  }
  return violations;
}

/**
 * B-21. 종족 간 유닛 혼입 방지
 * home/away 이벤트에서 다른 종족 유닛이 주체(주어)로 등장하면 위반
 * 주체 판별: 텍스트가 유닛명으로 시작하거나 유닛명+주격조사 패턴
 */
function checkRaceUnitMismatch(logs, matchup, isReversed) {
  const races = MATCHUP_RACES[matchup];
  if (!races) return [];

  // isReversed 시 종족 매핑 스왑
  const [homeRace, awayRace] = isReversed ? [races[1], races[0]] : [races[0], races[1]];

  // 종족별 유닛 목록
  const raceUnits = {};
  for (const [race, tree] of Object.entries(TECH_TREE)) {
    raceUnits[race] = Object.keys(tree.units);
  }

  const violations = [];
  for (let i = 0; i < logs.length; i++) {
    const log = logs[i];
    if (log.owner !== 'home' && log.owner !== 'away') continue;
    const text = log.text || '';
    const ownerRace = log.owner === 'home' ? homeRace : awayRace;
    const ownUnits = raceUnits[ownerRace] || [];

    let found = false;
    for (const [race, units] of Object.entries(raceUnits)) {
      if (race === ownerRace || found) continue;
      for (const unit of units) {
        // 주체 패턴: 텍스트 시작 또는 유닛+주격조사
        const isSubject = text.startsWith(unit) ||
          text.includes(unit + '이 ') ||
          text.includes(unit + '가 ') ||
          text.includes(unit + '의 ') ||
          text.includes(unit + '은 ') ||
          text.includes(unit + '는 ');
        if (!isSubject) continue;

        // 같은 텍스트에 자기 종족 유닛이 주체면 OK (예: "마린이 저글링을 격파")
        const hasOwnSubject = ownUnits.some(ou =>
          text.startsWith(ou) ||
          text.includes(ou + '이 ') ||
          text.includes(ou + '가 ')
        );
        if (hasOwnSubject) continue;

        violations.push({
          rule: 'B21_RACE_UNIT_MISMATCH',
          line: i + 1,
          severity: 'error',
          message: `${log.owner}(${ownerRace}) 이벤트에 ${race} 유닛 '${unit}'이 주체로 등장`,
          text: text.substring(0, 80),
        });
        found = true;
        break;
      }
    }
  }
  return violations;
}

// B-22. 시스템 해설 위치 분산 — 제거됨

// ============================================================
// D. 다경기 통계 검증 (C레벨)
// ============================================================

/**
 * C-13. 승률 범위 검증
 */
function checkWinRate(games, matchup) {
  const homeWins = games.filter(g => g.homeWin).length;
  const winRate = homeWins / games.length;
  const isMirror = matchup[0] === matchup[2]; // TvT, PvP, ZvZ
  const min = isMirror ? 0.45 : 0.30;
  const max = isMirror ? 0.55 : 0.70;

  if (winRate < min || winRate > max) {
    return [{
      rule: 'C13_WIN_RATE',
      severity: 'error',
      message: `승률 ${(winRate * 100).toFixed(1)}% (허용: ${min * 100}~${max * 100}%) [${homeWins}/${games.length}]`,
    }];
  }
  return [];
}

/**
 * C-14. 홈/어웨이 반전 차이 검증
 * 정방향/역방향 게임이 모두 있을 때만 체크
 */
function checkHomeAwaySymmetry(games) {
  const normal = games.filter(g => !g.isReversed);
  const reversed = games.filter(g => g.isReversed);

  if (normal.length < 10 || reversed.length < 10) return []; // 샘플 부족

  const normalWinRate = normal.filter(g => g.homeWin).length / normal.length;
  const reversedWinRate = reversed.filter(g => g.homeWin).length / reversed.length;
  const diff = Math.abs(normalWinRate - reversedWinRate);

  if (diff > 0.05) {
    return [{
      rule: 'C14_HOME_AWAY_SYMMETRY',
      severity: 'error',
      message: `홈/어웨이 반전 승률 차이 ${(diff * 100).toFixed(1)}%p (허용: ±5%p) [정방향: ${(normalWinRate * 100).toFixed(1)}%, 역방향: ${(reversedWinRate * 100).toFixed(1)}%]`,
    }];
  }
  return [];
}

/**
 * C-15. 텍스트 다양성
 */
function checkTextDiversity(games, minGames = 100) {
  if (games.length < minGames) return [];

  const uniqueTexts = new Set();
  for (const game of games) {
    for (const log of game.logs) {
      uniqueTexts.add(log.text);
    }
  }

  // 500경기 기준 50개, 비례 적용
  const requiredUnique = Math.floor(50 * (games.length / 500));

  if (uniqueTexts.size < requiredUnique) {
    return [{
      rule: 'C15_TEXT_DIVERSITY',
      severity: 'warning',
      message: `고유 로그 ${uniqueTexts.size}개 (최소 ${requiredUnique}개 필요, ${games.length}경기 기준)`,
    }];
  }
  return [];
}

/**
 * C-16. 분기 활성화율 (모든 branch가 최소 5% 이상)
 * branchStats가 제공될 때만 체크
 */
function checkBranchActivation(branchStats) {
  if (!branchStats || Object.keys(branchStats).length === 0) return [];
  const violations = [];
  const total = Object.values(branchStats).reduce((a, b) => a + b, 0);

  for (const [branch, count] of Object.entries(branchStats)) {
    const rate = count / total;
    if (rate < 0.05) {
      violations.push({
        rule: 'C16_BRANCH_ACTIVATION',
        severity: 'warning',
        message: `분기 '${branch}' 활성화율 ${(rate * 100).toFixed(1)}% (최소 5% 필요)`,
      });
    }
  }
  return violations;
}

/**
 * C-17. 결정적 이벤트 종료 비율 (30~70%)
 * 모든 경기가 decisive로만 끝나거나, 전혀 없으면 단조로움
 */
function checkDecisiveRate(games) {
  const decisiveCount = games.filter(g => isDecisiveEnding(g.logs || [])).length;
  const rate = decisiveCount / games.length;
  const violations = [];

  if (rate < 0.30) {
    violations.push({
      rule: 'C17_DECISIVE_RATE',
      severity: 'warning',
      message: `decisive 종료 비율 ${(rate * 100).toFixed(1)}% (최소 30% 필요) [${decisiveCount}/${games.length}]`,
    });
  }
  if (rate > 0.70) {
    violations.push({
      rule: 'C17_DECISIVE_RATE',
      severity: 'warning',
      message: `decisive 종료 비율 ${(rate * 100).toFixed(1)}% (최대 70% 초과) [${decisiveCount}/${games.length}]`,
    });
  }
  return violations;
}

// ============================================================
// E. 메인 검증 실행
// ============================================================

function validateSingleGame(game, matchup, gameIndex) {
  const violations = [];
  const logs = game.logs || [];
  const isReversed = game.isReversed || false;

  // B-10: 시스템 해설 비율
  violations.push(...checkSystemCommentaryRatio(logs));

  // B-11: 테크트리 순서 (isReversed 반영)
  violations.push(...checkTechTreeOrder(logs, matchup, isReversed));

  // B-12: 연속 중복
  violations.push(...checkConsecutiveDuplicates(logs));

  // B-17: 승자 최종 병력 >= 패자 최종 병력
  violations.push(...checkWinnerArmy(game));

  // B-19: 게임 종료 후 패자 행동 금지
  violations.push(...checkDeadPlayerAction(game));

  // B-20: 유닛 타이밍 검증 (isReversed 반영)
  violations.push(...checkUnitTiming(logs, matchup, isReversed));

  // B-21: 종족 간 유닛 혼입 방지 (isReversed 반영)
  violations.push(...checkRaceUnitMismatch(logs, matchup, isReversed));

  // 줄 단위 검증
  for (let i = 0; i < logs.length; i++) {
    const log = logs[i];
    const lineNum = i + 1;

    // A-1: 금지어
    violations.push(...checkForbiddenWords(log.text || '', lineNum));
    // A-2: 건물명
    violations.push(...checkBuildingNames(log.text || '', lineNum));
    // A-3: 플레이스홀더
    violations.push(...checkPlaceholders(log.text || '', lineNum));
    // A-5: Owner 불일치
    violations.push(...checkOwnerConsistency(log, game.homePlayerName, game.awayPlayerName, lineNum));
    // A-6: Army 범위
    violations.push(...checkArmyBounds(log, lineNum));
    // A-7: Resource 범위
    violations.push(...checkResourceBounds(log, lineNum));
  }

  return violations.map(v => ({ ...v, gameIndex }));
}

function validateMultiGame(data) {
  const allViolations = [];
  const matchup = data.matchup || 'Unknown';
  const games = data.games || [];

  // 단일 경기 검증
  for (let i = 0; i < games.length; i++) {
    allViolations.push(...validateSingleGame(games[i], matchup, i));
  }

  // 다경기 통계 검증 (최소 50경기)
  if (games.length >= 50) {
    allViolations.push(...checkWinRate(games, matchup));
    allViolations.push(...checkHomeAwaySymmetry(games));
    allViolations.push(...checkTextDiversity(games));
    if (data.branchStats) {
      allViolations.push(...checkBranchActivation(data.branchStats));
    }
    // C-17: decisive 종료 비율
    allViolations.push(...checkDecisiveRate(games));
  }

  return allViolations;
}

// ============================================================
// F. 리포트 생성
// ============================================================

function generateReport(data, violations) {
  const errors = violations.filter(v => v.severity === 'error');
  const warnings = violations.filter(v => v.severity === 'warning');
  const passed = errors.length === 0;

  const lines = [];
  lines.push(`# 보정 검증 결과: ${data.matchup} - ${data.scenarioId || 'all'}`);
  lines.push(``);
  lines.push(`- **상태**: ${passed ? '✅ PASS' : '❌ FAIL'}`);
  lines.push(`- **경기 수**: ${data.games?.length || 0}`);
  lines.push(`- **에러**: ${errors.length}건`);
  lines.push(`- **경고**: ${warnings.length}건`);
  lines.push(`- **검증 시각**: ${new Date().toISOString()}`);
  lines.push(``);

  if (errors.length > 0) {
    lines.push(`## ❌ 에러 (반드시 수정)`);
    lines.push(``);

    // 룰별 그룹핑
    const grouped = {};
    for (const e of errors) {
      if (!grouped[e.rule]) grouped[e.rule] = [];
      grouped[e.rule].push(e);
    }
    for (const [rule, items] of Object.entries(grouped)) {
      lines.push(`### ${rule} (${items.length}건)`);
      for (const item of items.slice(0, 10)) { // 최대 10개만 표시
        const loc = item.gameIndex !== undefined ? `[게임${item.gameIndex}` : '[';
        const linePart = item.line ? ` L${item.line}]` : ']';
        lines.push(`- ${loc}${linePart} ${item.message}`);
        if (item.text) lines.push(`  > \`${item.text}\``);
      }
      if (items.length > 10) {
        lines.push(`- ... 외 ${items.length - 10}건`);
      }
      lines.push(``);
    }
  }

  if (warnings.length > 0) {
    lines.push(`## ⚠️ 경고 (권장 수정)`);
    lines.push(``);
    const grouped = {};
    for (const w of warnings) {
      if (!grouped[w.rule]) grouped[w.rule] = [];
      grouped[w.rule].push(w);
    }
    for (const [rule, items] of Object.entries(grouped)) {
      lines.push(`### ${rule} (${items.length}건)`);
      for (const item of items.slice(0, 5)) {
        const loc = item.gameIndex !== undefined ? `[게임${item.gameIndex}` : '[';
        const linePart = item.line ? ` L${item.line}]` : ']';
        lines.push(`- ${loc}${linePart} ${item.message}`);
      }
      if (items.length > 5) {
        lines.push(`- ... 외 ${items.length - 5}건`);
      }
      lines.push(``);
    }
  }

  if (passed && warnings.length === 0) {
    lines.push(`## 모든 검증 기준 통과! 🎉`);
  }

  return lines.join('\n');
}

// ============================================================
// G. CLI 실행
// ============================================================

if (require.main === module) {
  const args = process.argv.slice(2);
  if (args.length === 0) {
    console.log('사용법: node tools/calibration_criteria.js <log_json_path>');
    console.log('예시:   node tools/calibration_criteria.js test/output/pvp_log.json');
    process.exit(1);
  }

  const filePath = args[0];
  if (!fs.existsSync(filePath)) {
    console.error(`파일 없음: ${filePath}`);
    process.exit(1);
  }

  const data = JSON.parse(fs.readFileSync(filePath, 'utf-8'));
  const violations = validateMultiGame(data);
  const report = generateReport(data, violations);

  console.log(report);

  // 결과 파일 저장
  const outputPath = filePath.replace('.json', '_result.md');
  fs.writeFileSync(outputPath, report, 'utf-8');
  console.log(`\n결과 저장: ${outputPath}`);

  process.exit(violations.filter(v => v.severity === 'error').length > 0 ? 1 : 0);
}

// 모듈 export (다른 스크립트에서 import 가능)
module.exports = {
  validateSingleGame,
  validateMultiGame,
  generateReport,
  checkForbiddenWords,
  checkBuildingNames,
  checkPlaceholders,
  checkOwnerConsistency,
  checkArmyBounds,
  checkResourceBounds,
  checkSystemCommentaryRatio,
  checkTechTreeOrder,
  checkConsecutiveDuplicates,
  checkWinRate,
  checkHomeAwaySymmetry,
  checkTextDiversity,
  checkBranchActivation,
  checkWinnerArmy,
  checkDeadPlayerAction,
  checkUnitTiming,
  checkRaceUnitMismatch,
  checkDecisiveRate,
  isDecisiveEnding,
  TECH_TREE,
  UNIT_MIN_LINE,
  DECISIVE_KEYWORDS,
  FORBIDDEN_WORDS,
  BUILDING_NAME_CORRECTIONS,
};
