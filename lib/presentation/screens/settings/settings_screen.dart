import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/constants/initial_data.dart';
import '../../../core/utils/responsive.dart';
import '../../../data/repositories/player_image_repository.dart';
import '../../../domain/models/models.dart';

/// 설정 화면 - 선수 사진 관리 (타이틀에서 접근, gameState 불필요)
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _imageRepo = PlayerImageRepository.instance;
  late final List<Player> _allPlayers;
  late final List<Team> _allTeams;
  String? _selectedTeamId;

  @override
  void initState() {
    super.initState();
    _allTeams = InitialData.createTeams();
    _allPlayers = InitialData.createPlayers();
    _selectedTeamId = _allTeams.first.id;
  }

  List<Player> get _currentPlayers {
    return _allPlayers.where((p) => p.teamId == _selectedTeamId).toList();
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0a0a12),
      body: SafeArea(
        child: Column(
          children: [
            // 헤더
            _buildHeader(),

            // 팀 선택
            _buildTeamSelector(),

            // 섹션 헤더
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 8.sp),
              color: const Color(0xFF1a1a2e),
              child: Text(
                '선수 사진 관리',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
            ),

            // 선수 사진 그리드
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.all(10.sp),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8.sp,
                  mainAxisSpacing: 8.sp,
                  childAspectRatio: 0.75,
                ),
                itemCount: _currentPlayers.length,
                itemBuilder: (context, index) {
                  return _buildPlayerPhotoCard(_currentPlayers[index]);
                },
              ),
            ),

            // 하단 돌아가기 버튼
            Padding(
              padding: EdgeInsets.all(12.sp),
              child: SizedBox(
                width: double.infinity,
                height: 44.sp,
                child: ElevatedButton(
                  onPressed: () => context.go('/'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2a2a3e),
                    foregroundColor: Colors.white70,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.sp),
                    ),
                  ),
                  child: Text(
                    '돌아가기',
                    style: TextStyle(fontSize: 14.sp),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.sp, horizontal: 16.sp),
      decoration: BoxDecoration(
        color: const Color(0xFF1a1a2e),
        border: Border(
          bottom: BorderSide(color: Colors.grey[800]!, width: 2),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.settings, color: Colors.amber, size: 22.sp),
          SizedBox(width: 8.sp),
          Text(
            '설정',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamSelector() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 8.sp),
      color: const Color(0xFF12121a),
      child: Row(
        children: [
          Text(
            '팀: ',
            style: TextStyle(color: Colors.grey[400], fontSize: 12.sp),
          ),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedTeamId,
                dropdownColor: const Color(0xFF1a1a2e),
                isExpanded: true,
                icon: Icon(Icons.arrow_drop_down, color: Colors.amber, size: 22.sp),
                items: _allTeams.map((team) {
                  final teamColor = Color(team.colorValue);
                  return DropdownMenuItem<String>(
                    value: team.id,
                    child: Row(
                      children: [
                        Container(
                          width: 20.sp,
                          height: 20.sp,
                          decoration: BoxDecoration(
                            color: teamColor.withValues(alpha: 0.3),
                            shape: BoxShape.circle,
                            border: Border.all(color: teamColor, width: 1),
                          ),
                          child: Center(
                            child: Text(
                              team.shortName.length >= 2
                                  ? team.shortName.substring(0, 2)
                                  : team.shortName,
                              style: TextStyle(
                                color: teamColor,
                                fontSize: 7.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8.sp),
                        Text(
                          team.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.sp,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedTeamId = value;
                    });
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerPhotoCard(Player player) {
    final imagePath = _imageRepo.getImagePath(player.id);
    final hasImage = imagePath != null;
    final raceColor = _getRaceColor(player.race);

    return GestureDetector(
      onTap: () => _showImageOptions(player),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1a1a2e),
          borderRadius: BorderRadius.circular(8.sp),
          border: Border.all(
            color: hasImage ? raceColor : Colors.grey[700]!,
            width: hasImage ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            // 사진 영역
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: raceColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(7.sp)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(7.sp)),
                  child: hasImage
                      ? Image.file(
                          File(imagePath),
                          fit: BoxFit.cover,
                        )
                      : Center(
                          child: Icon(
                            Icons.add_a_photo,
                            size: 24.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                ),
              ),
            ),
            // 선수 이름 + 종족
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 4.sp, vertical: 5.sp),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(7.sp)),
              ),
              child: Column(
                children: [
                  Text(
                    player.name,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    player.race.code,
                    style: TextStyle(fontSize: 8.sp, color: raceColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showImageOptions(Player player) {
    final hasImage = _imageRepo.getImagePath(player.id) != null;

    if (!hasImage) {
      _pickPlayerImage(player);
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1a1a2e),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12.sp)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(12.sp),
              child: Text(
                player.name,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.white),
              title: Text(
                '사진 변경',
                style: TextStyle(color: Colors.white, fontSize: 13.sp),
              ),
              onTap: () {
                Navigator.pop(context);
                _pickPlayerImage(player);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: Text(
                '사진 삭제',
                style: TextStyle(color: Colors.red, fontSize: 13.sp),
              ),
              onTap: () async {
                Navigator.pop(context);
                await _deletePlayerImage(player);
              },
            ),
            SizedBox(height: 8.sp),
          ],
        ),
      ),
    );
  }

  Future<void> _pickPlayerImage(Player player) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );

    if (pickedFile == null) return;

    await _imageRepo.setImagePath(player.id, pickedFile.path);

    if (mounted) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${player.name} 사진이 등록되었습니다'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _deletePlayerImage(Player player) async {
    await _imageRepo.removeImage(player.id);

    if (mounted) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${player.name} 사진이 삭제되었습니다'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Color _getRaceColor(Race race) {
    switch (race) {
      case Race.terran:
        return Colors.blue;
      case Race.zerg:
        return Colors.purple;
      case Race.protoss:
        return Colors.amber;
    }
  }
}
