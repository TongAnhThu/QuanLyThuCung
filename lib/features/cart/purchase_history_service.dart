import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PurchaseHistoryService {
  PurchaseHistoryService._();
  static final PurchaseHistoryService instance = PurchaseHistoryService._();

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  // Thêm mua hàng vào Firestore
  Future<void> addPurchase({
    required List<Map<String, dynamic>> items,
    required int totalAmount,
    required String paymentMethod,
  }) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    await _firestore.collection('usercardhistory').add({
      'userId': userId,
      'items': items,
      'totalAmount': totalAmount,
      'paymentMethod': paymentMethod,
      'timestamp': FieldValue.serverTimestamp(),
      'status': 'Hoàn thành',
    });
  }

  // Lấy lịch sử của user hiện tại
  Stream<List<Map<String, dynamic>>> getUserPurchaseHistory() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return Stream.value([]);

    return _firestore
        .collection('usercardhistory')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }

  // Lấy tất cả lịch sử (chỉ dành cho admin)
  Stream<List<Map<String, dynamic>>> getAllPurchaseHistory() {
    return _firestore
        .collection('usercardhistory')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }

  // Xóa một giao dịch
  Future<void> removePurchase(String id) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception('Người dùng chưa đăng nhập');
    }

    // Kiểm tra xem đơn hàng có thuộc về user này không
    final doc = await _firestore.collection('usercardhistory').doc(id).get();
    if (!doc.exists) {
      throw Exception('Đơn hàng không tồn tại');
    }

    final data = doc.data();
    final ownerId = data?['userId'] as String?;
    
    // Chỉ cho phép xóa nếu là chủ sở hữu hoặc admin
    final userDoc = await _firestore.collection('userdata').doc(userId).get();
    final isAdmin = userDoc.data()?['isAdmin'] == true;
    
    if (ownerId != userId && !isAdmin) {
      throw Exception('Không có quyền xóa đơn hàng này');
    }

    await _firestore.collection('usercardhistory').doc(id).delete();
  }
}
