import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'features/intro/intro_video_screen.dart';

class AncientKeyApp extends ConsumerWidget {
  const AncientKeyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AncientKey',
      theme: _getSafeTheme(),
      home: const SafeHome(),
    );
  }

  ThemeData _getSafeTheme() {
    try {
      return AppTheme.theme();
    } catch (e) {
      debugPrint('Theme initialization error: $e');
      return ThemeData.dark();
    }
  }
}

class SafeHome extends StatelessWidget {
  const SafeHome({super.key});

  @override
  Widget build(BuildContext context) {
    return const IntroVideoScreen();
  }
}
