import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:ancientkey/core/theme/app_theme.dart';
import 'package:ancientkey/core/widgets/cyber_background.dart';

class MapsAndInfoVideoScreen extends StatefulWidget {
  const MapsAndInfoVideoScreen({super.key});

  @override
  State<MapsAndInfoVideoScreen> createState() => _MapsAndInfoVideoScreenState();
}

class _MapsAndInfoVideoScreenState extends State<MapsAndInfoVideoScreen> {
  late VideoPlayerController _controller;
  bool _showHint = true;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/intro_video.mov')
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });

    // Hide hint after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showHint = false;
        });
      }
    });

    // Auto-dismiss when video ends
    _controller.addListener(() {
      if (_controller.value.isInitialized &&
          _controller.value.position >= _controller.value.duration) {
        Navigator.of(context).pop(true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const CyberBackground(),
          if (_controller.value.isInitialized)
            GestureDetector(
              onTap: () => Navigator.of(context).pop(true),
              child: SizedBox.expand(child: VideoPlayer(_controller)),
            )
          else
            const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.neonCyan),
              ),
            ),
          // Close button
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black54,
                ),
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
              ),
            ),
          ),
          // Hint text
          if (_showHint)
            SafeArea(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black54,
                      border: Border.all(
                        color: AppTheme.neonCyan.withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.touch_app,
                          color: AppTheme.neonCyan,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Ekrana tıkla - Geri dön',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
