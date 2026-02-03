import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';

class MainMenuScreen extends ConsumerStatefulWidget {
  const MainMenuScreen({super.key});

  @override
  ConsumerState<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends ConsumerState<MainMenuScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SK텔레콤 T1'), // TODO: 실제 선택한 팀명
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => context.go('/save-load'),
            tooltip: '세이브/로드',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: 설정
            },
            tooltip: '설정',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.accentGreen,
          tabs: const [
            Tab(icon: Icon(Icons.calendar_today), text: '일정'),
            Tab(icon: Icon(Icons.people), text: '팀관리'),
            Tab(icon: Icon(Icons.store), text: '상점'),
            Tab(icon: Icon(Icons.search), text: '상대팀'),
          ],
        ),
      ),
      body: Column(
        children: [
          // 상단 정보 바
          _StatusBar(),

          // 탭 콘텐츠
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _ScheduleTab(),
                _TeamManagementTab(),
                _ShopTab(),
                _OpponentViewTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: AppTheme.cardBackground,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatusItem(
            icon: Icons.event,
            label: '시즌 1',
            value: 'R1',
          ),
          _StatusItem(
            icon: Icons.attach_money,
            label: '자금',
            value: '500만',
          ),
          _StatusItem(
            icon: Icons.flash_on,
            label: '행동력',
            value: '100',
            color: AppTheme.accentGreen,
          ),
        ],
      ),
    );
  }
}

class _StatusItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? color;

  const _StatusItem({
    required this.icon,
    required this.label,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color ?? AppTheme.textSecondary, size: 20),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color ?? AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }
}

// 일정 탭
class _ScheduleTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: 10, // TODO: 실제 일정 수
            itemBuilder: (context, index) {
              final isNext = index == 0;
              return _ScheduleCard(
                round: index + 1,
                opponent: '삼성전자 칸', // TODO: 실제 상대팀
                isNext: isNext,
                isCompleted: false,
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () => context.go('/roster-select'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentGreen,
                foregroundColor: Colors.black,
              ),
              child: const Text(
                '일정 진행',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  final int round;
  final String opponent;
  final bool isNext;
  final bool isCompleted;

  const _ScheduleCard({
    required this.round,
    required this.opponent,
    required this.isNext,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isNext ? AppTheme.primaryBlue : AppTheme.cardBackground,
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isCompleted
                    ? AppTheme.accentGreen.withOpacity(0.2)
                    : AppTheme.primaryBlue.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  'R$round',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isCompleted ? AppTheme.accentGreen : AppTheme.textPrimary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'vs $opponent',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (isNext)
                    const Text(
                      '다음 경기',
                      style: TextStyle(
                        color: AppTheme.accentGreen,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
            if (isCompleted)
              const Text(
                '4:2 승',
                style: TextStyle(
                  color: AppTheme.accentGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// 팀 관리 탭
class _TeamManagementTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 행동 버튼들
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  label: '컨디션 회복',
                  cost: 50,
                  icon: Icons.favorite,
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ActionButton(
                  label: '훈련',
                  cost: 100,
                  icon: Icons.fitness_center,
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ActionButton(
                  label: '팬미팅',
                  cost: 200,
                  icon: Icons.groups,
                  onPressed: () {},
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // 선수 목록
          const Text(
            '로스터',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...List.generate(8, (index) => _PlayerListItem(index: index)),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final int cost;
  final IconData icon;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.label,
    required this.cost,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.cardBackground,
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: Column(
        children: [
          Icon(icon, size: 24),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
          Text(
            '$cost AP',
            style: const TextStyle(
              fontSize: 10,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlayerListItem extends StatelessWidget {
  final int index;

  const _PlayerListItem({required this.index});

  @override
  Widget build(BuildContext context) {
    // TODO: 실제 선수 데이터
    final names = ['김택용', '도재욱', '정명훈', '박재혁', '이승석', '한상봉', '정경두', '권오혁'];
    final races = ['P', 'P', 'T', 'T', 'Z', 'Z', 'P', 'T'];

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.getRaceColor(races[index]),
          child: Text(
            races[index],
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(names[index]),
        subtitle: Text('컨디션: 100%'),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.getGradeColor('S'),
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Text(
            'S',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

// 상점 탭
class _ShopTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        _ShopItem(
          name: '컨디션 드링크',
          description: '컨디션 +5',
          price: 10,
        ),
        _ShopItem(
          name: '스나이퍼',
          description: '상대 예측 시 승리확률 대폭 상승',
          price: 50,
        ),
        _ShopItem(
          name: '껌',
          description: '패배 시 능력치 하락폭 감소',
          price: 30,
        ),
        _ShopItem(
          name: '세레모니',
          description: '승리 시 팀 컨디션 +1, 재화 +5',
          price: 20,
        ),
      ],
    );
  }
}

class _ShopItem extends StatelessWidget {
  final String name;
  final String description;
  final int price;

  const _ShopItem({
    required this.name,
    required this.description,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(name),
        subtitle: Text(description),
        trailing: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.accentGreen,
            foregroundColor: Colors.black,
          ),
          child: Text('${price}만'),
        ),
      ),
    );
  }
}

// 상대팀 조회 탭
class _OpponentViewTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final opponents = [
      '화승 오즈',
      '삼성전자 칸',
      'KT 롤스터',
      'CJ 엔투스',
      '웅진 스타즈',
      '하이트 스파키즈',
      'STX SouL',
      '위메이드 폭스',
      'MBC게임 히어로',
      '이스트로',
      '공군 에이스',
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: opponents.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: AppTheme.primaryBlue,
              child: Icon(Icons.groups, color: Colors.white),
            ),
            title: Text(opponents[index]),
            subtitle: const Text('순위: -위'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: 상대팀 상세 보기
            },
          ),
        );
      },
    );
  }
}
