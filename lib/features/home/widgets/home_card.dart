import 'package:flutter/material.dart';
import '../../../theme/home_colors.dart';

class HomeCard extends StatelessWidget {
  final Map<String, String> item;
  final IconData icon;

  const HomeCard({super.key, required this.item, required this.icon});

  @override
  Widget build(BuildContext context) {
    final img = item['image'];

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
            child: (img != null && img.isNotEmpty)
                ? Image.asset(
                    img,
                    height: 80,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Container(
                    height: 80,
                    width: double.infinity,
                    color: HomeColors.softBg,
                    alignment: Alignment.center,
                    child: Icon(icon, color: HomeColors.primaryDark, size: 40),
                  ),
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
