import 'package:flutter/material.dart';
import 'home_card.dart';

class HomeSection extends StatelessWidget {
  final String title;
  final List<Map<String, String>> items;
  final IconData icon;
  final VoidCallback onViewMore;

  const HomeSection({
    super.key,
    required this.title,
    required this.items,
    required this.icon,
    required this.onViewMore,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            TextButton(onPressed: onViewMore, child: const Text('Xem thêm')),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 170,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return HomeCard(item: items[index], icon: icon);
            },
          ),
        ),
      ],
    );
  }
}
