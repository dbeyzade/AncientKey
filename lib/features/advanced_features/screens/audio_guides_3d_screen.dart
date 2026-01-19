import 'package:flutter/material.dart';

import '../../../core/widgets/cyber_background.dart';
import '../../audio/audio_guide_player_screen.dart';
import '../../maps/data/ancient_maps.dart';

class AudioGuides3DScreen extends StatelessWidget {
  const AudioGuides3DScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final maps = kAncientMaps;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sesli Rehberler'),
        backgroundColor: Colors.black87,
        elevation: 0,
      ),
      body: Stack(
        children: [
          const CyberBackground(),
          SafeArea(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: maps.length,
              itemBuilder: (context, index) {
                final map = maps[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.deepPurple,
                      child: Icon(Icons.headphones, color: Colors.white),
                    ),
                    title: Text(map.name),
                    subtitle: Text('${map.era} • ${map.highlight}'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AudioGuidePlayerScreen(
                            mapId: map.id,
                            mapName: map.name,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
