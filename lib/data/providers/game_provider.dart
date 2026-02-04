import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/models.dart';
import '../repositories/save_repository.dart';

/// 저장소 Provider
final saveRepositoryProvider = Provider<SaveRepository>((ref) {
  return SaveRepository();
});

/// 슬롯 정보 목록 Provider
final slotInfoListProvider = FutureProvider<List<SaveSlotInfo>>((ref) async {
  final repository = ref.watch(saveRepositoryProvider);
  return repository.getSlotInfoList();
});

/// 현재 게임 상태 Provider
final gameStateProvider = StateNotifierProvider<GameStateNotifier, GameState?>((ref) {
  final repository = ref.watch(saveRepositoryProvider);
  return GameStateNotifier(repository);
});

/// 게임 상태
class GameState {
  final SaveData saveData;
  final bool isLoading;
  final String? error;

  const GameState({
    required this.saveData,
    this.isLoading = false,
    this.error,
  });

  // 편의 getter
  Team get playerTeam => saveData.playerTeam;
  Season get currentSeason => saveData.currentSeason;
  Inventory get inventory => saveData.inventory;

  List<Player> get playerTeamPlayers => saveData.getTeamPlayers(playerTeam.id);

  GameState copyWith({
    SaveData? saveData,
    bool? isLoading,
    String? error,
  }) {
    return GameState(
      saveData: saveData ?? this.saveData,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// 게임 상태 관리자
class GameStateNotifier extends StateNotifier<GameState?> {
  final SaveRepository _repository;

  GameStateNotifier(this._repository) : super(null);

  /// 새 게임 시작
  Future<void> startNewGame({
    required int slotNumber,
    required String selectedTeamId,
  }) async {
    final saveData = _repository.createNewGame(
      slotNumber: slotNumber,
      selectedTeamId: selectedTeamId,
    );

    state = GameState(saveData: saveData);

    // 자동 저장
    await save();
  }

  /// 게임 로드
  Future<bool> loadGame(int slotNumber) async {
    final saveData = await _repository.load(slotNumber);
    if (saveData == null) return false;

    state = GameState(saveData: saveData);
    return true;
  }

  /// 게임 저장
  Future<void> save() async {
    if (state == null) return;

    final updatedSaveData = state!.saveData.updateSavedAt();
    await _repository.save(updatedSaveData);

    state = state!.copyWith(saveData: updatedSaveData);
  }

  /// 선수 업데이트
  void updatePlayer(Player player) {
    if (state == null) return;

    final newSaveData = state!.saveData.updatePlayer(player);
    state = state!.copyWith(saveData: newSaveData);
  }

  /// 여러 선수 업데이트
  void updatePlayers(List<Player> players) {
    if (state == null) return;

    final newSaveData = state!.saveData.updatePlayers(players);
    state = state!.copyWith(saveData: newSaveData);
  }

  /// 팀 업데이트
  void updateTeam(Team team) {
    if (state == null) return;

    final newSaveData = state!.saveData.updateTeam(team);
    state = state!.copyWith(saveData: newSaveData);
  }

  /// 시즌 업데이트
  void updateSeason(Season season) {
    if (state == null) return;

    final newSaveData = state!.saveData.updateSeason(season);
    state = state!.copyWith(saveData: newSaveData);
  }

  /// 인벤토리 업데이트
  void updateInventory(Inventory inventory) {
    if (state == null) return;

    final newSaveData = state!.saveData.updateInventory(inventory);
    state = state!.copyWith(saveData: newSaveData);
  }

  /// 행동: 휴식
  void playerRest(String playerId) {
    if (state == null) return;

    final team = state!.playerTeam;
    if (team.actionPoints < 50) return; // 행동력 부족

    final player = state!.saveData.getPlayerById(playerId);
    if (player == null) return;

    final updatedPlayer = player.applyRest();
    final updatedTeam = team.spendActionPoints(50);

    updatePlayer(updatedPlayer);
    updateTeam(updatedTeam);
  }

  /// 행동: 특훈
  void playerTraining(String playerId) {
    if (state == null) return;

    final team = state!.playerTeam;
    if (team.actionPoints < 100) return; // 행동력 부족

    final player = state!.saveData.getPlayerById(playerId);
    if (player == null) return;

    final updatedPlayer = player.applyTraining();
    final updatedTeam = team.spendActionPoints(100);

    updatePlayer(updatedPlayer);
    updateTeam(updatedTeam);
  }

  /// 행동: 팬미팅
  (bool gotCheerful, int moneyEarned) playerFanMeeting(String playerId) {
    if (state == null) return (false, 0);

    final team = state!.playerTeam;
    if (team.actionPoints < 200) return (false, 0); // 행동력 부족

    final player = state!.saveData.getPlayerById(playerId);
    if (player == null) return (false, 0);

    final updatedPlayer = player.applyFanMeeting();

    // 치어풀 획득 확률 계산
    final grade = player.grade;
    double cheerfulChance;
    if (grade.index >= Grade.sss.index) {
      cheerfulChance = 0.55;
    } else if (grade.index >= Grade.ssMinus.index) {
      cheerfulChance = 0.50;
    } else if (grade.index >= Grade.sMinus.index) {
      cheerfulChance = 0.45;
    } else if (grade.index >= Grade.aMinus.index) {
      cheerfulChance = 0.40;
    } else {
      cheerfulChance = 0.35;
    }

    final random = DateTime.now().millisecondsSinceEpoch;
    final gotCheerful = (random % 100) / 100.0 < cheerfulChance;

    // 소지금 획득량 계산
    int minMoney, maxMoney;
    if (grade.index >= Grade.sss.index) {
      minMoney = 100;
      maxMoney = 150;
    } else if (grade.index >= Grade.ssMinus.index) {
      minMoney = 50;
      maxMoney = 100;
    } else if (grade.index >= Grade.sMinus.index) {
      minMoney = 35;
      maxMoney = 50;
    } else if (grade.index >= Grade.bMinus.index) {
      minMoney = 20;
      maxMoney = 45;
    } else {
      minMoney = 10;
      maxMoney = 35;
    }
    final moneyEarned = minMoney + (random % (maxMoney - minMoney + 1));

    var updatedTeam = team.spendActionPoints(200).addMoney(moneyEarned);
    var updatedInventory = state!.inventory;

    if (gotCheerful) {
      updatedInventory = updatedInventory.addConsumable('cheerful');
    }

    updatePlayer(updatedPlayer);
    updateTeam(updatedTeam);
    updateInventory(updatedInventory);

    return (gotCheerful, moneyEarned);
  }

  /// 아이템 구매
  bool buyItem(String itemId, int price) {
    if (state == null) return false;

    final team = state!.playerTeam;
    if (team.money < price) return false;

    final updatedTeam = team.spendMoney(price);
    final updatedInventory = state!.inventory.addConsumable(itemId);

    updateTeam(updatedTeam);
    updateInventory(updatedInventory);

    return true;
  }

  /// 장비 구매
  bool buyEquipment(Equipment equipment) {
    if (state == null) return false;

    final team = state!.playerTeam;
    if (team.money < equipment.price) return false;

    final instance = EquipmentInstance(
      equipmentId: equipment.id,
      currentDurability: equipment.durability,
    );

    final updatedTeam = team.spendMoney(equipment.price);
    final updatedInventory = state!.inventory.addEquipment(instance);

    updateTeam(updatedTeam);
    updateInventory(updatedInventory);

    return true;
  }

  /// 2경기 완료 보너스 적용
  void applyTwoMatchBonus() {
    if (state == null) return;

    // 팀 행동력 +100
    final updatedTeam = state!.playerTeam.applyTwoMatchBonus();
    updateTeam(updatedTeam);

    // 전체 선수 컨디션 +5
    final players = state!.playerTeamPlayers;
    final updatedPlayers = players.map((p) {
      return p.copyWith(condition: (p.condition + 5).clamp(0, 110));
    }).toList();
    updatePlayers(updatedPlayers);
  }

  /// 개인리그 대진표 업데이트
  void updateIndividualLeague(IndividualLeagueBracket bracket) {
    if (state == null) return;

    final updatedSeason = state!.saveData.currentSeason.updateIndividualLeague(bracket);
    final newSaveData = state!.saveData.updateSeason(updatedSeason);
    state = state!.copyWith(saveData: newSaveData);
  }
}

/// 현재 플레이어 팀 선수 목록 Provider
final playerTeamPlayersProvider = Provider<List<Player>>((ref) {
  final gameState = ref.watch(gameStateProvider);
  if (gameState == null) return [];
  return gameState.playerTeamPlayers;
});

/// 특정 팀 선수 목록 Provider
final teamPlayersProvider = Provider.family<List<Player>, String>((ref, teamId) {
  final gameState = ref.watch(gameStateProvider);
  if (gameState == null) return [];
  return gameState.saveData.getTeamPlayers(teamId);
});

/// 모든 팀 목록 Provider
final allTeamsProvider = Provider<List<Team>>((ref) {
  final gameState = ref.watch(gameStateProvider);
  if (gameState == null) return [];
  return gameState.saveData.allTeams;
});

/// 현재 시즌 Provider
final currentSeasonProvider = Provider<Season?>((ref) {
  final gameState = ref.watch(gameStateProvider);
  return gameState?.currentSeason;
});

/// 인벤토리 Provider
final inventoryProvider = Provider<Inventory>((ref) {
  final gameState = ref.watch(gameStateProvider);
  return gameState?.inventory ?? const Inventory();
});
