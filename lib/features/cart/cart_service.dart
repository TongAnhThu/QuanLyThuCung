class CartService {
  CartService._();
  static final CartService instance = CartService._();

  final List<Map<String, dynamic>> _items = [];
  List<Map<String, dynamic>> get items => _items;

  // ✅ Thêm thú cưng (giữ nguyên)
  void addPet(Map<String, String> pet) {
    final name = pet['name'] ?? 'Thú cưng';
    final priceText = pet['price'] ?? '0';
    final priceValue = _parsePrice(priceText);

    // tách theo type để không bị trùng với vật phẩm cùng tên
    final existingIndex = _items.indexWhere(
      (e) => (e['type'] ?? 'pet') == 'pet' && e['name'] == name,
    );

    if (existingIndex != -1) {
      _items[existingIndex]['quantity'] =
          (_items[existingIndex]['quantity'] as int) + 1;
      return;
    }

    _items.add({
      'type': 'pet',
      'name': name,
      'price': priceValue,
      'priceText': priceText,
      'quantity': 1,
      'image': pet['image'] ?? '',
      'age': pet['age'] ?? '',
    });
  }

  // ✅ Thêm vật phẩm (MỚI)
  // item: {'name':..., 'price': '45.000 đ', 'image': 'assets/...jpg'}
  void addItem(Map<String, String> item, {int quantity = 1}) {
    final name = item['name'] ?? 'Vật phẩm';
    final priceText = item['price'] ?? '0';
    final priceValue = _parsePrice(priceText);

    final existingIndex = _items.indexWhere(
      (e) => (e['type'] ?? 'item') == 'item' && e['name'] == name,
    );

    if (existingIndex != -1) {
      _items[existingIndex]['quantity'] =
          (_items[existingIndex]['quantity'] as int) + quantity;

      // cập nhật ảnh nếu trước đó trống
      final oldImg = (_items[existingIndex]['image'] ?? '').toString();
      final newImg = (item['image'] ?? '').toString();
      if (oldImg.isEmpty && newImg.isNotEmpty) {
        _items[existingIndex]['image'] = newImg;
      }
      return;
    }

    _items.add({
      'type': 'item',
      'name': name,
      'price': priceValue,
      'priceText': priceText,
      'quantity': quantity,
      'image': item['image'] ?? '',
      // optional nếu sau này muốn có mô tả
      'desc': item['desc'] ?? '',
    });
  }

  void changeQuantity(int index, int delta) {
    if (index < 0 || index >= _items.length) return;
    final current = _items[index]['quantity'] as int;
    final next = current + delta;
    if (next <= 0) return;
    _items[index]['quantity'] = next;
  }

  void removeAt(int index) {
    if (index < 0 || index >= _items.length) return;
    _items.removeAt(index);
  }

  int totalPrice() {
    return _items.fold<int>(
      0,
      (sum, item) => sum + (item['price'] as int) * (item['quantity'] as int),
    );
  }

  void clear() => _items.clear();

  int _parsePrice(String text) {
    final digits = text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) return 0;
    return int.parse(digits);
  }
}
