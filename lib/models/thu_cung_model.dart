import 'package:cloud_firestore/cloud_firestore.dart';

class ThuCungModel {
  final String id;
  final String loai;    // Firestore: type (dog/cat)
  final String ten;     // Firestore: name
  final int tuoiThang;  // Firestore: age (number, tính theo tháng)
  final int gia;        // Firestore: price (number)
  final String hinhAnh; // Firestore: image

  const ThuCungModel({
    required this.id,
    required this.loai,
    required this.ten,
    required this.tuoiThang,
    required this.gia,
    required this.hinhAnh,
  });

  factory ThuCungModel.tuDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};

    final rawAge = data['age'];
    final int ageInt = (rawAge is int)
        ? rawAge
        : (rawAge is double)
            ? rawAge.toInt()
            : int.tryParse((rawAge ?? '0').toString()) ?? 0;

    final rawPrice = data['price'];
    final int giaInt = (rawPrice is int)
        ? rawPrice
        : (rawPrice is double)
            ? rawPrice.toInt()
            : int.tryParse((rawPrice ?? '0').toString()) ?? 0;

    return ThuCungModel(
      id: doc.id,
      loai: (data['type'] ?? 'dog').toString(),
      ten: (data['name'] ?? '').toString(),
      tuoiThang: ageInt,
      gia: giaInt,
      hinhAnh: (data['image'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toMap() => {
        'type': loai,
        'name': ten,
        'age': tuoiThang, // number (tháng)
        'price': gia,     // number
        'image': hinhAnh,
      };

  // ====== Hiển thị tuổi & giá ======
  String get tuoiHienThi => '$tuoiThang tháng';
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
