import 'package:flutter/material.dart';

class VideoEditorScreen extends StatefulWidget {
  const VideoEditorScreen({super.key});

  @override
  State<VideoEditorScreen> createState() => _VideoEditorScreenState();
}

class _VideoEditorScreenState extends State<VideoEditorScreen> {
  String selectedVideo = 'Şimdiye Kadar Video Yok';
  double brightness = 1.0;
  double contrast = 1.0;
  double saturation = 1.0;
  double playbackSpeed = 1.0;
  bool isPlaying = false;
  double videoProgress = 0.0;

  final List<String> videoEffects = [
    '🎬 Siyah-Beyaz',
    '🌅 Sepya',
    '❄️ Mavi Ton',
    '🔴 Kırmızı Ton',
    '🟢 Yeşil Ton',
    '🌈 Renk Artırıcı',
  ];

  final List<String> transitionEffects = [
    'Kesme',
    'Solma',
    'Kaydır',
    'Döndür',
    'Genişlet',
  ];

  List<String> appliedEffects = [];
  String selectedTransition = 'Kesme';

  void _importVideo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('📱 Video İçe Aktar'),
        content: const Text('Cihazdan bir video seçin'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              setState(() => selectedVideo = 'Antik Şehir - 5 dakika');
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('✅ Video yüklendi!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Seç'),
          ),
        ],
      ),
    );
  }

  void _togglePlayback() {
    setState(() => isPlaying = !isPlaying);
    if (isPlaying) {
      Future.delayed(const Duration(milliseconds: 100), () {
        while (isPlaying && videoProgress < 1.0) {
          Future.delayed(const Duration(milliseconds: 50), () {
            if (mounted && isPlaying) {
              setState(() => videoProgress += 0.01);
            }
          });
        }
      });
    }
  }

  void _applyEffect(String effect) {
    setState(() {
      if (appliedEffects.contains(effect)) {
        appliedEffects.remove(effect);
      } else {
        appliedEffects.add(effect);
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          appliedEffects.contains(effect)
              ? '✅ $effect uygulandı'
              : '❌ $effect kaldırıldı',
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _exportVideo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('📤 Videoyu Dışa Aktar'),
        content: const Text(
          'Video kalitesi seçin:\n\n'
          '• 1080p - 500 MB\n'
          '• 720p - 250 MB\n'
          '• 480p - 100 MB',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('✅ Video dışa aktarılıyor...'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Dışa Aktar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🎥 Video Düzenleyici'),
        backgroundColor: Colors.red[600],
        elevation: 2,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.red[600]!, Colors.pink[600]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: _exportVideo,
            tooltip: 'Dışa Aktar',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Video Preview
              Container(
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red[600]!, width: 2),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        selectedVideo,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (selectedVideo != 'Şimdiye Kadar Video Yok')
                      IconButton(
                        icon: Icon(
                          isPlaying ? Icons.pause_circle : Icons.play_circle,
                          color: Colors.red,
                          size: 48,
                        ),
                        onPressed: _togglePlayback,
                      ),
                    if (selectedVideo != 'Şimdiye Kadar Video Yok')
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            LinearProgressIndicator(
                              value: videoProgress,
                              backgroundColor: Colors.grey[700],
                              minHeight: 4,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${(videoProgress * 100).toStringAsFixed(0)}%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Import Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _importVideo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[600],
                  ),
                  child: const Text('📁 Video İçe Aktar'),
                ),
              ),
              const SizedBox(height: 24),
              // Playback Speed
              if (selectedVideo != 'Şimdiye Kadar Video Yok')
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Oynatma Hızı: ${playbackSpeed.toStringAsFixed(1)}x',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Slider(
                      value: playbackSpeed,
                      min: 0.5,
                      max: 2.0,
                      divisions: 6,
                      onChanged: (value) =>
                          setState(() => playbackSpeed = value),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              // Brightness Control
              if (selectedVideo != 'Şimdiye Kadar Video Yok')
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Parlaklık: ${(brightness * 100).toStringAsFixed(0)}%',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Slider(
                      value: brightness,
                      min: 0.5,
                      max: 1.5,
                      onChanged: (value) =>
                          setState(() => brightness = value),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              // Contrast Control
              if (selectedVideo != 'Şimdiye Kadar Video Yok')
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kontrast: ${(contrast * 100).toStringAsFixed(0)}%',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Slider(
                      value: contrast,
                      min: 0.5,
                      max: 1.5,
                      onChanged: (value) =>
                          setState(() => contrast = value),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              // Saturation Control
              if (selectedVideo != 'Şimdiye Kadar Video Yok')
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Doygunluk: ${(saturation * 100).toStringAsFixed(0)}%',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Slider(
                      value: saturation,
                      min: 0.0,
                      max: 2.0,
                      onChanged: (value) =>
                          setState(() => saturation = value),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              // Video Effects
              if (selectedVideo != 'Şimdiye Kadar Video Yok') ...[
                Text(
                  'Video Efektleri',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: videoEffects.map((effect) {
                    final isApplied = appliedEffects.contains(effect);
                    return FilterChip(
                      selected: isApplied,
                      onSelected: (_) => _applyEffect(effect),
                      label: Text(effect),
                      selectedColor: Colors.red[600],
                      labelStyle: TextStyle(
                        color: isApplied ? Colors.white : Colors.black,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                // Transitions
                Text(
                  'Geçiş Efekti',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: transitionEffects.map((transition) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          selected: selectedTransition == transition,
                          onSelected: (_) =>
                              setState(() => selectedTransition = transition),
                          label: Text(transition),
                          selectedColor: Colors.red[600],
                          labelStyle: TextStyle(
                            color: selectedTransition == transition
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
