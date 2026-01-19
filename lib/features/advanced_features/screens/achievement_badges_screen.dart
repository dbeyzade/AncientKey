import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/achievement_service.dart';

class AchievementBadgesScreen extends ConsumerStatefulWidget {
  const AchievementBadgesScreen({super.key});

  @override
  ConsumerState<AchievementBadgesScreen> createState() => _AchievementBadgesScreenState();
}

class _AchievementBadgesScreenState extends ConsumerState<AchievementBadgesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🏅 Başarım Rozetleri'),
        elevation: 2,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.amber[700]!, Colors.orange[700]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) async {
              if (value == 'unlock_all') {
                await ref.read(achievementServiceProvider).unlockAllAchievements();
                setState(() {});
              } else if (value == 'lock_all') {
                await ref.read(achievementServiceProvider).lockAllAchievements();
                setState(() {});
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'unlock_all',
                child: Row(
                  children: [
                    Icon(Icons.lock_open, color: Colors.green),
                    SizedBox(width: 8),
                    Text('Tümünü Aç'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'lock_all',
                child: Row(
                  children: [
                    Icon(Icons.lock, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Tümünü Kilitle'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder(
        future: Future.wait([
          ref.read(achievementServiceProvider).getAllAchievements(),
          ref.read(achievementServiceProvider).getUserProgress(),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          }

          final achievements = snapshot.data![0] as List<Achievement>;
          final userProgress = snapshot.data![1] as UserProgress;

          // Başarımları kategorilere ayır
          final Map<String, List<Achievement>> categorizedAchievements = {
            '🗺️ Keşif': [],
            '📸 Koleksiyon': [],
            '🎯 Uzman': [],
            '🌟 Özel': [],
          };

          for (var achievement in achievements) {
            if (achievement.name.contains('Keşif') || achievement.name.contains('Ziyaret')) {
              categorizedAchievements['🗺️ Keşif']!.add(achievement);
            } else if (achievement.name.contains('Fotoğraf') || achievement.name.contains('Not')) {
              categorizedAchievements['📸 Koleksiyon']!.add(achievement);
            } else if (achievement.name.contains('Uzman') || achievement.name.contains('Bilgin')) {
              categorizedAchievements['🎯 Uzman']!.add(achievement);
            } else {
              categorizedAchievements['🌟 Özel']!.add(achievement);
            }
          }

          final unlockedCount = achievements.where((a) => a.unlocked).length;

          return Column(
            children: [
              _buildProgressHeader(userProgress, unlockedCount, achievements.length),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    ...categorizedAchievements.entries.map((entry) {
                      if (entry.value.isEmpty) return const SizedBox.shrink();
                      return _buildCategorySection(entry.key, entry.value);
                    }),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProgressHeader(UserProgress progress, int unlocked, int total) {
    final percentage = (unlocked / total * 100).toInt();
    
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.amber[700]!, Colors.orange[600]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Seviye', '${progress.level}', Icons.trending_up),
              _buildStatItem('Rozet', '$unlocked/$total', Icons.military_tech),
              _buildStatItem('XP', '${progress.experiencePoints}', Icons.star),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: unlocked / total,
              backgroundColor: Colors.white.withValues(alpha: 0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '%$percentage Tamamlandı',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.9),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySection(String category, List<Achievement> achievements) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            category,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...achievements.map((achievement) => _buildBadgeCard(achievement)),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildBadgeCard(Achievement achievement) {
    final isUnlocked = achievement.unlocked;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isUnlocked ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isUnlocked ? Colors.amber : Colors.grey.withValues(alpha: 0.2),
          width: isUnlocked ? 2 : 1,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: isUnlocked
              ? LinearGradient(
                  colors: [
                    Colors.amber.withValues(alpha: 0.1),
                    Colors.orange.withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: isUnlocked
                  ? LinearGradient(
                      colors: [Colors.amber, Colors.orange[700]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : LinearGradient(
                      colors: [Colors.grey[300]!, Colors.grey[400]!],
                    ),
              boxShadow: isUnlocked
                  ? [
                      BoxShadow(
                        color: Colors.amber.withValues(alpha: 0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Text(
                achievement.icon,
                style: TextStyle(
                  fontSize: 28,
                  color: isUnlocked ? null : Colors.grey[600],
                ),
              ),
            ),
          ),
          title: Text(
            achievement.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: isUnlocked ? Colors.black : Colors.grey,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                achievement.description,
                style: TextStyle(
                  fontSize: 13,
                  color: isUnlocked ? Colors.black87 : Colors.grey[600],
                ),
              ),
              if (isUnlocked && achievement.unlockedAt != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 16,
                      color: Colors.green[700],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Kazanıldı: ${_formatDate(achievement.unlockedAt!)}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.green[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
          trailing: isUnlocked
              ? const Icon(Icons.check_circle, color: Colors.green, size: 32)
              : Icon(Icons.lock, color: Colors.grey[400]),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }
}
