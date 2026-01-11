import 'package:cloud_firestore/cloud_firestore.dart';

class ThuCungModel {
  final String id;

  
  final String loai;        
  final String ten;        
  final int tuoiThang;      
  final int gia;            
  final String hinhAnh;     
  final List<String> images;
  final String ghiChu;      
  final String gioiTinh;    

  const ThuCungModel({
    required this.id,
    required this.loai,
    required this.ten,
    required this.tuoiThang,
    required this.gia,
    required this.hinhAnh,
    required this.images,
    required this.ghiChu,
    required this.gioiTinh,
  });

  static int _parseInt(dynamic v) {
    if (v is int) return v;
    if (v is double) return v.toInt();
    return int.tryParse((v ?? '0').toString()) ?? 0;
  }


  static List<String> _parseImages(dynamic v) {
    if (v is List) {
      return v
          .map((e) => (e ?? '').toString().trim())
          .where((s) => s.isNotEmpty)
          .toList();
    }

    if (v is String) {
      final s = v.trim();
      if (s.isEmpty) return [];
      if (s.contains(',')) {
        return s
            .split(',')
            .map((e) => e.trim())
            .where((x) => x.isNotEmpty)
            .toList();
      }
      return [s];
    }

    return [];
  }

  static String _normalizeGender(dynamic v) {
    if (v == null) return 'Không rõ';

    if (v is bool) return v ? 'Đực' : 'Cái';

    final s = v.toString().trim().toLowerCase();
    if (s.isEmpty) return 'Không rõ';

    if (s == 'đực' || s == 'duc' || s == 'male' || s == 'm' || s == '1' || s == 'true') {
      return 'Đực';
    }

    if (s == 'cái' || s == 'cai' || s == 'female' || s == 'f' || s == '0' || s == 'false') {
      return 'Cái';
    }

    return 'Không rõ';
  }

  factory ThuCungModel.tuDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};

    final ageInt = _parseInt(data['age']);
    final giaInt = _parseInt(data['price']);

    final String imageOne = (data['image'] ?? '').toString().trim();

    final List<String> imgsFromImagesField = _parseImages(data['images']);
    final List<String> imgsFromImageField = _parseImages(imageOne);

    final List<String> finalImgs =
        imgsFromImagesField.isNotEmpty ? imgsFromImagesField : imgsFromImageField;

    final String thumb = imageOne.isNotEmpty
        ? (imgsFromImageField.isNotEmpty ? imgsFromImageField.first : imageOne)
        : (finalImgs.isNotEmpty ? finalImgs.first : '');

    return ThuCungModel(
      id: doc.id,
      loai: (data['type'] ?? 'dog').toString(),
      ten: (data['name'] ?? '').toString(),
      tuoiThang: ageInt,
      gia: giaInt,
      hinhAnh: thumb,
      images: finalImgs,
      ghiChu: (data['ghiChu'] ?? '').toString(),

   
      gioiTinh: _normalizeGender(data['gioiTinh'] ?? data['gender']),
    );
  }

  Map<String, dynamic> toMap() => {
        'type': loai,
        'name': ten,
        'age': tuoiThang,
        'price': gia,
        'image': hinhAnh,      
        'images': images,      
        'ghiChu': ghiChu,      
        'gioiTinh': gioiTinh,  
      };


  String get tuoiHienThi => '$tuoiThang tháng';
  String get giaHienThi => _formatVnd(gia);
  String get gioiTinhHienThi => gioiTinh;

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
