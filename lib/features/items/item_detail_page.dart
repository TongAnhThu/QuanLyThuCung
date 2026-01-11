import 'package:flutter/material.dart';

import '../cart/cart_page.dart';
import '../cart/cart_service.dart';
import '/models/san_pham_model.dart'; 

class ItemDetailPage extends StatefulWidget {
  static const String routeName = '/item-detail';
  const ItemDetailPage({super.key});

  @override
  State<ItemDetailPage> createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  static const Color kPrimary = Color(0xFF8EC5FF);
  static const Color kPrimaryDark = Color(0xFF5FA8FF);

  int _qty = 1;

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final sp = ModalRoute.of(context)!.settings.arguments as SanPhamModel;

    final name = sp.ten.isNotEmpty ? sp.ten : 'Vật phẩm';
    final unitPrice = sp.gia;
    final img = sp.hinhAnh.trim();
    final desc = sp.moTa;

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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: AspectRatio(
                      aspectRatio: 16 / 10,
                      child: Container(
                        color: const Color(0xFFEAF4FF),
                        child: _buildImage(img),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

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
                        final cartItem = <String, String>{
                          'id': sp.id,
                          'category': sp.danhMuc,
                          'name': sp.ten,
                          'price': sp.gia.toString(), 
                          'image': sp.hinhAnh,
                          'desc': desc,
                        };

                        CartService.instance.addItem(cartItem, quantity: _qty);

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

  Widget _buildImage(String pathOrUrl) {
    if (pathOrUrl.isEmpty) {
      return Center(
        child: Icon(
          Icons.inventory_2_outlined,
          size: 56,
          color: kPrimaryDark.withOpacity(0.9),
        ),
      );
    }
    if (pathOrUrl.startsWith('http://') || pathOrUrl.startsWith('https://')) {
      return Image.network(
        pathOrUrl,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return const Center(child: CircularProgressIndicator());
        },
        errorBuilder: (_, __, ___) => Center(
          child: Icon(
            Icons.inventory_2_outlined,
            size: 56,
            color: kPrimaryDark.withOpacity(0.9),
          ),
        ),
      );
    }

    return Image.asset(
      pathOrUrl,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Center(
        child: Icon(
          Icons.inventory_2_outlined,
          size: 56,
          color: kPrimaryDark.withOpacity(0.9),
        ),
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
