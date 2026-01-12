import 'package:flutter/material.dart';

import 'cart_service.dart';
import 'checkout_page.dart';

class CartPage extends StatefulWidget {
  static const String routeName = '/cart';
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartService _cart = CartService.instance;

  // Màu chủ đạo
  static const Color kPrimary = Color(0xFF8EC5FF);
  static const Color kPrimaryDark = Color(0xFF5FA8FF);

  int get _selectedTotal => _cart.selectedTotalPrice();

  @override
  Widget build(BuildContext context) {
    final hasItems = _cart.items.isNotEmpty;
    final selectedCount = _cart.selectedItems.length;
    final selectedTotal = _selectedTotal;

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
          if (hasItems)
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
          // Header thông tin tổng số sản phẩm + chọn tất cả
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hasItems
                      ? 'Bạn có ${_cart.items.length} sản phẩm trong giỏ hàng'
                      : 'Giỏ hàng trống',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: kPrimaryDark,
                  ),
                ),
                if (hasItems) ...[
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: selectedCount == _cart.items.length,
                            onChanged: (v) =>
                                setState(() => _cart.selectAll(v ?? false)),
                            activeColor: kPrimaryDark,
                          ),
                          const Text(
                            'Chọn tất cả',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      Text(
                        selectedCount > 0
                            ? '$selectedCount được chọn'
                            : 'Chưa chọn sản phẩm',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
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
                      selectedCount > 0
                          ? '${_formatPrice(selectedTotal)} đ'
                          : '0 đ',
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
                    onPressed: selectedCount == 0
                        ? null
                        : () {
                            Navigator.pushNamed(
                              context,
                              CheckoutPage.routeName,
                              arguments: {
                                'items': _cart.selectedItems,
                                'total': selectedTotal,
                              },
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
    final isSelected = item['selected'] == true;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 1.5,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Hình ảnh sản phẩm
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

            // Checkbox chọn + nút xóa
            Column(
              children: [
                Checkbox(
                  value: isSelected,
                  onChanged: (v) =>
                      setState(() => _cart.toggleSelected(index, v ?? false)),
                  activeColor: kPrimaryDark,
                ),
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
