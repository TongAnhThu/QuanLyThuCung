import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class AuthCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const AuthCard({super.key, required this.title, required this.children});

  // 🎨 Palette xanh pastel -> xanh dương (đậm hơn #BDE0FE)
  static const Color kTop = Color(0xFF7FC8FF); // xanh pastel sáng
  static const Color kBottom = Color(0xFF1E90FF); // xanh dương đậm (DodgerBlue)

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final cardWidth = width > 480 ? 420.0 : width * 0.9;

    return Container(
      width: cardWidth,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [kTop, kBottom],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.22),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 8),
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white.withOpacity(0.18),
            child: const Icon(Icons.pets, color: Colors.white, size: 36),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          ),
        ],
      ),
    );
  }
}

class GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  const GradientButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  // Đồng bộ màu với AuthCard
  static const Color kTop = AuthCard.kTop;
  static const Color kBottom = AuthCard.kBottom;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onPressed,
      child: Ink(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [kTop, kBottom],
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Container(
          height: 48,
          alignment: Alignment.center,
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}
