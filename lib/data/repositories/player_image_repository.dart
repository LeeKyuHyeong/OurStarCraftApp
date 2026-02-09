import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// 선수 사진을 기기 전역으로 관리하는 저장소
/// 세이브 데이터와 독립적으로 playerId → imagePath 매핑을 JSON 파일로 저장
class PlayerImageRepository {
  static PlayerImageRepository? _instance;
  static PlayerImageRepository get instance {
    _instance ??= PlayerImageRepository._();
    return _instance!;
  }

  PlayerImageRepository._();

  Map<String, String> _imageMap = {};
  bool _loaded = false;

  Future<String> get _filePath async {
    final appDir = await getApplicationDocumentsDirectory();
    return '${appDir.path}/player_images.json';
  }

  Future<String> get _imagesDirPath async {
    final appDir = await getApplicationDocumentsDirectory();
    return '${appDir.path}/player_images';
  }

  /// 초기 로드 (앱 시작 시 한 번)
  Future<void> load() async {
    if (_loaded) return;
    final file = File(await _filePath);
    if (await file.exists()) {
      final json = await file.readAsString();
      final decoded = jsonDecode(json) as Map<String, dynamic>;
      _imageMap = decoded.map((k, v) => MapEntry(k, v as String));
    }
    _loaded = true;
  }

  Future<void> _save() async {
    final file = File(await _filePath);
    await file.writeAsString(jsonEncode(_imageMap));
  }

  /// 선수 사진 경로 조회
  String? getImagePath(String playerId) {
    final path = _imageMap[playerId];
    if (path != null && File(path).existsSync()) {
      return path;
    }
    return null;
  }

  /// 선수 사진 등록/변경
  Future<void> setImagePath(String playerId, String sourcePath) async {
    final imagesDir = Directory(await _imagesDirPath);
    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }

    // 기존 이미지 삭제
    await removeImage(playerId, saveAfter: false);

    // 새 이미지 복사
    final fileName = '${playerId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final savedPath = '${imagesDir.path}/$fileName';
    await File(sourcePath).copy(savedPath);

    _imageMap[playerId] = savedPath;
    await _save();
  }

  /// 선수 사진 삭제
  Future<void> removeImage(String playerId, {bool saveAfter = true}) async {
    final oldPath = _imageMap[playerId];
    if (oldPath != null) {
      final oldFile = File(oldPath);
      if (await oldFile.exists()) {
        await oldFile.delete();
      }
      _imageMap.remove(playerId);
      if (saveAfter) await _save();
    }
  }
}
