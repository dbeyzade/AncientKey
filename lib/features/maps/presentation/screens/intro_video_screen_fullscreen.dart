import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class IntroVideoScreenFullscreen extends StatefulWidget {
  const IntroVideoScreenFullscreen({super.key});

  @override
  State<IntroVideoScreenFullscreen> createState() => _IntroVideoScreenFullscreenState();
}

class _IntroVideoScreenFullscreenState extends State<IntroVideoScreenFullscreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/intro_video.mov')
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      })
      ..addListener(_onVideoEnd);
  }

  void _onVideoEnd() {
    if (_controller.value.position >= _controller.value.duration) {
      if (mounted) {
        Navigator.pop(context, true);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Video Player - UI olmadan
          Center(
            child: _controller.value.isInitialized
                ? GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                  )
                : const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
          ),
          // Geri dönüş butonu (sabit, ayarlamadan)
          Positioned(
            top: 20,
            left: 20,
            child: SafeArea(
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 28),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          // Ekrana tıkla uyarısı (ilk 3 saniye)
          if (_controller.value.position.inSeconds < 3)
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Ekrana tıkla - Geri dön',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

