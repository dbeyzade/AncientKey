import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import '../../core/services/achievement_service.dart';
import '../../core/services/visit_tracking_service.dart';

class ShareExperienceService {
  final ScreenshotController screenshotController = ScreenshotController();

  Future<void> shareProgress(UserProgress progress, int visitedPlaces) async {
    final text = '''
🗺️ AncientKey Yolculuğum

⭐ Seviye: ${progress.level}
🏆 XP: ${progress.experiencePoints}
📍 Gezilen Yerler: $visitedPlaces
🗺️ Keşfedilen Haritalar: ${progress.mapsExplored}

#AncientKey #TarihiKeşfet #Gezgin
    ''';

    await Share.share(text, subject: 'AncientKey Yolculuğum');
  }

  Future<void> shareAchievement(Achievement achievement) async {
    final text = '''
🏆 Yeni Başarı Kazandım!

${achievement.icon} ${achievement.name}
${achievement.description}

#AncientKey #Achievement
    ''';

    await Share.share(text, subject: 'Yeni Başarı!');
  }

  Future<void> shareVisitedPlace(String placeName, String? imagePath) async {
    final text = '''
📍 $placeName konumunu ziyaret ettim!

AncientKey ile tarihi yerleri keşfediyorum 🗺️

#AncientKey #Seyahat #TarihiYerler
    ''';

    if (imagePath != null && await File(imagePath).exists()) {
      await Share.shareXFiles(
        [XFile(imagePath)],
        text: text,
        subject: 'Ziyaret',
      );
    } else {
      await Share.share(text, subject: 'Ziyaret');
    }
  }

  Future<void> shareScreenshot(BuildContext context) async {
    try {
      final image = await screenshotController.capture();
      if (image == null) return;

      final directory = await getTemporaryDirectory();
      final imagePath = '${directory.path}/screenshot.png';
      final imageFile = File(imagePath);
      await imageFile.writeAsBytes(image);

      await Share.shareXFiles(
        [XFile(imagePath)],
        text: 'AncientKey ile tarihi yerleri keşfediyorum! 🗺️',
        subject: 'AncientKey',
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Paylaşım hatası: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> shareMapWithStats(
    String mapName,
    int visitedPlaces,
    String? imagePath,
  ) async {
    final text = '''
🗺️ $mapName haritasını keşfettim!

📍 Bu haritada $visitedPlaces yer ziyaret ettim
    
AncientKey ile tarihi yerleri keşfet! 

#AncientKey #$mapName
    ''';

    if (imagePath != null && await File(imagePath).exists()) {
      await Share.shareXFiles(
        [XFile(imagePath)],
        text: text,
        subject: mapName,
      );
    } else {
      await Share.share(text, subject: mapName);
    }
  }
}

final shareExperienceServiceProvider = Provider<ShareExperienceService>((ref) {
  return ShareExperienceService();
});

// Share Button Widget
class ShareButton extends ConsumerWidget {
  final VoidCallback onShare;
  final String tooltip;

  const ShareButton({
    super.key,
    required this.onShare,
    this.tooltip = 'Paylaş',
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: const Icon(Icons.share),
      onPressed: onShare,
      tooltip: tooltip,
      color: Colors.deepPurple,
    );
  }
}

// Share Menu Bottom Sheet
class ShareMenuBottomSheet extends ConsumerWidget {
  final String mapId;
  final String mapName;

  const ShareMenuBottomSheet({
    super.key,
    required this.mapId,
    required this.mapName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shareService = ref.read(shareExperienceServiceProvider);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Paylaş',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          _ShareOptionTile(
            icon: Icons.star,
            title: 'İlerleme Durumumu Paylaş',
            onTap: () async {
              final progress = await ref.read(achievementServiceProvider).getUserProgress();
              final visitedPlaces = await ref.read(visitTrackingServiceProvider).getTotalVisitedPlaces();
              await shareService.shareProgress(progress, visitedPlaces);
              if (context.mounted) Navigator.pop(context);
            },
          ),
          _ShareOptionTile(
            icon: Icons.map,
            title: 'Bu Haritayı Paylaş',
            onTap: () async {
              final visitedPlaces = (await ref
                      .read(visitTrackingServiceProvider)
                      .getVisitedPlacesByMapId(mapId))
                  .length;
              await shareService.shareMapWithStats(mapName, visitedPlaces, null);
              if (context.mounted) Navigator.pop(context);
            },
          ),
          _ShareOptionTile(
            icon: Icons.screenshot,
            title: 'Ekran Görüntüsü Paylaş',
            onTap: () async {
              await shareService.shareScreenshot(context);
              if (context.mounted) Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

class _ShareOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ShareOptionTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.deepPurple.withOpacity(0.1),
          child: Icon(icon, color: Colors.deepPurple),
        ),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
