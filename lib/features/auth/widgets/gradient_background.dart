import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;
  const GradientBackground({super.key, required this.child});

  // 🎨 Nền pastel -> xanh dương
  static const Color kBgTopLeft = Color(0xFFE8F2FF); // nền rất nhạt
  static const Color kBgBottomRight = Color(
    0xFFBDE0FE,
  ); // pastel xanh (đậm hơn chút)

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [kBgTopLeft, kBgBottomRight],
        ),
      ),
      child: Stack(
        children: [
          // Decorative blurred circles
          Positioned(
            top: -60,
            left: -40,
            child: _circle(160, const Color(0xFF7FC8FF).withOpacity(0.35)),
          ),
          Positioned(
            bottom: -50,
            right: -40,
            child: _circle(220, const Color(0xFF1E90FF).withOpacity(0.18)),
          ),
          Positioned.fill(child: Center(child: child)),
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
        boxShadow: [BoxShadow(color: color, blurRadius: 60, spreadRadius: 10)],
      ),
    );
  }
}
