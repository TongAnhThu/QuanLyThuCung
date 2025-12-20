import 'package:flutter/material.dart';

import 'cart_service.dart';

class CartPage extends StatefulWidget {
  static const String routeName = '/cart';
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartService _cart = CartService.instance;

  // ✅ Pastel xanh theo #BDE0FE nhưng đậm hơn để dễ nhìn
  static const Color kPrimary = Color(0xFF8EC5FF);
  static const Color kPrimaryDark = Color(0xFF5FA8FF);

  int get _totalPrice => _cart.totalPrice();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FAFF),
      appBar: AppBar(
        backgroundColor: kPrimary,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Giỏ hàng'),
        actions: [
          if (_cart.items.isNotEmpty)
            IconButton(
              tooltip: 'Xóa tất cả',
              icon: const Icon(Icons.delete_sweep_outlined),
              onPressed: () {
                setState(() => _cart.clear());
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đã xóa toàn bộ giỏ hàng')),
                );
              },
            ),
        ],
      ),
      body: Column(
        children: [
          // Header thông tin tổng số sản phẩm
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              _cart.items.isEmpty
                  ? 'Giỏ hàng trống'
                  : 'Bạn có ${_cart.items.length} sản phẩm trong giỏ hàng',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: kPrimaryDark,
              ),
            ),
          ),

          // Danh sách sản phẩm
          Expanded(
            child: _cart.items.isEmpty
                ? const Center(
                    child: Text(
                      'Chưa có sản phẩm trong giỏ hàng',
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _cart.items.length,
                    itemBuilder: (context, index) {
                      final item = _cart.items[index];
                      return _buildCartItem(item, index);
                    },
                  ),
          ),

          // Footer: Tổng tiền + Nút thanh toán
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Tổng tiền:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '${_formatPrice(_totalPrice)} đ',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: kPrimaryDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _cart.items.isEmpty
                        ? null
                        : () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Tiến hành thanh toán'),
                              ),
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryDark,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey[300],
                      disabledForegroundColor: Colors.grey[600],
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Thanh toán',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(Map<String, dynamic> item, int index) {
    final img = (item['image'] ?? '').toString();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 1.5,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // ✅ Hình ảnh sản phẩm (hiện ảnh nếu có)
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: 74,
                height: 88,
                color: const Color(0xFFEAF4FF),
                child: img.isNotEmpty
                    ? Image.asset(
                        img,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.inventory_2_outlined,
                          size: 36,
                          color: kPrimaryDark.withOpacity(0.85),
                        ),
                      )
                    : Icon(
                        Icons.inventory_2_outlined,
                        size: 36,
                        color: kPrimaryDark.withOpacity(0.85),
                      ),
              ),
            ),
            const SizedBox(width: 12),

            // Thông tin sản phẩm
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (item['name'] ?? '').toString(),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${_formatPrice(item['price'] as int)} đ',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: kPrimaryDark,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Nút tăng/giảm số lượng
                  Row(
                    children: [
                      _buildQuantityButton(
                        icon: Icons.remove,
                        onPressed: () {
                          if ((item['quantity'] as int) > 1) {
                            setState(() => _cart.changeQuantity(index, -1));
                          }
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          '${item['quantity']}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      _buildQuantityButton(
                        icon: Icons.add,
                        onPressed: () =>
                            setState(() => _cart.changeQuantity(index, 1)),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Nút xóa
            IconButton(
              onPressed: () {
                setState(() => _cart.removeAt(index));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Đã xóa sản phẩm khỏi giỏ hàng'),
                  ),
                );
              },
              icon: const Icon(Icons.delete_outline),
              color: Colors.red[400],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: const Color(0xFFEAF4FF),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: kPrimary.withOpacity(0.55)),
        ),
        child: Icon(icon, size: 18, color: kPrimaryDark),
      ),
    );
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }
}
