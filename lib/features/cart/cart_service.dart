class CartService {
  CartService._();
  static final CartService instance = CartService._();

  final List<Map<String, dynamic>> _items = [];

  List<Map<String, dynamic>> get items => _items;

  void addPet(Map<String, String> pet) {
    final name = pet['name'] ?? 'Thú cưng';
    final priceText = pet['price'] ?? '0';
    final priceValue = _parsePrice(priceText);
    final existingIndex = _items.indexWhere((e) => e['name'] == name);
    if (existingIndex != -1) {
      _items[existingIndex]['quantity'] =
          (_items[existingIndex]['quantity'] as int) + 1;
      return;
    }
    _items.add({
      'name': name,
      'price': priceValue,
      'priceText': priceText,
      'quantity': 1,
      'image': pet['image'] ?? '',
      'age': pet['age'] ?? '',
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
