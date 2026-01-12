import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:appshopbanthucung/Profile/EditProfile.dart';

class ProfilePage extends StatefulWidget {
  static const String routeName = '/profile';
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static const Color kPrimaryDark = Color(0xFF1E90FF);
  static const Color kSoftBg = Color(0xFFE8F2FF);

  static const String kUsersCol = 'users'; // ✅ đổi nếu DB cậu khác

  final _auth = FirebaseAuth.instance;

  Future<void> _logout() async {
    await _auth.signOut();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/login', (r) => false);
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = _auth.currentUser;

    if (currentUser == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF1F4F7),
        appBar: AppBar(
          title: const Text('Thông tin cá nhân'),
          backgroundColor: kPrimaryDark,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: const Center(child: Text('Vui lòng đăng nhập')),
      );
    }

    final docStream = FirebaseFirestore.instance
        .collection(kUsersCol)
        .doc(currentUser.uid)
        .snapshots();

    return Scaffold(
      backgroundColor: const Color(0xFFF1F4F7),
      appBar: AppBar(
        title: const Text('Thông tin cá nhân'),
        backgroundColor: kPrimaryDark,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'Đăng xuất',
            onPressed: _logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: docStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          }

          final data = snapshot.data?.data() ?? {};

          final name =
              ((data['displayName'] ?? '').toString().trim().isNotEmpty)
              ? data['displayName'].toString()
              : (currentUser.displayName ?? 'Pet Lover');

          final email = ((data['email'] ?? '').toString().trim().isNotEmpty)
              ? data['email'].toString()
              : (currentUser.email ?? 'Chưa có email');

          final phone =
              ((data['phoneNumber'] ?? '').toString().trim().isNotEmpty)
              ? data['phoneNumber'].toString()
              : 'Chưa cập nhật';

          final address = ((data['address'] ?? '').toString().trim().isNotEmpty)
              ? data['address'].toString()
              : 'Chưa cập nhật';

          final avatar =
              ((data['avatarUrl'] ?? '').toString().trim().isNotEmpty)
              ? data['avatarUrl'].toString()
              : 'assets/images/user_avatar.png';

          final ImageProvider avatarProvider = avatar.startsWith('http')
              ? NetworkImage(avatar)
              : AssetImage(avatar);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // ===== Header card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 34,
                        backgroundColor: kSoftBg,
                        backgroundImage: avatarProvider,
                        child: const SizedBox.shrink(),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF13353F),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              email,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: kSoftBg,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: const Text(
                                'Tài khoản khách hàng',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: kPrimaryDark,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // ===== Info card
                _infoCard(
                  title: 'Thông tin',
                  children: [
                    _infoRow(Icons.phone_outlined, 'Số điện thoại', phone),
                    const Divider(height: 18),
                    _infoRow(Icons.location_on_outlined, 'Địa chỉ', address),
                  ],
                ),

                const SizedBox(height: 14),

                // ===== Actions
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.black.withOpacity(0.05)),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(
                          Icons.edit_outlined,
                          color: kPrimaryDark,
                        ),
                        title: const Text(
                          'Chỉnh sửa thông tin',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () async {
                          await Navigator.pushNamed(
                            context,
                            EditProfilePage.routeName,
                          );
                          // ✅ Không cần reload: StreamBuilder tự cập nhật
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(
                          Icons.lock_outline,
                          color: kPrimaryDark,
                        ),
                        title: const Text(
                          'Đổi mật khẩu',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () async {
                          final mail = currentUser.email;
                          if (mail == null || mail.isEmpty) return;

                          await FirebaseAuth.instance.sendPasswordResetEmail(
                            email: mail,
                          );

                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Đã gửi email đặt lại mật khẩu'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _logout,
                    icon: const Icon(Icons.logout),
                    label: const Text('Đăng xuất'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _infoCard({required String title, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: Color(0xFF13353F),
            ),
          ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: kPrimaryDark),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF13353F),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
