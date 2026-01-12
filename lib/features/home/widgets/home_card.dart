import 'package:flutter/material.dart';
import '../../../theme/home_colors.dart';

class HomeCard extends StatelessWidget {
  final Map<String, String> item;
  final IconData icon;

  const HomeCard({super.key, required this.item, required this.icon});

  Widget _buildImage(String path) {
    final p = path.trim();

    if (p.isEmpty) {
      return Container(
        height: 80,
        width: double.infinity,
        color: HomeColors.softBg,
        alignment: Alignment.center,
        child: Icon(icon, color: HomeColors.primaryDark, size: 40),
      );
    }

    // ✅ URL từ Firebase / web
    if (p.startsWith('http://') || p.startsWith('https://')) {
      return Image.network(
        p,
        height: 80,
        width: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Container(
            height: 80,
            width: double.infinity,
            color: HomeColors.softBg,
            alignment: Alignment.center,
            child: const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        },
        errorBuilder: (context, error, stack) {
          return Container(
            height: 80,
            width: double.infinity,
            color: HomeColors.softBg,
            alignment: Alignment.center,
            child: Icon(Icons.broken_image, color: HomeColors.primaryDark, size: 34),
          );
        },
      );
    }

    // ✅ asset local
    return Image.asset(
      p,
      height: 80,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stack) {
        return Container(
          height: 80,
          width: double.infinity,
          color: HomeColors.softBg,
          alignment: Alignment.center,
          child: Icon(Icons.broken_image, color: HomeColors.primaryDark, size: 34),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final img = item['image'] ?? '';

    return Container(
      width: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: _buildImage(img),
          ),
          const SizedBox(height: 10),
          Text(
            item['name'] ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            item['subtitle'] ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 13, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }
}
