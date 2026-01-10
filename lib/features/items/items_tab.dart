import 'package:flutter/material.dart';
import '../items/item_detail_page.dart';
import '../../../theme/home_colors.dart';

class ItemsTab extends StatefulWidget {
  const ItemsTab({super.key});

  @override
  State<ItemsTab> createState() => _ItemsTabState();
}

class _ItemsTabState extends State<ItemsTab> {
  String _selectedCategory = 'Đồ chơi';

  final List<String> _categories = const [
    'Đồ chơi',
    'Đồ ăn',
    'Quần áo',
    'Lồng',
    'Dây dắt',
    'Bảng tên',
  ];

  final Map<String, List<Map<String, String>>> _itemsByCategory = const {
    'Đồ chơi': [
      {
        'name': 'Bóng cao su',
        'price': '45.000 đ',
        'image': 'assets/images/dcbanh.jpg',
      },
      {
        'name': 'Gấu Bông',
        'price': '65.000 đ',
        'image': 'assets/images/dcgau.jpg',
      },
      {
        'name': 'Chuột nhồi bông',
        'price': '35.000 đ',
        'image': 'assets/images/dcchuot.jpg',
      },
      {
        'name': 'Chuông',
        'price': '75.000 đ',
        'image': 'assets/images/dochoichuong.jpg',
      },
      {
        'name': 'Bóng phát âm',
        'price': '55.000 đ',
        'image': 'assets/images/dochoi3.jpg',
      },
      {
        'name': 'Bóng cao su',
        'price': '45.000 đ',
        'image': 'assets/images/dcbanh.jpg',
      },
    ],
    'Đồ ăn': [
      {
        'name': 'Royal Canin 2kg',
        'price': '420.000 đ',
        'image': 'assets/images/hat.jpg',
      },
      {
        'name': 'Pate cho mèo',
        'price': '35.000 đ',
        'image': 'assets/images/patemeo.jpg',
      },
      {
        'name': 'Xương gặm sạch răng',
        'price': '25.000 đ',
        'image': 'assets/images/xuong.jpg',
      },
      {
        'name': 'Snack dinh dưỡng',
        'price': '48.000 đ',
        'image': 'assets/images/snack.jpg',
      },
      {
        'name': 'Hạt Ganador 5kg',
        'price': '550.000 đ',
        'image': 'assets/images/hat.jpg',
      },
    ],
    'Quần áo': [
      {
        'name': 'Áo hoodie',
        'price': '120.000 đ',
        'image': 'assets/images/ao1.jpg',
      },
      {'name': 'Áo mưa', 'price': '85.000 đ', 'image': 'assets/images/ao2.jpg'},
      {
        'name': 'Đầm công chúa',
        'price': '150.000 đ',
        'image': 'assets/images/ao3.jpg',
      },
      {
        'name': 'Áo len dệt kim',
        'price': '95.000 đ',
        'image': 'assets/images/ao4.jpg',
      },
      {
        'name': 'Bộ vest lịch sự',
        'price': '180.000 đ',
        'image': 'assets/images/ao5.jpg',
      },
      {
        'name': 'Áo thun cotton',
        'price': '60.000 đ',
        'image': 'assets/images/ao1.jpg',
      },
    ],
    'Lồng': [
      {
        'name': 'Lồng sắt 60cm',
        'price': '450.000 đ',
        'image': 'assets/images/long1png',
      },
      {
        'name': 'Lồng gấp gọn',
        'price': '380.000 đ',
        'image': 'assets/images/llong1png',
      },
      {
        'name': 'Nhà gỗ ngoài trời',
        'price': '850.000 đ',
        'image': 'assets/images/nhago.jpg',
      },
      {
        'name': 'Lồng mèo 3 tầng',
        'price': '1.200.000 đ',
        'image': 'assets/images/longmeo4.jpg',
      },
      {
        'name': 'Túi vận chuyển',
        'price': '220.000 đ',
        'image': 'assets/images/balomeo2.jpg',
      },
      {
        'name': 'Balo phi hành gia',
        'price': '320.000 đ',
        'image': 'assets/images/balomeo.jpg',
      },
    ],
    'Dây dắt': [
      {
        'name': 'Dây da mềm 120cm',
        'price': '180.000 đ',
        'image': 'assets/images/day1.jpg',
      },
      {
        'name': 'Dây tự cuộn 5m',
        'price': '250.000 đ',
        'image': 'assets/images/day2.jpg',
      },
      {
        'name': 'Yếm đai chữ H',
        'price': '95.000 đ',
        'image': 'assets/images/day3.jpg',
      },
      {
        'name': 'Dây nylon phản quang',
        'price': '75.000 đ',
        'image': 'assets/images/day4.jpg',
      },
      {
        'name': 'Bộ dây + yếm cao cấp',
        'price': '350.000 đ',
        'image': 'assets/images/day5.jpg',
      },
      {
        'name': 'Dây da mềm 120cm',
        'price': '180.000 đ',
        'image': 'assets/images/day1.jpg',
      },
    ],
    'Bảng tên': [
      {
        'name': 'Tag nhôm khắc laser',
        'price': '50.000 đ',
        'image': 'assets/images/ten1.jpg',
      },
      {
        'name': 'Tag hình xương inox',
        'price': '65.000 đ',
        'image': 'assets/images/ten2.png',
      },
      {
        'name': 'Vòng cổ có tên',
        'price': '120.000 đ',
        'image': 'assets/images/ten3.jpg',
      },
      {
        'name': 'QR code thông minh',
        'price': '180.000 đ',
        'image': 'assets/images/ten1.jpg',
      },
      {
        'name': 'Tag hình tim mica',
        'price': '45.000 đ',
        'image': 'assets/images/ten1.jpg',
      },
      {
        'name': 'Chip định vị GPS',
        'price': '550.000 đ',
        'image': 'assets/images/ten2.png',
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    final items = _itemsByCategory[_selectedCategory] ?? [];

    return Column(
      children: [
        SizedBox(
          height: 50,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: _categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final category = _categories[index];
              return _buildCategoryChip(category);
            },
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.8,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) => _buildItemCard(items[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryChip(String category) {
    final isSelected = _selectedCategory == category;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = category),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? HomeColors.primaryDark : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: HomeColors.primaryDark.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Text(
          category,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildItemCard(Map<String, String> item) {
    final img = item['image'];

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            ItemDetailPage.routeName,
            arguments: item,
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                color: HomeColors.softBg,
                child: (img != null && img.isNotEmpty)
                    ? Image.asset(
                        img,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Center(
                          child: Icon(
                            Icons.broken_image_outlined,
                            size: 48,
                            color: HomeColors.primaryDark,
                          ),
                        ),
                      )
                    : const Center(
                        child: Icon(
                          Icons.shopping_bag_outlined,
                          size: 60,
                          color: HomeColors.primaryDark,
                        ),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['name'] ?? '',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item['price'] ?? '',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: HomeColors.primaryDark,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
