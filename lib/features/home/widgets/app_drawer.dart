import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../services/user_my_bookings_page.dart'; // hoặc page route của cậu
import '../about_page.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // ✅ Header: hiện tên + gmail
          StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snap) {
              final user = snap.data;

              final name = (user?.displayName?.trim().isNotEmpty == true)
                  ? user!.displayName!.trim()
                  : 'Pet Lover';

              final email = user?.email ?? 'Chưa đăng nhập';

              final photoUrl = user?.photoURL;

              return UserAccountsDrawerHeader(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF7AB9FF), Color(0xFF1E90FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                accountName: Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                accountEmail: Text(
                  email,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: Colors.white,
                  ),
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: (photoUrl != null && photoUrl.isNotEmpty)
                      ? NetworkImage(photoUrl)
                      : const AssetImage('assets/images/user_avatar.png')
                            as ImageProvider,
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Thông tin người dùng'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/profile');
            },
          ),
          ListTile(
            leading: const Icon(Icons.receipt_long_outlined),
            title: const Text('Lịch sử mua hàng'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/purchase-history');
            },
          ),
          ListTile(
            leading: const Icon(Icons.receipt_long_outlined),
            title: const Text('Lịch sử dịch vụ'),
            onTap: () {
              Navigator.pop(context);
              // ✅ sửa đúng routeName trang lịch dịch vụ của cậu
              Navigator.pushNamed(context, UserServiceBookingsPage.routeName);
            },
          ),
          
          // ✅ Menu Admin - chỉ hiện khi user là admin
          if (currentUser != null)
            FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('userdata')
                  .doc(currentUser.uid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data?.exists == true) {
                  final data = snapshot.data!.data() as Map<String, dynamic>?;
                  final isAdmin = data?['isAdmin'] == true;
                  
                  if (isAdmin) {
                    return Column(
                      children: [
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.admin_panel_settings, color: Color(0xFF1E90FF)),
                          title: const Text(
                            'Quản trị hệ thống',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E90FF),
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, '/admin');
                          },
                        ),
                        const Divider(height: 1),
                      ],
                    );
                  }
                }
                return const SizedBox.shrink();
              },
            ),
          
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About us'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AboutPage.routeName);
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Đăng xuất'),
            onTap: () async {
              Navigator.pop(context);
              await FirebaseAuth.instance.signOut();
              if (!context.mounted) return;
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}
