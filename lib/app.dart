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
      theme: AppTheme.theme(),
      home: const IntroVideoScreen(),
    );
  }
}
