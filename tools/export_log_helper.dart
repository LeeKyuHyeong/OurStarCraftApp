/// 시뮬레이션 로그를 JSON으로 내보내는 헬퍼
///
/// 테스트에서 import하여 사용:
/// ```dart
/// import '../tools/export_log_helper.dart';
/// ```
library;

import 'dart:convert';
import 'dart:io';

import 'package:mystar/domain/services/match_simulation_service.dart';

/// 단일 경기 로그를 Map으로 변환
Map<String, dynamic> gameToJson({
  required int gameIndex,
  required SimulationState finalState,
  required String homePlayerName,
  required String awayPlayerName,
  required String homeBuildId,
  required String awayBuildId,
  required bool isReversed,
}) {
  return {
    'gameIndex': gameIndex,
    'homeWin': finalState.homeWin,
    'isReversed': isReversed,
    'homeBuildId': homeBuildId,
    'awayBuildId': awayBuildId,
    'homePlayerName': homePlayerName,
    'awayPlayerName': awayPlayerName,
    'logs': finalState.battleLogEntries.map((e) {
      return {
        'text': e.text,
        'owner': e.owner.name, // system, home, away, clash
        'homeArmy': finalState.homeArmy,
        'awayArmy': finalState.awayArmy,
        'homeResources': finalState.homeResources,
        'awayResources': finalState.awayResources,
      };
    }).toList(),
  };
}

/// 다경기 로그를 JSON 파일로 저장
Future<void> exportLogsToJson({
  required String matchup,
  required String? scenarioId,
  required List<Map<String, dynamic>> games,
  required String outputPath,
  Map<String, int>? branchStats,
}) async {
  final data = {
    'matchup': matchup,
    'scenarioId': scenarioId,
    'exportedAt': DateTime.now().toIso8601String(),
    'gameCount': games.length,
    'branchStats': branchStats,
    'games': games,
  };

  final file = File(outputPath);
  await file.parent.create(recursive: true);
  await file.writeAsString(
    const JsonEncoder.withIndent('  ').convert(data),
    flush: true,
  );
}
