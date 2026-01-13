import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  String _fmtMoney(num v) => NumberFormat.decimalPattern('vi').format(v);

  num? _readNum(dynamic v) {
    if (v == null) return null;
    if (v is num) return v;

    if (v is String) {
      
      final digits = v.replaceAll(RegExp(r'[^0-9]'), '');
      if (digits.isEmpty) return null;
      return num.tryParse(digits);
    }

    return null;
  }

  String _pickPriceText(Map<String, dynamic> data, {List<String>? keys}) {
    final priceKeys = keys ??
        const [
          'price',
          'gia',
          'giá',
          'cost',
          'amount',
          'unitPrice',
        ];

    for (final k in priceKeys) {
      final val = _readNum(data[k]);
      if (val != null && val > 0) {
        return '${_fmtMoney(val)} đ';
      }
    }
    return '';
  }

  String _pickImage(Map<String, dynamic> data) {
    final direct = (data['image'] ?? '').toString().trim();
    if (direct.isNotEmpty) return direct;

    final imgs = data['images'];
    if (imgs is List && imgs.isNotEmpty) {
      final first = imgs.first.toString().trim();
      if (first.isNotEmpty) return first;
    }

    return (data['imageUrl'] ??
            data['hinhAnh'] ??
            data['hinhAnhUrl'] ??
            data['coverUrl'] ??
            '')
        .toString()
        .trim();
  }

  Stream<List<Map<String, String>>> _petsStream({int limit = 3}) {
    return _db.collection('pets').limit(limit).snapshots().map((snap) {
      return snap.docs.map((doc) {
        final data = doc.data();
        return {
          'name': (data['name'] ?? '').toString(),
          'subtitle': _pickPriceText(data), 
          'image': _pickImage(data),
        };
      }).toList();
    });
  }

  Stream<List<Map<String, String>>> _productsStream({int limit = 3}) {
    return _db.collection('products').limit(limit).snapshots().map((snap) {
      return snap.docs.map((doc) {
        final data = doc.data();
        return {
          'name': (data['name'] ?? '').toString(),
          'subtitle': _pickPriceText(data), 
          'image': _pickImage(data),
        };
      }).toList();
    });
  }

  Stream<List<Map<String, String>>> _servicesStream({int limit = 3}) {
    return _db.collection('services').limit(limit).snapshots().map((snap) {
      return snap.docs.map((doc) {
        final data = doc.data();
        return {
          'name': (data['name'] ?? data['ten'] ?? '').toString(),
          'subtitle': _pickPriceText(data),
          'image': _pickImage(data),
        };
      }).toList();
    });
  }

  Stream<List<Map<String, String>>> _articlesStream({int limit = 3}) {
    return _db.collection('articles').limit(limit).snapshots().map((snap) {
      return snap.docs.map((doc) {
        final data = doc.data();
        return {
          'name': (data['title'] ?? '').toString(),
          'subtitle': '', 
          'image': _pickImage(data),
        };
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final banners = HomeData.banners;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                    itemBuilder: (_, i) =>
                        Image.asset(banners[i], fit: BoxFit.cover),
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
                            color: active
                                ? Colors.white
                                : Colors.white70.withOpacity(0.6),
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
