import 'package:cloud_firestore/cloud_firestore.dart';

class HomeFirestoreService {
  final FirebaseFirestore _db;
  HomeFirestoreService({FirebaseFirestore? db}) : _db = db ?? FirebaseFirestore.instance;

  Stream<List<String>> bannersStream({int limit = 10}) {
    return _db
        .collection('banners')
        .where('isActive', isEqualTo: true)
        .orderBy('order')
        .limit(limit)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => (d.data()['imageUrl'] ?? '').toString())
            .where((url) => url.isNotEmpty)
            .toList());
  }

  Stream<List<Map<String, dynamic>>> featuredPetsRaw({int limit = 3}) {
    return _db
        .collection('pets')
        .where('isFeatured', isEqualTo: true)
        .limit(limit)
        .snapshots()
        .map((s) => s.docs.map((d) => {'id': d.id, ...d.data()}).toList());
  }

  Stream<List<Map<String, dynamic>>> featuredProductsRaw({int limit = 3}) {
    return _db
        .collection('products')
        .where('isFeatured', isEqualTo: true)
        .limit(limit)
        .snapshots()
        .map((s) => s.docs.map((d) => {'id': d.id, ...d.data()}).toList());
  }

  Stream<List<Map<String, dynamic>>> featuredServicesRaw({int limit = 3}) {
    return _db
        .collection('services')
        .where('isFeatured', isEqualTo: true)
        .limit(limit)
        .snapshots()
        .map((s) => s.docs.map((d) => {'id': d.id, ...d.data()}).toList());
  }

  Stream<List<Map<String, dynamic>>> latestArticlesRaw({int limit = 5}) {
    // tránh index rắc rối: chỉ where + limit (không orderBy)
    return _db
        .collection('articles')
        .where('isPublished', isEqualTo: true)
        .limit(limit)
        .snapshots()
        .map((s) => s.docs.map((d) => {'id': d.id, ...d.data()}).toList());
  }
}
