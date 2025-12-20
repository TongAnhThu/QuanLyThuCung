import 'package:flutter/material.dart';
import '../cart/cart_page.dart';
import '../cart/cart_service.dart';

class ItemDetailPage extends StatefulWidget {
  static const String routeName = '/item-detail';
  const ItemDetailPage({super.key});

  @override
  State<ItemDetailPage> createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  // Pastel xanh theo #BDE0FE nhưng đậm hơn
  static const Color kPrimary = Color(0xFF8EC5FF);
  static const Color kPrimaryDark = Color(0xFF5FA8FF);

  int _qty = 1;

  int _parsePrice(String text) {
    final digits = text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) return 0;
    return int.parse(digits);
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final item =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;

    final name = item['name'] ?? 'Vật phẩm';
    final priceText = item['price'] ?? '0';
    final unitPrice = _parsePrice(priceText);
    final img = (item['image'] ?? '').toString();
    final desc = (item['desc'] ?? '').toString();

    final total = unitPrice * _qty;

    return Scaffold(
      backgroundColor: const Color(0xFFF6FAFF),
      appBar: AppBar(
        backgroundColor: kPrimary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Chi tiết vật phẩm'),
        actions: [
          IconButton(
            tooltip: 'Giỏ hàng',
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () => Navigator.pushNamed(context, CartPage.routeName),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ảnh sản phẩm
                  ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: AspectRatio(
                      aspectRatio: 16 / 10,
                      child: Container(
                        color: const Color(0xFFEAF4FF),
                        child: img.isNotEmpty
                            ? Image.asset(
                                img,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Center(
                                  child: Icon(
                                    Icons.inventory_2_outlined,
                                    size: 56,
                                    color: kPrimaryDark.withOpacity(0.9),
                                  ),
                                ),
                              )
                            : Center(
                                child: Icon(
                                  Icons.inventory_2_outlined,
                                  size: 56,
                                  color: kPrimaryDark.withOpacity(0.9),
                                ),
                              ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Tên + giá
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF4FF),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: kPrimary.withOpacity(0.55)),
                        ),
                        child: Text(
                          '${_formatPrice(unitPrice)} đ',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: kPrimaryDark,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          const Icon(
                            Icons.verified_rounded,
                            size: 18,
                            color: kPrimaryDark,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Hàng chính hãng',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Mô tả
                  const Text(
                    'Mô tả',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    desc.isNotEmpty ? desc : 'Chưa có mô tả cho sản phẩm này.',
                    style: TextStyle(
                      fontSize: 14.5,
                      color: Colors.grey[800],
                      height: 1.55,
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Chọn số lượng
                  const Text(
                    'Số lượng',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _qtyBtn(
                        icon: Icons.remove,
                        onTap: () {
                          if (_qty > 1) setState(() => _qty--);
                        },
                      ),
                      Container(
                        width: 54,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: kPrimary.withOpacity(0.55)),
                        ),
                        child: Text(
                          '$_qty',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      _qtyBtn(
                        icon: Icons.add,
                        onTap: () => setState(() => _qty++),
                      ),
                      const Spacer(),
                      Text(
                        'Tạm tính: ${_formatPrice(total)} đ',
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          color: kPrimaryDark,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Bottom bar: total + add to cart
          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Tổng',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${_formatPrice(total)} đ',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: kPrimaryDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 46,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        CartService.instance.addItem(item, quantity: _qty);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Đã thêm "$name" vào giỏ hàng'),
                            action: SnackBarAction(
                              label: 'Xem giỏ',
                              onPressed: () => Navigator.pushNamed(
                                context,
                                CartPage.routeName,
                              ),
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryDark,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: const Icon(Icons.add_shopping_cart_outlined),
                      label: const Text(
                        'Thêm vào giỏ',
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _qtyBtn({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFFEAF4FF),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: kPrimary.withOpacity(0.55)),
        ),
        child: Icon(icon, color: kPrimaryDark),
      ),
    );
  }
}
