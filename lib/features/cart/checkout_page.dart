import 'package:flutter/material.dart';
import 'cart_service.dart';
import 'purchase_history_service.dart';

class CheckoutPage extends StatefulWidget {
  static const String routeName = '/checkout';
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String _selectedPaymentMethod = 'qrcode'; // 'qrcode' or 'bank'
  late List<Map<String, dynamic>> _items;
  late int _total;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final List<Map<String, dynamic>> items;
    final int total;

    if (args is Map<String, dynamic>) {
      final rawItems = args['items'];
      final rawTotal = args['total'];
      items = (rawItems is List)
          ? rawItems
              .whereType<Map<String, dynamic>>()
              .map((e) => Map<String, dynamic>.from(e))
              .toList()
          : <Map<String, dynamic>>[];
      total = rawTotal is int ? rawTotal : 0;
    } else {
      items = const [];
      total = 0;
    }

    // Lưu vào state để sử dụng trong xử lý thanh toán
    _items = items;
    _total = total;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Xác nhận thanh toán'),
      ),
      body: items.isEmpty
          ? const Center(child: Text('Không có sản phẩm được chọn'))
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final name = (item['name'] ?? '').toString();
                      final price = item['price'] as int? ?? 0;
                      final qty = item['quantity'] as int? ?? 1;
                      final img = (item['image'] ?? '').toString();
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                width: 64,
                                height: 64,
                                color: const Color(0xFFEAF4FF),
                                child: img.isNotEmpty
                                    ? Image.asset(
                                        img,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => const Icon(
                                          Icons.inventory_2_outlined,
                                          size: 26,
                                          color: Colors.grey,
                                        ),
                                      )
                                    : const Icon(
                                        Icons.inventory_2_outlined,
                                        size: 26,
                                        color: Colors.grey,
                                      ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text('Số lượng: $qty'),
                                ],
                              ),
                            ),
                            Text(
                              _formatPrice(price * qty),
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1D4ED8),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                // Payment method selection
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.grey[100],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Phương thức thanh toán',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedPaymentMethod = 'qrcode'),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: _selectedPaymentMethod == 'qrcode'
                                        ? const Color(0xFF1E90FF)
                                        : Colors.grey[300]!,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                  color: _selectedPaymentMethod == 'qrcode'
                                      ? const Color(0xFF1E90FF).withOpacity(0.1)
                                      : Colors.transparent,
                                ),
                                child: Column(
                                  children: [
                                    const Icon(Icons.qr_code_2, size: 28),
                                    const SizedBox(height: 4),
                                    Text(
                                      'QR Code',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: _selectedPaymentMethod == 'qrcode'
                                            ? const Color(0xFF1E90FF)
                                            : Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedPaymentMethod = 'bank'),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: _selectedPaymentMethod == 'bank'
                                        ? const Color(0xFF1E90FF)
                                        : Colors.grey[300]!,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                  color: _selectedPaymentMethod == 'bank'
                                      ? const Color(0xFF1E90FF).withOpacity(0.1)
                                      : Colors.transparent,
                                ),
                                child: Column(
                                  children: [
                                    const Icon(Icons.account_balance, size: 28),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Ngân hàng',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: _selectedPaymentMethod == 'bank'
                                            ? const Color(0xFF1E90FF)
                                            : Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Tổng thanh toán',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            _formatPrice(total),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF1D4ED8),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () => _handlePayment(context, total),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E90FF),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Xác nhận thanh toán',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
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

  void _handlePayment(BuildContext context, int amount) {
    if (_selectedPaymentMethod == 'qrcode') {
      _showQRPayment(context, amount);
    } else {
      _showBankPayment(context, amount);
    }
  }

  void _showQRPayment(BuildContext context, int amount) {
    try {
      // Tạo dữ liệu QR code cho thanh toán
      showDialog(
        context: context,
        builder: (context) => Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Quét mã QR để thanh toán',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Hiển thị QR code
                  Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.qr_code_2, size: 80),
                          const SizedBox(height: 16),
                          Text(
                            _formatPrice(amount),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Thông tin thanh toán:',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _bankInfoRow('Ngân hàng', 'Vietcombank'),
                        const SizedBox(height: 8),
                        _bankInfoRow('Số tài khoản', '1234567890'),
                        const SizedBox(height: 8),
                        _bankInfoRow('Số tiền', _formatPrice(amount)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Hủy'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Save to purchase history
                          PurchaseHistoryService.instance.addPurchase(
                            items: _items,
                            totalAmount: _total,
                            paymentMethod: 'QR Code',
                          );

                          // Clear cart
                          CartService.instance.clear();

                          // Close dialog and show success
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Thanh toán QR thành công!'),
                              backgroundColor: Colors.green,
                            ),
                          );

                          // Navigate back to home
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E90FF),
                        ),
                        child: const Text(
                          'Xác nhận thanh toán',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e')),
      );
    }
  }

  void _showBankPayment(BuildContext context, int amount) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Thông tin chuyển khoản',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _bankInfoRow('Ngân hàng', 'Vietcombank'),
                      const SizedBox(height: 12),
                      _bankInfoRow('Số tài khoản', '1234567890'),
                      const SizedBox(height: 12),
                      _bankInfoRow('Tên tài khoản', 'Shop Thú Cưng'),
                      const SizedBox(height: 12),
                      _bankInfoRow('Số tiền', _formatPrice(amount)),
                      const SizedBox(height: 12),
                      _bankInfoRow('Nội dung', 'Thanh toán hóa đơn'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Hủy'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Save to purchase history
                        PurchaseHistoryService.instance.addPurchase(
                        items: _items,
                        totalAmount: _total,
                        paymentMethod: 'Chuyển khoản',
                      );

                      // Clear cart
                      CartService.instance.clear();

                      // Close dialog and show success
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Thanh toán chuyển khoản thành công!'),
                          backgroundColor: Colors.green,
                        ),
                      );

                      // Navigate back to home
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E90FF),
                    ),
                    child: const Text(
                      'Xác nhận',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bankInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  String _formatPrice(int price) {
    final text = price.toString();
    final buf = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      final pos = text.length - i;
      buf.write(text[i]);
      if (pos > 1 && pos % 3 == 1) buf.write('.');
    }
    return '$buf đ';
  }
}
