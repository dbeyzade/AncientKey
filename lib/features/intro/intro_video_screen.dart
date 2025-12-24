import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

import '../maps/presentation/screens/map_dashboard_screen.dart';

class IntroVideoScreen extends StatefulWidget {
  const IntroVideoScreen({super.key});

  @override
  State<IntroVideoScreen> createState() => _IntroVideoScreenState();
}

class _IntroVideoScreenState extends State<IntroVideoScreen> {
  late final VideoPlayerController _controller;
  bool _initialized = false;
  bool _showQuote = false;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    // Enable fullscreen mode
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    _initVideo();
  }

  Future<void> _initVideo() async {
    try {
      _controller = VideoPlayerController.asset('assets/videos/34tr.mov');
      await _controller.initialize();
      _controller.setLooping(false);
      
      // Add listener for video completion
      _controller.addListener(_onVideoStatusChanged);
      
      await _controller.play();
      _initialized = true;
    } catch (e) {
      print('Error loading video: $e');
      _goToApp();
    }
    if (mounted) setState(() {});
  }

  void _onVideoStatusChanged() {
    if (!_controller.value.isInitialized) return;
    
    final duration = _controller.value.duration;
    final position = _controller.value.position;
    
    // Check if video has finished playing
    if (position >= duration && duration > Duration.zero && !_showQuote) {
      _onVideoComplete();
    }
  }

  void _onVideoComplete() {
    if (!mounted) return;
    setState(() {
      _showQuote = true;
    });
    // 10 seconds for the quote to be visible
    Future.delayed(const Duration(seconds: 10), _goToApp);
  }

  void _skipVideo() {
    if (!mounted || _navigated) return;
    _goToApp();
  }

  void _goToApp() {
    if (!mounted || _navigated) return;
    _navigated = true;
    // Reset system UI mode
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MapDashboardScreen()),
    );
  }

  @override
  void dispose() {
    if (_initialized) {
      _controller.removeListener(_onVideoStatusChanged);
      _controller.dispose();
    }
    // Reset system UI mode
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: _showQuote
                ? _QuoteView(onDone: _goToApp)
                : _initialized
                    ? SizedBox.expand(
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                            width: _controller.value.size.width,
                            height: _controller.value.size.height,
                            child: VideoPlayer(_controller),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
          ),
          // Skip button for both video and quote
          if (_initialized)
            Positioned(
              top: 40,
              right: 20,
              child: SafeArea(
                child: FloatingActionButton(
                  mini: true,
                  backgroundColor: Colors.white.withOpacity(0.7),
                  onPressed: _skipVideo,
                  child: const Icon(Icons.skip_next, color: Colors.black),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _QuoteView extends StatefulWidget {
  const _QuoteView({required this.onDone});
  final VoidCallback onDone;

  @override
  State<_QuoteView> createState() => _QuoteViewState();
}

class _QuoteViewState extends State<_QuoteView>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    // Start fade out after 10 seconds
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) {
        _fadeController.forward();
      }
    });

    // Navigate after fade out completes
    Future.delayed(const Duration(seconds: 12), widget.onDone);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'İyi bir karakterin zenginlik ve paranın yerini tutabileceğini düşünmek yanlıştır, ama zenginlik ve diğer her iyiliğin iyi bir karakterden kaynaklandığını söylemek doğrudur.',
              style: GoogleFonts.playfairDisplay(
                fontSize: 20,
                color: Colors.white,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Text(
              'Platon',
              style: GoogleFonts.dancingScript(
                fontSize: 32,
                color: Colors.white70,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
