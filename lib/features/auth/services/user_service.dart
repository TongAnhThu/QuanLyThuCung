import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/user_profile_model.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _usersCollection = 'userdata';

  // Tạo profile mới cho user vừa đăng ký
  Future<void> createUserProfile({
    required String uid,
    required String email,
    required String displayName,
  }) async {
    try {
      final userProfile = UserProfile(
        uid: uid,
        email: email,
        displayName: displayName,
        isProfileComplete: false, // Chưa hoàn thành profile
        createdAt: DateTime.now(),
      );

      await _firestore
          .collection(_usersCollection)
          .doc(uid)
          .set(userProfile.toFirestore());
    } catch (e) {
      throw 'Không thể tạo hồ sơ người dùng: $e';
    }
  }

  // Lấy profile của user
  Future<UserProfile?> getUserProfile(String uid) async {
    try {
      final doc = await _firestore
          .collection(_usersCollection)
          .doc(uid)
          .get();

      if (!doc.exists) return null;

      return UserProfile.fromFirestore(doc);
    } catch (e) {
      throw 'Không thể lấy thông tin người dùng: $e';
    }
  }

  // Cập nhật profile (sau khi user hoàn tất setup lần đầu)
  Future<void> updateUserProfile({
    required String uid,
    String? displayName,
    String? phoneNumber,
    String? address,
    String? avatarUrl,
    bool? isProfileComplete,
  }) async {
    try {
      final updates = <String, dynamic>{
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (displayName != null) updates['displayName'] = displayName;
      if (phoneNumber != null) updates['phoneNumber'] = phoneNumber;
      if (address != null) updates['address'] = address;
      if (avatarUrl != null) updates['avatarUrl'] = avatarUrl;
      if (isProfileComplete != null) updates['isProfileComplete'] = isProfileComplete;

      await _firestore
          .collection(_usersCollection)
          .doc(uid)
          .update(updates);
    } catch (e) {
      throw 'Không thể cập nhật thông tin: $e';
    }
  }

  // Stream theo dõi profile (nếu cần realtime update)
  Stream<UserProfile?> userProfileStream(String uid) {
    return _firestore
        .collection(_usersCollection)
        .doc(uid)
        .snapshots()
        .map((doc) {
      if (!doc.exists) return null;
      return UserProfile.fromFirestore(doc);
    });
  }
}
