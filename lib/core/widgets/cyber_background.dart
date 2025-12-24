import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ancientkey/core/theme/app_theme.dart';

class CyberBackground extends StatelessWidget {
  const CyberBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final random = Random(42);
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF050A16), Color(0xFF0A1A2E), Color(0xFF0E2338)],
        ),
      ),
      child: Stack(
        children: List.generate(5, (index) {
          final size = 220.0 + random.nextInt(120);
          final top = random.nextDouble() * 600;
          final left = random.nextDouble() * MediaQuery.of(context).size.width;
          final color = index.isEven ? AppTheme.neonCyan : AppTheme.neonPink;
          return Positioned(
            top: top,
            left: left - size / 2,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [color.withValues(alpha: 0.23), color.withValues(alpha: 0)],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class GlassPanel extends StatelessWidget {
  const GlassPanel({super.key, required this.child, this.padding, this.margin});

  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
        gradient: LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0.05),
            Colors.white.withValues(alpha: 0.02),
          ],
        ),
      ),
      child: child,
    );
  }
}
