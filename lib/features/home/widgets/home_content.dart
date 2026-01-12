import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../data/home_data.dart';
import '../widgets/home_section.dart';

class HomeContent extends StatelessWidget {
  final PageController bannerCtrl;
  final int bannerIndex;
  final ValueChanged<int> onBannerChanged;
  final ValueChanged<int> onChangeTabIndex;

  const HomeContent({
    super.key,
    required this.bannerCtrl,
    required this.bannerIndex,
    required this.onBannerChanged,
    required this.onChangeTabIndex,
  });

  FirebaseFirestore get _db => FirebaseFirestore.instance;

  String _pickImage(Map<String, dynamic> data) {
    // ưu tiên field image
    final direct = (data['image'] ?? '').toString().trim();
    if (direct.isNotEmpty) return direct;

    // nếu có mảng images thì lấy tấm đầu
    final imgs = data['images'];
    if (imgs is List && imgs.isNotEmpty) {
      final first = imgs.first.toString().trim();
      if (first.isNotEmpty) return first;
    }

    // fallback thêm vài key hay gặp
    return (data['imageUrl'] ??
            data['hinhAnh'] ??
            data['hinhAnhUrl'] ??
            data['coverUrl'] ??
            '')
        .toString()
        .trim();
  }

  Stream<List<Map<String, String>>> _petsStream({int limit = 3}) {
    // pets: { name, image, images, age, type, ... }
    return _db.collection('pets').limit(limit).snapshots().map((snap) {
      return snap.docs.map((doc) {
        final data = doc.data();
        return {
          'name': (data['name'] ?? '').toString(),
          'subtitle': '', // cậu bảo không cần giá/tuổi
          'image': _pickImage(data), // assets/images/...
        };
      }).toList();
    });
  }

  Stream<List<Map<String, String>>> _productsStream({int limit = 3}) {
    // products: { name, image, price, category, ... }
    return _db.collection('products').limit(limit).snapshots().map((snap) {
      return snap.docs.map((doc) {
        final data = doc.data();
        return {
          'name': (data['name'] ?? '').toString(),
          'subtitle': '', // không cần giá
          'image': _pickImage(data),
        };
      }).toList();
    });
  }

  Stream<List<Map<String, String>>> _servicesStream({int limit = 3}) {
    // services: tùy cậu đặt field, nhưng cứ lấy name + image
    return _db.collection('services').limit(limit).snapshots().map((snap) {
      return snap.docs.map((doc) {
        final data = doc.data();
        return {
          'name': (data['name'] ?? data['ten'] ?? '').toString(),
          'subtitle': '',
          'image': _pickImage(data),
        };
      }).toList();
    });
  }

  Stream<List<Map<String, String>>> _articlesStream({int limit = 3}) {
    // articles: { title, content, sourceName, createdAt }
    // bài viết thường không có image => để image rỗng cho HomeCard hiện icon
    return _db.collection('articles').limit(limit).snapshots().map((snap) {
      return snap.docs.map((doc) {
        final data = doc.data();
        return {
          'name': (data['title'] ?? '').toString(),
          'subtitle': '', // không cần
          'image': _pickImage(data), // nếu sau này cậu thêm coverUrl/image thì tự lên
        };
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final banners = HomeData.banners; // ✅ banner local

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ====== HERO BANNER (LOCAL) ======
          Container(
            height: screenHeight * 0.32,
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  PageView.builder(
                    controller: bannerCtrl,
                    itemCount: banners.length,
                    onPageChanged: onBannerChanged,
                    itemBuilder: (_, i) => Image.asset(banners[i], fit: BoxFit.cover),
                  ),
                  Positioned(
                    bottom: 12,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(banners.length, (i) {
                        final active = i == bannerIndex;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: active ? 16 : 7,
                          height: 7,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(99),
                            color: active ? Colors.white : Colors.white70.withOpacity(0.6),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ====== BÀI VIẾT ======
               

                // ====== PETS ======
                StreamBuilder<List<Map<String, String>>>(
                  stream: _petsStream(limit: 3),
                  builder: (context, snap) {
                    final items = snap.data ?? const [];
                    return HomeSection(
                      title: 'Thú cưng nổi bật',
                      items: items,
                      icon: Icons.pets,
                      onViewMore: () => onChangeTabIndex(1),
                    );
                  },
                ),
                const SizedBox(height: 18),

                // ====== PRODUCTS ======
                StreamBuilder<List<Map<String, String>>>(
                  stream: _productsStream(limit: 3),
                  builder: (context, snap) {
                    final items = snap.data ?? const [];
                    return HomeSection(
                      title: 'Vật phẩm',
                      items: items,
                      icon: Icons.inventory_2_outlined,
                      onViewMore: () => onChangeTabIndex(3),
                    );
                  },
                ),
                const SizedBox(height: 18),

                // ====== SERVICES ======
                StreamBuilder<List<Map<String, String>>>(
                  stream: _servicesStream(limit: 3),
                  builder: (context, snap) {
                    final items = snap.data ?? const [];
                    return HomeSection(
                      title: 'Dịch vụ',
                      items: items,
                      icon: Icons.spa_outlined,
                      onViewMore: () => onChangeTabIndex(4),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
