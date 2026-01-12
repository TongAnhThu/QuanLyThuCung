import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String id;
  final String title;
  final String content;
  final String sourceName;
  final String? image;        // ✅ mới (có thể null)
  final DateTime? createdAt;  // ✅ thời gian tạo

  const PostModel({
    required this.id,
    required this.title,
    required this.content,
    required this.sourceName,
    required this.image,
    required this.createdAt,
  });

  static String _s(dynamic v) => (v ?? '').toString();

  factory PostModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};

    final ts = data['createdAt'];
    DateTime? created;
    if (ts is Timestamp) created = ts.toDate();

    final img = _s(data['image']).trim(); // có thể "" => coi như không có ảnh

    return PostModel(
      id: doc.id,
      title: _s(data['title']),
      content: _s(data['content']),
      sourceName: _s(data['sourceName']),
      image: img.isEmpty ? null : img, // ✅ rỗng => null
      createdAt: created,
    );
  }
}
