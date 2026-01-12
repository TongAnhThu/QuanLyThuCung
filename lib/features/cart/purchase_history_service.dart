class PurchaseHistoryService {
  PurchaseHistoryService._();
  static final PurchaseHistoryService instance = PurchaseHistoryService._();

  final List<Map<String, dynamic>> _history = [];
  List<Map<String, dynamic>> get history => List.unmodifiable(_history);

  // Thêm mua hàng vào lịch sử
  void addPurchase({
    required List<Map<String, dynamic>> items,
    required int totalAmount,
    required String paymentMethod,
  }) {
    _history.insert(0, {
      'id': DateTime.now().millisecondsSinceEpoch,
      'items': List<Map<String, dynamic>>.from(items),
      'totalAmount': totalAmount,
      'paymentMethod': paymentMethod,
      'timestamp': DateTime.now(),
      'status': 'Hoàn thành',
    });
  }

  // Lấy lịch sử
  List<Map<String, dynamic>> getPurchaseHistory() {
    return _history;
  }

  // Xóa một giao dịch
  void removePurchase(int id) {
    _history.removeWhere((e) => e['id'] == id);
  }

  // Xóa tất cả
  void clearHistory() {
    _history.clear();
  }
}
