import 'package:cloud_firestore/cloud_firestore.dart';

class SanPhamModel {
  final String id;
  final String danhMuc; // Firestore: category
  final String ten;     // Firestore: name
  final int gia;        // Firestore: price (number)
  final String hinhAnh; // Firestore: image

  const SanPhamModel({
    required this.id,
    required this.danhMuc,
    required this.ten,
    required this.gia,
    required this.hinhAnh,
  });

  factory SanPhamModel.tuDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};

    // price có thể là int hoặc double -> ép về int
    final rawPrice = data['price'];
    final int giaInt = (rawPrice is int)
        ? rawPrice
        : (rawPrice is double)
            ? rawPrice.toInt()
            : int.tryParse((rawPrice ?? '0').toString()) ?? 0;

    return SanPhamModel(
      id: doc.id,
      danhMuc: (data['category'] ?? '').toString(),
      ten: (data['name'] ?? '').toString(),
      gia: giaInt,
      hinhAnh: (data['image'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toMap() => {
        'category': danhMuc,
        'name': ten,
        'price': gia, // number
        'image': hinhAnh,
      };

  // ====== Hiển thị giá: 7.000.000 đ ======
  String get giaHienThi => _formatVnd(gia);

  static String _formatVnd(int value) {
    final s = value.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final pos = s.length - i;
      buf.write(s[i]);
      if (pos > 1 && pos % 3 == 1) buf.write('.');
    }
    return '${buf.toString()} đ';
  }
}
