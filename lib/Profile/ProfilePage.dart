import 'package:appshopbanthucung/Profile/EditProfile.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  static const String routeName = '/profile';
  const ProfilePage({super.key});

  static const Color kPrimaryDark = Color(0xFF1E90FF);
  static const Color kSoftBg = Color(0xFFE8F2FF);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final user = (args is Map<String, dynamic>) ? args : <String, dynamic>{};

    final name = (user['name'] ?? 'Pet Lover').toString();
    final email = (user['email'] ?? 'petshop@example.com').toString();
    final phone = (user['phone'] ?? 'Chưa cập nhật').toString();
    final address = (user['address'] ?? 'Chưa cập nhật').toString();
    final avatar = (user['avatar'] ?? 'assets/images/user_avatar.png')
        .toString();

    return Scaffold(
      backgroundColor: const Color(0xFFF1F4F7),
      appBar: AppBar(
        title: const Text('Thông tin cá nhân'),
        backgroundColor: kPrimaryDark,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header card
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
                    backgroundImage: AssetImage(avatar),
                    onBackgroundImageError: (_, __) {},
                    child: const SizedBox.shrink(),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF13353F),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          email,
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

            // Info card
            _infoCard(
              title: 'Thông tin',
              children: [
                _infoRow(Icons.phone_outlined, 'Số điện thoại', phone),
                const Divider(height: 18),
                _infoRow(Icons.location_on_outlined, 'Địa chỉ', address),
              ],
            ),

            const SizedBox(height: 14),

            // Actions
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

                    onTap: () {
                      Navigator.pop(context); // đóng drawer
                      Navigator.pushNamed(context, EditProfilePage.routeName);
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
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Chưa làm đổi mật khẩu 😄'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
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
