import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;
  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0D8F87), Color(0xFF0AA69A)],
        ),
      ),
      child: Stack(
        children: [
          // Decorative blurred circles similar to the reference image
          Positioned(
            top: -60,
            left: -40,
            child: _circle(160, AppColors.accent.withOpacity(0.25)),
          ),
          Positioned(
            bottom: -50,
            right: -40,
            child: _circle(220, Colors.black.withOpacity(0.12)),
          ),
          Positioned.fill(
            child: Center(child: child),
          )
        ],
      ),
    );
  }

  Widget _circle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: color, blurRadius: 60, spreadRadius: 10),
        ],
      ),
    );
  }
}
