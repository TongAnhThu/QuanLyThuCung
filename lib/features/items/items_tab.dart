import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../items/item_detail_page.dart';
import '../../../theme/home_colors.dart';
import '/models/san_pham_model.dart'; 

class ItemsTab extends StatefulWidget {
  const ItemsTab({super.key});

  @override
  State<ItemsTab> createState() => _ItemsTabState();
}

class _ItemsTabState extends State<ItemsTab> {
  static const String kProductsCol = 'products';
  static const String kCategoriesCol = 'categories';

  String? _selectedCategory; 

  Stream<List<String>> _categoriesStream() {
    final ref = FirebaseFirestore.instance.collection(kCategoriesCol);

    return ref
        .orderBy('order') 
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => (d.data()['name'] ?? '').toString().trim())
            .where((s) => s.isNotEmpty)
            .toList());
  }

  Query<Map<String, dynamic>> _queryByCategory(String category) {
    return FirebaseFirestore.instance
        .collection(kProductsCol)
        .where('category', isEqualTo: category);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<String>>(
      stream: _categoriesStream(),
      builder: (context, catSnap) {
        if (catSnap.hasError) {
          return Center(
            child: Text(
              "Lỗi tải danh mục: ${catSnap.error}",
              textAlign: TextAlign.center,
            ),
          );
        }

        if (!catSnap.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final categories = catSnap.data ?? const <String>[];

        if (categories.isEmpty) {
          return const Center(child: Text("Chưa có danh mục."));
        }

        final current = _selectedCategory;
        final selected = (current != null && categories.contains(current))
            ? current
            : categories.first;

        if (_selectedCategory != selected) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            setState(() => _selectedCategory = selected);
          });
        }

        final stream = _queryByCategory(selected).snapshots();

        return Column(
          children: [
            SizedBox(
              height: 50,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return _buildCategoryChip(category, selected);
                },
              ),
            ),
            const Divider(height: 1),

            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: stream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        "Lỗi tải sản phẩm: ${snapshot.error}",
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final docs = snapshot.data?.docs ?? const [];
                  final items = docs.map((d) => SanPhamModel.tuDoc(d)).toList();

                  if (items.isEmpty) {
                    return const Center(
                      child: Text("Chưa có sản phẩm trong danh mục này."),
                    );
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) =>
                        _buildItemCard(items[index]),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCategoryChip(String category, String selected) {
    final isSelected = selected == category;
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

  Widget _buildItemCard(SanPhamModel item) {
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
                child: _buildProductImage(item.hinhAnh),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.ten,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.giaHienThi,
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

  Widget _buildProductImage(String pathOrUrl) {
    final s = pathOrUrl.trim();
    if (s.isEmpty) {
      return const Center(
        child: Icon(
          Icons.shopping_bag_outlined,
          size: 60,
          color: HomeColors.primaryDark,
        ),
      );
    }

    if (s.startsWith('http://') || s.startsWith('https://')) {
      return Image.network(
        s,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Center(
          child: Icon(
            Icons.broken_image_outlined,
            size: 48,
            color: HomeColors.primaryDark,
          ),
        ),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(child: CircularProgressIndicator());
        },
      );
    }

    return Image.asset(
      s,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => const Center(
        child: Icon(
          Icons.broken_image_outlined,
          size: 48,
          color: HomeColors.primaryDark,
        ),
      ),
    );
  }
}
