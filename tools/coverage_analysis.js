// 시나리오 커버리지 분석 스크립트
const fs = require('fs');
const path = require('path');

// 1. BuildType에서 추출한 모든 빌드 ID (matchup별)
const buildTypes = {
  // TvZ: 테란 측 (opening + transition)
  TvZ_home: [
    'tvz_bunker', 'tvz_sk', 'tvz_3fac_goliath', 'tvz_enbe_first',
    'tvz_111', 'tvz_valkyrie', 'tvz_2star_wraith',
    'tvz_trans_bionic_push', 'tvz_trans_mech_goliath', 'tvz_trans_111_balance',
    'tvz_trans_valkyrie', 'tvz_trans_wraith', 'tvz_trans_enbe_first'
  ],
  // ZvT: 저그 측 (opening + transition)
  TvZ_away: [
    'zvt_4pool', 'zvt_9pool', 'zvt_9overpool', 'zvt_12pool', 'zvt_12hatch',
    'zvt_3hatch_nopool', 'zvt_3hatch_mutal', 'zvt_2hatch_mutal', 'zvt_2hatch_lurker',
    'zvt_1hatch_allin',
    'zvt_trans_mutal_ultra', 'zvt_trans_2hatch_mutal', 'zvt_trans_lurker_defiler',
    'zvt_trans_530_mutal', 'zvt_trans_mutal_lurker', 'zvt_trans_ultra_hive'
  ],

  // TvP: 테란 측
  TvP_home: [
    'tvp_bbs', 'tvp_double', 'tvp_fake_double', 'tvp_1fac_drop', 'tvp_1fac_gosu',
    'tvp_bar_double', 'tvp_5fac_timing', 'tvp_mine_triple', 'tvp_fd',
    'tvp_11up_8fac', 'tvp_anti_carrier',
    'tvp_trans_tank_defense', 'tvp_trans_timing_push', 'tvp_trans_upgrade',
    'tvp_trans_bio_mech', 'tvp_trans_5fac_mass', 'tvp_trans_anti_carrier'
  ],
  // PvT: 프로토스 측
  TvP_away: [
    'pvt_proxy_gate', 'pvt_2gate_zealot', 'pvt_dark_swing', 'pvt_1gate_obs',
    'pvt_proxy_dark', 'pvt_1gate_expand', 'pvt_carrier', 'pvt_reaver_shuttle',
    'pvt_trans_5gate_push', 'pvt_trans_5gate_arbiter', 'pvt_trans_5gate_carrier',
    'pvt_trans_reaver_push', 'pvt_trans_reaver_arbiter', 'pvt_trans_reaver_carrier'
  ],

  // TvT
  TvT: [
    'tvt_bbs', 'tvt_1bar_double', 'tvt_nobar_double', 'tvt_1fac_double',
    'tvt_1fac_1star', 'tvt_2fac_push', 'tvt_5fac', 'tvt_2star', 'tvt_fd_rush'
  ],

  // ZvP: 저그 측
  ZvP_home: [
    'zvp_4pool', 'zvp_9pool', 'zvp_9overpool', 'zvp_12pool', 'zvp_12hatch',
    'zvp_3hatch_nopool', 'zvp_3hatch_hydra', 'zvp_2hatch_mutal',
    'zvp_scourge_defiler', 'zvp_5drone', 'zvp_973_hydra', 'zvp_mukerji', 'zvp_yabarwi',
    'zvp_trans_5hatch_hydra', 'zvp_trans_mutal_hydra', 'zvp_trans_hive_defiler',
    'zvp_trans_973_hydra', 'zvp_trans_mukerji', 'zvp_trans_yabarwi', 'zvp_trans_hydra_lurker'
  ],
  // PvZ: 프로토스 측
  ZvP_away: [
    'pvz_2gate_zealot', 'pvz_forge_cannon', 'pvz_corsair_reaver', 'pvz_proxy_gate',
    'pvz_cannon_rush', 'pvz_8gat', 'pvz_2star_corsair',
    'pvz_trans_dragoon_push', 'pvz_trans_corsair', 'pvz_trans_archon', 'pvz_trans_forge_expand'
  ],

  // ZvZ
  ZvZ: [
    'zvz_pool_first', 'zvz_9pool', 'zvz_9overpool', 'zvz_12pool',
    'zvz_12hatch', 'zvz_3hatch_nopool'
  ],

  // PvP
  PvP: [
    'pvp_2gate_dragoon', 'pvp_dark_allin', 'pvp_1gate_robo', 'pvp_zealot_rush',
    'pvp_4gate_dragoon', 'pvp_1gate_multi', 'pvp_2gate_reaver', 'pvp_3gate_speedzealot'
  ],
};

// 2. 시나리오 파일에서 homeBuildIds/awayBuildIds 추출
function parseScenarios(dir) {
  const scenarios = [];
  const files = fs.readdirSync(dir, { recursive: true });
  for (const file of files) {
    if (!file.endsWith('.dart')) continue;
    const filePath = path.join(dir, file);
    const content = fs.readFileSync(filePath, 'utf-8');

    const homeMatch = content.match(/homeBuildIds:\s*\[([^\]]+)\]/);
    const awayMatch = content.match(/awayBuildIds:\s*\[([^\]]+)\]/);
    if (homeMatch && awayMatch) {
      const homeIds = homeMatch[1].match(/'([^']+)'/g).map(s => s.replace(/'/g, ''));
      const awayIds = awayMatch[1].match(/'([^']+)'/g).map(s => s.replace(/'/g, ''));

      // 매치업 판별 (파일 경로 기반)
      let matchup = '';
      if (file.includes('tvt')) matchup = 'TvT';
      else if (file.includes('tvz')) matchup = 'TvZ';
      else if (file.includes('pvt')) matchup = 'PvT';
      else if (file.includes('pvp')) matchup = 'PvP';
      else if (file.includes('zvp')) matchup = 'ZvP';
      else if (file.includes('zvz')) matchup = 'ZvZ';

      scenarios.push({ file: file.replace(/\\/g, '/'), matchup, homeIds, awayIds });
    }
  }
  return scenarios;
}

const scenarioDir = path.join(__dirname, '..', 'lib', 'core', 'constants', 'scenarios');
const scenarios = parseScenarios(scenarioDir);

// 3. 커버리지 분석
function analyzeMirror(matchup, builds, scenarios) {
  const total = builds.length * builds.length;
  const covered = new Set();

  for (const s of scenarios.filter(s => s.matchup === matchup)) {
    for (const h of s.homeIds) {
      for (const a of s.awayIds) {
        covered.add(`${h}|${a}`);
        // 역방향도 커버 (reverse matching)
        covered.add(`${a}|${h}`);
      }
    }
  }

  const missing = [];
  for (const h of builds) {
    for (const a of builds) {
      if (!covered.has(`${h}|${a}`)) {
        missing.push([h, a]);
      }
    }
  }

  return { total, covered: total - missing.length, missing };
}

function analyzeAsymmetric(matchupName, homeBuilds, awayBuilds, primaryScenarios, reverseScenarios) {
  const total = homeBuilds.length * awayBuilds.length;
  const covered = new Set();

  // 정방향 시나리오 (예: TvZ 시나리오에서 home=T, away=Z)
  for (const s of primaryScenarios) {
    for (const h of s.homeIds) {
      for (const a of s.awayIds) {
        covered.add(`${h}|${a}`);
      }
    }
  }

  // 역방향 시나리오 (예: PvT 시나리오 → TvP에서 역방향 매칭)
  for (const s of reverseScenarios) {
    for (const h of s.homeIds) {
      for (const a of s.awayIds) {
        // 역방향이므로 home↔away 스왑
        covered.add(`${a}|${h}`);
      }
    }
  }

  const missing = [];
  for (const h of homeBuilds) {
    for (const a of awayBuilds) {
      if (!covered.has(`${h}|${a}`)) {
        missing.push([h, a]);
      }
    }
  }

  return { total, covered: total - missing.length, missing };
}

// --- 미러 매치업 ---
console.log('=== 미러 매치업 분석 ===\n');

for (const [matchup, builds] of [['TvT', buildTypes.TvT], ['ZvZ', buildTypes.ZvZ], ['PvP', buildTypes.PvP]]) {
  const result = analyzeMirror(matchup, builds, scenarios);
  console.log(`### ${matchup} (${builds.length} builds, ${result.total} 조합)`);
  console.log(`커버: ${result.covered}/${result.total} (${(result.covered/result.total*100).toFixed(0)}%)`);
  if (result.missing.length > 0) {
    console.log(`미커버 ${result.missing.length}개:`);
    for (const [h, a] of result.missing) {
      console.log(`  - ${h} vs ${a}`);
    }
  } else {
    console.log('100% 커버!');
  }
  console.log('');
}

// --- 비대칭 매치업 ---
console.log('\n=== 비대칭 매치업 분석 ===\n');

// TvZ: home=Terran, away=Zerg
// TvZ 시나리오가 정방향, ZvT 시나리오(없음)가 역방향
const tvzResult = analyzeAsymmetric(
  'TvZ', buildTypes.TvZ_home, buildTypes.TvZ_away,
  scenarios.filter(s => s.matchup === 'TvZ'),
  [] // ZvT 시나리오 폴더 없음
);
console.log(`### TvZ (${buildTypes.TvZ_home.length}T × ${buildTypes.TvZ_away.length}Z = ${tvzResult.total} 조합)`);
console.log(`커버: ${tvzResult.covered}/${tvzResult.total} (${(tvzResult.covered/tvzResult.total*100).toFixed(0)}%)`);
if (tvzResult.missing.length > 0) {
  console.log(`미커버 ${tvzResult.missing.length}개:`);
  for (const [h, a] of tvzResult.missing) {
    console.log(`  - ${h} vs ${a}`);
  }
}
console.log('');

// PvT: 정방향=PvT 시나리오(home=P, away=T), 역방향=TvP 시나리오 없으므로 없음
// 하지만 실제로는 TvP 매치업일 때 PvT 시나리오를 역방향으로 사용
// TvP 경기: home=T, away=P → PvT 시나리오를 역방향 매칭 (T가 awayBuildIds에, P가 homeBuildIds에)
const tvpResult = analyzeAsymmetric(
  'TvP', buildTypes.TvP_home, buildTypes.TvP_away,
  [], // TvP 시나리오 폴더 없음
  scenarios.filter(s => s.matchup === 'PvT') // PvT 시나리오가 역방향으로 TvP 커버
);
console.log(`### TvP (${buildTypes.TvP_home.length}T × ${buildTypes.TvP_away.length}P = ${tvpResult.total} 조합)`);
console.log(`커버: ${tvpResult.covered}/${tvpResult.total} (${(tvpResult.covered/tvpResult.total*100).toFixed(0)}%)`);
if (tvpResult.missing.length > 0) {
  console.log(`미커버 ${tvpResult.missing.length}개:`);
  for (const [h, a] of tvpResult.missing) {
    console.log(`  - ${h} vs ${a}`);
  }
}
console.log('');

// PvT: 정방향=PvT 시나리오(home=P, away=T)
const pvtResult = analyzeAsymmetric(
  'PvT', buildTypes.TvP_away, buildTypes.TvP_home,
  scenarios.filter(s => s.matchup === 'PvT'),
  [] // TvP 역방향 없음
);
console.log(`### PvT (${buildTypes.TvP_away.length}P × ${buildTypes.TvP_home.length}T = ${pvtResult.total} 조합)`);
console.log(`커버: ${pvtResult.covered}/${pvtResult.total} (${(pvtResult.covered/pvtResult.total*100).toFixed(0)}%)`);
if (pvtResult.missing.length > 0) {
  console.log(`미커버 ${pvtResult.missing.length}개:`);
  for (const [h, a] of pvtResult.missing) {
    console.log(`  - ${h} vs ${a}`);
  }
}
console.log('');

// ZvP: home=Z, away=P
const zvpResult = analyzeAsymmetric(
  'ZvP', buildTypes.ZvP_home, buildTypes.ZvP_away,
  scenarios.filter(s => s.matchup === 'ZvP'),
  [] // PvZ 시나리오 폴더 없음
);
console.log(`### ZvP (${buildTypes.ZvP_home.length}Z × ${buildTypes.ZvP_away.length}P = ${zvpResult.total} 조합)`);
console.log(`커버: ${zvpResult.covered}/${zvpResult.total} (${(zvpResult.covered/zvpResult.total*100).toFixed(0)}%)`);
if (zvpResult.missing.length > 0) {
  console.log(`미커버 ${zvpResult.missing.length}개:`);
  for (const [h, a] of zvpResult.missing) {
    console.log(`  - ${h} vs ${a}`);
  }
}
console.log('');

// PvZ: home=P, away=Z → ZvP 시나리오를 역방향 매칭
const pvzResult = analyzeAsymmetric(
  'PvZ', buildTypes.ZvP_away, buildTypes.ZvP_home,
  [], // PvZ 시나리오 폴더 없음
  scenarios.filter(s => s.matchup === 'ZvP') // ZvP 시나리오가 역방향으로 PvZ 커버
);
console.log(`### PvZ (${buildTypes.ZvP_away.length}P × ${buildTypes.ZvP_home.length}Z = ${pvzResult.total} 조합)`);
console.log(`커버: ${pvzResult.covered}/${pvzResult.total} (${(pvzResult.covered/pvzResult.total*100).toFixed(0)}%)`);
if (pvzResult.missing.length > 0) {
  console.log(`미커버 ${pvzResult.missing.length}개:`);
  for (const [h, a] of pvzResult.missing) {
    console.log(`  - ${h} vs ${a}`);
  }
}
console.log('');

// ZvT: home=Z, away=T → TvZ 시나리오를 역방향 매칭
const zvtResult = analyzeAsymmetric(
  'ZvT', buildTypes.TvZ_away, buildTypes.TvZ_home,
  [], // ZvT 시나리오 폴더 없음
  scenarios.filter(s => s.matchup === 'TvZ') // TvZ 시나리오가 역방향으로 ZvT 커버
);
console.log(`### ZvT (${buildTypes.TvZ_away.length}Z × ${buildTypes.TvZ_home.length}T = ${zvtResult.total} 조합)`);
console.log(`커버: ${zvtResult.covered}/${zvtResult.total} (${(zvtResult.covered/zvtResult.total*100).toFixed(0)}%)`);
if (zvtResult.missing.length > 0) {
  console.log(`미커버 ${zvtResult.missing.length}개:`);
  for (const [h, a] of zvtResult.missing) {
    console.log(`  - ${h} vs ${a}`);
  }
}
console.log('');

// 요약
console.log('\n=== 전체 요약 ===\n');
const all = [
  { name: 'TvT', ...analyzeMirror('TvT', buildTypes.TvT, scenarios) },
  { name: 'ZvZ', ...analyzeMirror('ZvZ', buildTypes.ZvZ, scenarios) },
  { name: 'PvP', ...analyzeMirror('PvP', buildTypes.PvP, scenarios) },
  { name: 'TvZ', ...tvzResult },
  { name: 'ZvT', ...zvtResult },
  { name: 'PvT/TvP', total: pvtResult.total + tvpResult.total, covered: pvtResult.covered + tvpResult.covered, missing: [...pvtResult.missing, ...tvpResult.missing] },
  { name: 'ZvP/PvZ', total: zvpResult.total + pvzResult.total, covered: zvpResult.covered + pvzResult.covered, missing: [...zvpResult.missing, ...pvzResult.missing] },
];

let totalAll = 0, coveredAll = 0, missingAll = 0;
for (const r of all) {
  console.log(`${r.name}: ${r.covered}/${r.total} (미커버 ${r.missing.length}개)`);
  totalAll += r.total;
  coveredAll += r.covered;
  missingAll += r.missing.length;
}
console.log(`\n총합: ${coveredAll}/${totalAll} 커버 (미커버 ${missingAll}개)`);
